# EpicBook on AWS with Terraform and Ansible Roles

Terraform builds the infrastructure. Ansible roles configure the server and deploy the app.
Nothing is installed by hand and nothing is installed by cloud-init.

## Architecture

- **VPC** `10.50.0.0/16` in eu-north-1 with one public subnet and two private DB subnets
- **EC2** `t3.small`, Ubuntu 24.04, public subnet. SSH only from the controller IP, HTTP from anywhere
- **RDS MySQL 8.4** `db.t3.micro`, private subnets, not publicly accessible, reachable only from the EC2 security group, RDS Extended Support disabled
- **Nginx** on port 80 proxies to the **Node.js** app on `127.0.0.1:8080`, kept running by **PM2**

## Layout

~~~
epicbook-prod/
├── terraform/aws/        root module + modules/network, modules/ec2, modules/rds
└── ansible/
    ├── ansible.cfg
    ├── inventory.ini     generated from terraform output
    ├── site.yml          applies roles: common, nginx, epicbook
    ├── group_vars/web.yml
    └── roles/
        ├── common/       baseline packages
        ├── nginx/        reverse proxy config, site enable, handler
        └── epicbook/     Node.js, PM2, git clone, npm ci, DB seed, PM2 start
~~~

## Secrets

- The DB password lives in `~/.config/epicbook/db-password` (mode 600), outside the repo.
- Terraform receives it through `TF_VAR_db_password` as an `ephemeral` variable and sends it with the
  write-only `password_wo` argument, so it is never stored in Terraform state.
  Check: `terraform state pull | grep -cFf ~/.config/epicbook/db-password` returns `0`.
- Ansible reads it from `group_vars/web.yml`, where it is encrypted inline with `ansible-vault encrypt_string`.
  The vault password file is `~/.config/ansible/epicbook-vault-pass` (mode 600), referenced from `ansible.cfg`.
- On the server the password only exists in two mode 0600 files: the PM2 ecosystem file and a root-only
  MySQL client option file. It is never passed on a command line.

## Deploy

~~~bash
# 1. Infrastructure
cd terraform/aws
source lab.env
terraform init
terraform apply

# 2. Inventory (then verify the host key before first connection)
cd ../../ansible
terraform -chdir=../terraform/aws output -raw inventory_ini > inventory.ini
ansible web -m ping

# 3. Configuration and deploy
ansible-playbook -i inventory.ini site.yml
~~~

## How the epicbook role stays idempotent

- The app is cloned at a pinned commit.
- `npm ci --omit=dev` runs only when the code changed or `node_modules` is missing.
- The schema and seed SQL import only when the `Book` table does not exist yet, and always before the
  app first starts, because the app's `sequelize.sync()` would otherwise create the tables first.
- PM2 starts the app only if it is not already registered. Config or code changes trigger a reload handler.

A second run of the playbook reports `changed=0`.

## Verify

~~~bash
ansible web -m command -a "systemctl is-active nginx" --become
ansible web -m command -a "pm2 status"
curl -I http://<public-ip>
curl -s -X POST http://<public-ip>/api/cart -H "Content-Type: application/json" -d '{"bookId": 1}'
~~~

## Teardown

~~~bash
cd terraform/aws
source lab.env
terraform destroy
ssh-keygen -R <public-ip>
~~~
