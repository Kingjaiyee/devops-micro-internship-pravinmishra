# Ansible Change Summary

**Full Name:** Victor Durojaiye

**Date:** 01/10/2026

## 1. Change Requested

I added one task to the end of the `common` role in my EpicBook project
(`epicbook-prod/ansible/roles/common/tasks/main.yml`):

~~~yaml
- name: Remove temporary EpicBook risk test file
  ansible.builtin.file:
    path: /tmp/epicbook-risk-test
    state: absent
~~~

Before adding it, I created `/tmp/epicbook-risk-test` on the VM with an ad-hoc command. This was a
controlled lab change to prove that the risk-review workflow catches a deletion before it is applied.

## 2. Evidence Collected

The Bash dry-run report (`reports/risky-change-report.txt`) flagged it:

~~~text
[WARN] 1 changed task(s) detected - review before applying
  - would change: common : Remove temporary EpicBook risk test file
[FAIL] 1 removal task(s) found in the changed set
  - risky (removal): common : Remove temporary EpicBook risk test file
Overall Status: FAIL - risky changes present, do not apply without review
Script Exit Code: 2
~~~

Risk category: **removal**. The `--diff` output in the raw Ansible log showed exactly what would change:

~~~diff
     path: /tmp/epicbook-risk-test
-    state: file
+    state: absent
~~~

Ansible's own dry run reported `unreachable=0 failed=0`, so the only finding was the deletion itself.
Claude Code read both reports, confirmed the same task and category, and recommended review before
applying. It did not apply anything.

## 3. Real-World Impact if Applied Blindly

A deletion cannot be undone by running the playbook again. Here the file was a disposable test file,
but the same pattern with a wrong path or a bad variable could delete an application config, uploaded
data, or a certificate on every server in the group at once. The review also showed a limit of the
check: it classifies tasks by name. A removal task with a harmless-sounding name would only be caught
as a general change, not as a removal, which is why the human still reads the diff.

## 4. Human-Approved Action

I reviewed the report, confirmed the file was the disposable test file I had created, and ran this
myself from `~/ansible-onboarding/epicbook-prod/ansible`:

~~~bash
ansible-playbook -i inventory.ini site.yml
~~~

## 5. Verification

- The real run finished with `ok=20 changed=1 unreachable=0 failed=0`. The only changed task was the
  removal.
- `ansible web -i inventory.ini -m ping` returned `pong`, so the VM is still reachable.
- `ansible.builtin.stat` on `/tmp/epicbook-risk-test` returned `exists: false`.
- A second `/ansible-risk-review` returned HEALTHY with exit code 0 (`ok=18 changed=0 failed=0`),
  saved as `reports/post-apply-report.txt`. The playbook is a no-op against the server again.

My first post-apply review did not run: the `claude` command in WSL was the Windows install of
Claude Code, so its Bash tool ran in Git Bash, where `$HOME` points to the Windows profile and the
script could not find the playbook. Claude Code reported that the review had no evidence, did not
call it a risky change, and did not retry, work around it, or apply anything. I installed Claude
Code inside WSL, added deny rules for `wsl` passthrough commands, and re-ran the review, which
returned HEALTHY.

## 6. Safety Decision

Claude Code was allowed to gather evidence (run the `--check --diff` script) and analyze it (read the
reports and explain the risk), because those steps change nothing. It was not allowed to run the
playbook for real, because applying a change is a decision with consequences that a human must own.
This was enforced, not just requested: `CLAUDE.md` sets the rules, the skill only pre-approves the
review script, and `.claude/settings.json` denies file edits and direct `ansible-playbook`, `ansible`,
`ansible-vault`, `terraform`, `sudo`, `ssh`, `rm` and `wsl` commands.

## 7. Agentic Loop Mapping

- **Gather:** the Bash script ran the playbook with `--check --diff` and saved the raw output.
- **Analyze:** the script classified the changed task as a removal, and Claude Code explained the
  impact from the diff evidence.
- **Human Act:** I reviewed the report and ran the real playbook myself.
- **Verify:** the recap, the ping, the `stat` check, and a second risk review confirmed the result.
