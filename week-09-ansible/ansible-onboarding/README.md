# Ansible Onboarding Workstation

**Owner:** Victor Durojaiye ([GitHub: Kingjaiyee](https://github.com/Kingjaiyee))
**Context:** DevOps Micro Internship (DMI) Cohort 3, Week 9, Assignment 1

## Summary

This project is my Ansible controller workstation. Ansible and its linting tools live in a project Python virtual environment, so nothing touches the system Python and every teammate gets the same pinned versions from `requirements.txt`. VS Code, EditorConfig, a baseline `ansible.cfg`, SSH key authentication and pre-commit hooks are all set up so the next Ansible assignments start from a known, repeatable state.

## Workstation details

| Component | Value |
|---|---|
| Host | Windows with WSL2 |
| Linux distribution | Ubuntu 24.04 |
| Project location | `~/ansible-onboarding` (Linux filesystem, not `/mnt/c`) |
| Python | 3.12.3, project venv at `.venv/` |
| ansible-core | 2.21.4 |
| ansible-lint | 26.9.0 |
| yamllint | 1.38.0 |
| pre-commit | 4.6.2 |
| Editor | VS Code over WSL with the Ansible, YAML, Python and EditorConfig extensions |
| SSH key | ED25519 at `~/.ssh/id_ed25519`, loaded by a shared ssh-agent on shell start |

## Project layout

```text
ansible-onboarding/
├── .ansible-lint            # ansible-lint profile and excluded paths
├── .editorconfig            # Cross-editor formatting rules (2 spaces, LF, UTF-8)
├── .gitignore               # Keeps .venv, keys, secrets and runtime files out of Git
├── .pre-commit-config.yaml  # Hooks run on every commit, pinned to requirements.txt versions
├── .vscode/
│   └── settings.json        # Points VS Code and the Ansible extension at .venv
├── .yamllint                # yamllint rules compatible with ansible-lint
├── README.md
├── ansible.cfg              # Project-wide Ansible defaults
├── inventories/             # Inventory files (added in later assignments)
├── requirements.txt         # Frozen Python tool versions
└── roles/                   # Project roles (added in later assignments)
```

## Daily use

```bash
cd ~/ansible-onboarding
source .venv/bin/activate          # VS Code terminals do this automatically
ansible --version                  # config file must point at this project's ansible.cfg
pre-commit run --all-files         # run all checks without committing
```

## New Machine? Do This

- [ ] 1. Install WSL2 with Ubuntu 24.04 (`wsl --install -d Ubuntu-24.04`) and store the Linux password somewhere safe.
- [ ] 2. Install system packages: `sudo apt update && sudo apt install -y python3-venv python3-pip git`.
- [ ] 3. Put the project in the Linux home (`~/ansible-onboarding`), never under `/mnt/c`. Ansible ignores `ansible.cfg` in world-writable folders.
- [ ] 4. Create the venv and install pinned tools: `python3 -m venv .venv && source .venv/bin/activate && python -m pip install -r requirements.txt`.
- [ ] 5. Open the folder from WSL with `code .`, check the bottom-left says WSL: Ubuntu, install the Ansible, YAML, Python and EditorConfig extensions, and select `./.venv/bin/python` as the interpreter.
- [ ] 6. Check for an existing key with `ls ~/.ssh`. Only if none exists, run `ssh-keygen -t ed25519 -C "<name>-ansible-wsl" -f ~/.ssh/id_ed25519`, then `chmod 600 ~/.ssh/id_ed25519`.
- [ ] 7. Create `~/.ssh/config` with ServerAliveInterval, ServerAliveCountMax, AddKeysToAgent, IdentityFile, IdentitiesOnly and StrictHostKeyChecking ask, then `chmod 600 ~/.ssh/config`.
- [ ] 8. Add the shared ssh-agent block to `~/.bashrc` so the key is loaded in every new terminal, and confirm with `ssh-add -l`.
- [ ] 9. Create `~/.ssh/known_hosts` and verify each host fingerprint against its official source before trusting it.
- [ ] 10. Set Git identity: `git config --global user.name`, `user.email` and `init.defaultBranch main`.
- [ ] 11. Run `pre-commit install`, then `git add -A && pre-commit run --all-files` until every hook passes.
- [ ] 12. Final check: `ansible --version` shows this project's `ansible.cfg`, and `git status` shows no `.venv`, keys or `.env` files.

## Gotchas hit during setup

- **No sudo password on WSL:** reset it from PowerShell with `wsl -d Ubuntu-24.04 -u root`, then `passwd <user>`.
- **`python3 -m venv` fails:** the `python3-venv` package is missing. Install it, then delete the half-built `.venv` before recreating it.
- **`stdout_callback = yaml` no longer exists:** use `stdout_callback = default` with `callback_result_format = yaml`.
- **ansible-lint hook asks for Python 3.14:** its hook manifest requests `python3.14`. The config overrides it with `language_version: python3`.
- **ssh-agent disappears in new terminals:** agents are per session. The `~/.bashrc` block reuses one agent on a fixed socket.

## Security notes

- Private keys, `.venv/`, `.env` files and vault password files are in `.gitignore`, and the `detect-private-key` hook blocks any commit containing a private key.
- Only the public key (`id_ed25519.pub`) is ever copied to managed hosts.
- `host_key_checking = True` in `ansible.cfg` stops Ansible from silently trusting a changed host key.
