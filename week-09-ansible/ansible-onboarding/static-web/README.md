# Static Website on Two Servers with a Multi-Play Ansible Playbook

**Owner:** Victor Durojaiye ([GitHub: Kingjaiyee](https://github.com/Kingjaiyee))
**Context:** DevOps Micro Internship (DMI) Cohort 3, Week 9, Assignment 3
**Cloud:** AWS, eu-north-1

## Summary

One Ansible playbook, `site.yml`, installs Nginx on two Ubuntu 24.04 servers, deploys a personalized `index.html` to both, and then checks from the controller that both sites answer with HTTP 200 and show my name. The servers are built with a small Terraform config in `terraform/` and are destroyed after the evidence is captured.

## Project structure

```text
static-web/
├── README.md
├── ansible.cfg          # Loaded because the playbook runs from this folder
├── files/
│   └── index.html       # The website, personalized with my name in the footer
├── inventory.ini        # Generated from terraform output: web1 and web2 in [web]
├── site.yml             # Three plays: install, deploy, verify
└── terraform/           # VPC, security groups, key pair and two EC2 instances
```

## How the playbook works

| Play | Runs on | What it does |
|---|---|---|
| 1. Install and configure Nginx | `web` | Installs Nginx, refreshing the apt cache only if it is older than an hour, then starts and enables the service |
| 2. Deploy the static website | `web` | Copies `files/index.html` to `/var/www/html/index.html` as `www-data`, mode `0644`, and notifies a handler |
| 3. Verify both websites | `localhost` | Requests each server over HTTP with the `uri` module and asserts HTTP 200 plus my name in the page |

The **Reload nginx** handler only runs when the copy task reports a change, so Nginx is not reloaded on runs where the site did not change.

## How to run it

```bash
# Build the servers
cd terraform && source lab.env
terraform init && terraform plan -out=tfplan && terraform apply tfplan

# Trust each host key only after it matches the fingerprint in the instance console output,
# then generate the inventory
cd ..
terraform -chdir=terraform output -raw inventory_ini > inventory.ini

# Check, run, verify
ansible-playbook -i inventory.ini site.yml --syntax-check
ansible-playbook -i inventory.ini site.yml
curl -I http://<web1-ip>
curl -I http://<web2-ip>

# Tear down
cd terraform && terraform plan -destroy -out=destroy.tfplan && terraform apply destroy.tfplan
```

## Results

| Run | web1 | web2 | localhost |
|---|---|---|---|
| First | ok=6 changed=3 | ok=6 changed=3 | ok=2 changed=0 |
| Second | ok=5 changed=0 | ok=5 changed=0 | ok=2 changed=0 |

On the first run the three changes were the Nginx install, the file copy and the handler reload. On the second run nothing changed and the handler did not run, which proves the playbook is idempotent.

## Security choices

- SSH and HTTP are allowed only from my controller public IP (`/32`). The IP is passed as `TF_VAR_controller_ip` and never written to a committed file.
- Host keys were trusted only after matching the fingerprint each server printed to its boot console.
- The SSH key is the controller ED25519 key from Assignment 01. Only the public key was uploaded.
- Terraform state, plans and `lab.env` are gitignored.

## Issues and fixes

- **A standalone apt cache update task reports `changed` on every run**, so a second run could never show `changed=0`. I folded the refresh into the install task with `cache_valid_time: 3600`.
- **Ansible only reads `ansible.cfg` from the current directory**, so this project has its own copy instead of relying on the one at the repo root.
- **My pre-commit hooks would have trimmed whitespace in `index.html` at commit time**, making the repo copy differ from the deployed copy and breaking idempotency on the next run. I ran the hooks on the file before the first deploy.

## What I learned

- Splitting a playbook into install, deploy and verify plays makes each part easy to read, re-run and debug on its own.
- Handlers tie a restart or reload to a real change instead of running it every time.
- Checking the page content, not just the status code, is what proves the right file was deployed.
- Idempotency is something you design for. A task that always reports `changed` hides real changes.
