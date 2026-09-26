---
name: tf-drift-review
description: Read-only Terraform drift and policy review. Runs the evidence script, reads the report and plan JSON, and explains any pending change and its risk. Never applies or destroys infrastructure.
allowed-tools: Bash, Read, Grep
---

# Terraform Drift Review

Run a read-only drift and policy review of the Terraform stack in this project.

## Steps

1. Run the evidence script and capture its exit code:

   ```
   bash "AI Assignment/tf-drift-check.sh"; echo "script exit code: $?"
   ```

2. Read `reports/tf-drift-report.txt`.
3. If any check is WARN or FAIL, read `reports/tfplan.json` and identify the
   affected resource addresses, the actions Terraform intends to take, and the
   before and after values that differ.
4. Report:
   - the overall status and each check result
   - for each finding, the resource address and the specific evidence
   - whether the difference is true infrastructure drift, meaning a change made
     outside Terraform, or a Terraform configuration change
   - the risk, stated plainly
   - a recommended action for the human to review

## Safety Rules

- This review is read only.
- Never run `terraform apply`, `terraform destroy`, or any command using
  `-auto-approve`.
- Never edit Terraform files, state files or AWS resources.
- Never call a change safe without citing the evidence that supports it. If the
  evidence is missing, say so.
- The human reviews the plan and runs any infrastructure-changing command.
