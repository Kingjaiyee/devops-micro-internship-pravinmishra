# Ansible Ad-Hoc Lab

**Owner:** Victor Durojaiye ([GitHub: Kingjaiyee](https://github.com/Kingjaiyee))
**Context:** DevOps Micro Internship (DMI) Cohort 3, Week 9, Assignment 2
**Status:** Torn down on 28 September 2026 after evidence was captured. The IPs in `ansible/inventory.ini` no longer belong to this lab.

## Summary

Terraform provisions four Ubuntu 24.04 servers on AWS. The Ansible controller from Assignment 01 (WSL2 on Windows) manages them with ad-hoc commands, targeting all servers or a single inventory group.

## Choices

| Item | Choice |
|---|---|
| Cloud | AWS, eu-north-1 (Option B) |
| Servers | Four: web1, web2, app1, db1 on `t3.micro` |
| SSH | From the controller public IP only (`/32`), on every server |
| HTTP | From the controller public IP only (`/32`), web servers only |
| SSH key | The controller ED25519 key from Assignment 01 (public key only uploaded) |

| Server | Ansible group | Security groups |
|---|---|---|
| web1 | web | base, web |
| web2 | web | base, web |
| app1 | app | base |
| db1 | db | base |

## Layout

```text
ansible-adhoc-lab/
├── README.md
├── ansible/
│   ├── ansible.cfg      # Lab config. Ansible reads ansible.cfg from the current directory only
│   └── inventory.ini    # Generated from terraform output, grouped by web, app and db
└── terraform/
    ├── .terraform.lock.hcl
    ├── lab.env          # Local only (gitignored): AWS profile, region, live controller IP lookup
    ├── main.tf          # VPC, subnet, security groups, key pair, four instances via for_each
    ├── outputs.tf       # public_ips, private_ips, server_groups, inventory_ini
    ├── providers.tf
    └── variables.tf
```

## Run it

```bash
# 1. Provision
cd terraform
source lab.env                      # every new terminal
terraform init
terraform plan -out=tfplan          # review: 12 to add
terraform apply tfplan

# 2. Trust host keys only after comparing the SSH fingerprint with the
#    fingerprint in the instance console output (aws ec2 get-console-output)

# 3. Generate the inventory and run commands
cd ../ansible
terraform -chdir=../terraform output -raw inventory_ini > inventory.ini
ansible-inventory -i inventory.ini --graph
ansible all -i inventory.ini -m ping

# 4. Tear down
cd ../terraform
terraform plan -destroy -out=destroy.tfplan
terraform apply destroy.tfplan
```

After teardown, remove the old host keys with `ssh-keygen -R <ip>` for each server.

## Design decisions

- **One resource, four servers:** `for_each` over a `servers` map where each key is the server name and each value is its group.
- **Controller IP never in a file:** passed as `TF_VAR_controller_ip` and marked `sensitive`, so plan and apply print `(sensitive value)`. It is still in the local state file, which is gitignored.
- **Readable output:** cloud-init sets each hostname to its role, and inventory hosts use role names with `ansible_host` for the IP.
- **No typed IPs:** the inventory comes from Terraform output.
- **Hardening:** IMDSv2 required, encrypted gp3 root volumes, no public HTTP.

## Gotchas

- Ansible ignored the parent `ansible.cfg` when run from `ansible/`. Fixed with a lab-level config.
- Fresh Ubuntu runs updates at first boot, which can lock apt. Wait for `cloud-init status --wait` before package tasks.
- OpenSSH adds a host's other key types to `known_hosts` automatically after the first trusted connection, so each host ended up with three entries. `ssh-keygen -R` removes them all.
