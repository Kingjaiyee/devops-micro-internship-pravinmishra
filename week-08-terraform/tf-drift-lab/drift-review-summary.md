# Terraform Drift Review Summary

**Reviewer:** Victor Durojaiye
**Project:** tf-drift-lab (AWS eu-north-1)
**Stack under review:** one VPC, one subnet, one security group with inline ingress rules
**Workflow:** Gather evidence, analyse with Agentic AI, human reviews and acts, verify the result

---

## 1. Change Introduced

I added an SSH ingress rule allowing `0.0.0.0/0` on port 22 directly to the lab security
group using the AWS CLI:

```
aws ec2 authorize-security-group-ingress --group-id <sg-id> --protocol tcp --port 22 --cidr 0.0.0.0/0
```

This was **true infrastructure drift**, not a Terraform configuration change. No Terraform
file was edited. The change was made straight against the AWS API, so the real
infrastructure moved away from what the configuration describes, and Terraform only learned
about it when it refreshed state during the next plan.

The security group's ingress rules are declared as inline `ingress` blocks rather than as
separate rule resources. That was a deliberate design choice when I built the lab: inline
rules are authoritative, so Terraform treats any rule it did not create as something to
remove. Had I used standalone `aws_vpc_security_group_ingress_rule` resources instead,
Terraform would not have managed the rogue rule at all and this drift would have been
invisible to the plan.

## 2. Evidence Collected

`tf-drift-check.sh` gathered the evidence:

- `terraform plan -detailed-exitcode` returned exit code **2**, meaning changes are pending.
  On the clean baseline the same command returned exit code 0.
- The plan was written to a binary file and converted to JSON with `terraform show -json`,
  saved as `reports/tfplan.json`.
- The affected resource was `aws_security_group.lab`, with the action `update`.
- In the plan JSON, `.change.before` for that resource contained two ingress entries: the
  expected operator `/32` rule and the rogue rule with `cidr_blocks` of `0.0.0.0/0` on port
  22. `.change.after` contained only the operator rule. Terraform intended to remove the
  rogue rule and restore the configured state.
- The `destructive_actions` check found no `delete` actions, so no resource was going to be
  removed or replaced.

## 3. Risk Assessment

The Bash checks returned `plan_status: WARN` because changes were pending, and
`open_ingress: FAIL` because an ingress rule allowed `0.0.0.0/0`. The overall status was
**FAIL**.

Claude Code's analysis, working from the report and the plan JSON, identified the same rule
and made the point that mattered: the risk is not the pending Terraform change, it is the
live state of the infrastructure. SSH was open to the entire internet on a running security
group, and had been since the moment the CLI command succeeded. The plan simply revealed
it. It also confirmed the difference was drift rather than a configuration change, because
the unwanted value appeared in the before state rather than the after state.

The secondary risk is quieter. Drift means someone or something changed infrastructure
outside the pipeline. Even after the rule is removed, the question of how it got there
remains open.

## 4. Human-Approved Action

I reviewed `terraform plan` myself and confirmed it proposed one change: an update to
`aws_security_group.lab` removing the `0.0.0.0/0` rule on port 22 and keeping the operator
`/32` rule. Nothing was being added, deleted or replaced.

I then ran `terraform apply` in my own terminal and approved it. Claude Code did not run it,
and could not have: when I asked it to, two separate controls engaged. It first declined on
its own, citing the rule in `CLAUDE.md` that only the human runs infrastructure-changing
commands. When I then asked it to attempt the command specifically so the safety gate could
be tested, the `PreToolUse` hook intercepted the Bash tool call and returned a BLOCKED
message, because the latest drift report contained `Overall Status: FAIL`.

The distinction between those two controls is worth recording. The first is an instruction,
which the agent chose to follow. The second is a deterministic gate that does not depend on
the agent choosing anything.

## 5. Verification

After the apply I ran the review again. `terraform plan -detailed-exitcode` returned exit
code 0, all three checks returned PASS, and the overall status returned to **HEALTHY** with
a script exit code of 0. The report was saved as `reports/resolved-report.txt` alongside
`reports/drift-detected-report.txt`, so the detected and resolved states are both on record.

The proof that the environment is aligned is the exit code rather than the absence of
visible errors. Exit code 0 from `-detailed-exitcode` means Terraform refreshed the real
resources against the configuration and found nothing to change.

## 6. Safety Decision

Claude Code was allowed to gather and analyse evidence because reading a plan, parsing JSON
and explaining a difference changes nothing. It was not allowed to perform
infrastructure-changing actions because those are irreversible in ways that analysis is not,
and because the judgement about whether a plan is acceptable is the part that should stay
with a person.

The controls were layered deliberately:

- `CLAUDE.md` states the rule, so the agent knows the boundary.
- The skill's `allowed-tools` limits it to Bash, Read and Grep, with no Write.
- The `PreToolUse` hook blocks `terraform apply`, `terraform destroy` and any
  `-auto-approve` command whenever the latest report says FAIL, regardless of what the
  agent decides.

The hook deliberately inspects an existing report rather than making its own judgement about
the infrastructure. That keeps it simple enough to be reliable: it answers one yes-or-no
question about a file, with no API calls, no interpretation and no way to be argued out of
its answer.

## 7. Agentic Loop Mapping

**Gather:** `tf-drift-check.sh` ran `terraform plan -detailed-exitcode`, converted the plan
to JSON, and ran three deterministic checks over it with `jq`: plan status, destructive
actions and open ingress. No interpretation, no AI, repeatable output.

**Analyse:** the `/tf-drift-review` skill read the report and the plan JSON, identified
`aws_security_group.lab` as the affected resource, established that the `0.0.0.0/0` value
was present in the before state and therefore drift rather than a configuration change,
explained the risk and recommended an action.

**Human act:** I read the plan myself, confirmed the single expected change, and ran
`terraform apply` in my own terminal. Claude's attempt to run it was blocked by the hook.

**Verify:** the review was run a second time. Exit code 0, three PASS results, overall
status HEALTHY, saved as `resolved-report.txt`.

The loop matters because each step checks a different kind of failure. Deterministic Bash
cannot be talked into a wrong answer but cannot explain anything. The AI explains well but
should not be trusted to decide. The human decides but benefits from not having to read raw
JSON. Verification catches the case where the fix did not do what everyone believed it did.
