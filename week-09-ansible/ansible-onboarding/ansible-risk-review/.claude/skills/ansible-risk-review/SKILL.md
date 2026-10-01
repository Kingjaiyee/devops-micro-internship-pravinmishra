---
name: ansible-risk-review
description: Run the read-only Ansible check and diff review script, analyze the generated report, and recommend whether the playbook needs human review before applying. Never runs the playbook without --check.
allowed-tools: Bash(bash ansible-check-review.sh:*), Read, Grep
disable-model-invocation: true
---

# Ansible Risk Review Skill

When /ansible-risk-review is invoked:

1. Read CLAUDE.md before doing anything else.

2. Run exactly this command from the project root:

   bash ansible-check-review.sh

   Exit code 0 means HEALTHY, 1 means WARN, 2 means FAIL. A non-zero exit
   code is a result to report, not an error to retry or fix.

3. Read:

   reports/ansible-risk-report.txt
   reports/ansible-check-raw.txt

4. Report, in this order:

   - Full Name from the report header
   - Overall status and script exit code
   - Every changed task from the report
   - Which tasks are flagged risky
   - The risk category
   - The likely real-world impact, using the --diff output as evidence
   - One clear recommendation

5. If no changes were detected, clearly state that the playbook appears to be
   a no-op against the current server state.

6. Do not edit files.

7. Do not use sudo.

8. Never run ansible-playbook without --check.

9. Never apply, converge, or fix anything automatically.

10. Ask the human to review the report and run the real ansible-playbook
    command only if they decide to proceed.
