# Mini Finance on Azure with Terraform and Ansible

**Owner:** Victor Durojaiye ([GitHub: Kingjaiyee](https://github.com/Kingjaiyee))
**Context:** DevOps Micro Internship (DMI) Cohort 3, Week 9, Assignment 4
**Cloud:** Microsoft Azure, Sweden Central

## Summary

Terraform builds an Ubuntu 24.04 VM on Azure with its network and firewall rules. An Ansible playbook with three plays then installs Nginx, Git and rsync, deploys the Mini Finance website from GitHub, and checks from my controller that the site answers with HTTP 200. Terraform owns the infrastructure, Ansible owns what runs on it.

## Architecture

| Resource | Name | Purpose |
|---|---|---|
| Resource group | `rg-mini-finance` | Holds everything for this project |
| Virtual network and subnet | `vnet-mini-finance`, `snet-mini-finance` | Private network for the VM (10.40.0.0/16) |
| Public IP | `pip-mini-finance` | Static Standard IP for SSH and the website |
| Network security group | `nsg-mini-finance` | `Allow-SSH` (22) from my controller IP only, `Allow-HTTP` (80) from the internet |
| Network interface | `nic-mini-finance` | Connects the VM to the subnet and public IP, with the NSG attached |
| Virtual machine | `vm-mini-finance` | Ubuntu 24.04, `Standard_B1s`, hostname `mini-finance`, SSH key login only |

## Project structure

```text
mini-finance/
├── .gitignore
├── README.md
├── ansible/
│   ├── ansible.cfg      # Loaded because the playbook runs from this folder
│   ├── inventory.ini    # Generated from terraform output
│   └── site.yml         # Three plays: install, deploy, verify
└── terraform/
    ├── .terraform.lock.hcl
    ├── lab.env          # Local only (gitignored): subscription and controller IP lookups
    ├── main.tf
    ├── outputs.tf
    ├── providers.tf
    └── variables.tf
```

The playbook needs the `ansible.posix` collection, declared in `requirements.yml` at the repo root.

## How the playbook works

| Play | Runs on | What it does |
|---|---|---|
| 1. Install Nginx, Git and rsync | `web` | Installs the three packages, refreshing the apt cache only if it is older than an hour, then starts and enables Nginx |
| 2. Deploy the Mini Finance website | `web` | Clones the repo at a pinned commit to `/opt/mini-finance`, then rsyncs it into `/var/www/html/` as `www-data:www-data`, excluding `.git` and removing old files |
| 3. Verify the website | `localhost` | Requests the site over HTTP from the controller and asserts HTTP 200 and that the default Nginx page is gone |

The **Reload nginx** handler only runs when the rsync task reports a change.

## How to run it

```bash
# Infrastructure
cd terraform && source lab.env
terraform fmt && terraform init && terraform validate
terraform plan -out=tfplan && terraform apply tfplan

# Trust the host key only after it matches the fingerprint from the VM itself
# (az vm run-command or the boot diagnostics log), then:
cd ../ansible
terraform -chdir=../terraform output -raw inventory_ini > inventory.ini
ansible-galaxy collection install -r ../../requirements.yml
ansible-playbook -i inventory.ini site.yml --syntax-check
ansible-playbook -i inventory.ini site.yml

# Tear down
cd ../terraform && terraform plan -destroy -out=destroy.tfplan && terraform apply destroy.tfplan
```

## Security choices

- SSH is allowed only from my controller public IP (`/32`). HTTP is open to the internet because it is a public website.
- Password login is disabled. The VM only accepts my controller ED25519 key, and only the public key was uploaded.
- My subscription ID and home IP are looked up at run time by `lab.env` and never written to a committed file.
- The host key was trusted only after it matched the fingerprint read from inside the VM through the Azure API.
- Terraform state, plans and `lab.env` are gitignored.

## Issues and fixes

- **Azure had no capacity for `Standard_B2ats_v2`** in Sweden Central (`AllocationFailed`). The size was allowed for my subscription but no hardware was free, so I switched to `Standard_B1s`.
- **The failed VM stayed in Azure but not in Terraform state**, which would have blocked the next apply with a name conflict. I deleted the failed VM with the Azure CLI, confirmed Azure matched the state, then applied again.
- **My first host key check compared the wrong key type.** The Azure boot log comes back as one JSON string, so my parser picked the RSA fingerprint instead of ED25519. I confirmed the real key through `az vm run-command` before trusting it.
- **The commit-time lint failed on `ansible.posix.synchronize`** even though the playbook worked, because the pre-commit hook runs in its own environment without collections. Declaring the collection in `requirements.yml` fixed it.

## What I learned

- Terraform and Ansible fit together cleanly: Terraform outputs the public IP, and that output becomes the Ansible inventory.
- "Allowed for your subscription" and "available right now" are different things in the cloud. Capacity can fail even when quota is fine.
- Pinning the Git commit makes the deployment reproducible and keeps the playbook idempotent.
- A verification play that runs from outside the server proves the site is really reachable, not just that the tasks finished.
