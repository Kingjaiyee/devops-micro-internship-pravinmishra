#!/bin/bash
# Terraform drift and policy review: evidence gathering plus deterministic checks.
# READ ONLY. This script must never run terraform apply, terraform destroy,
# or any command using -auto-approve.
set -uo pipefail

REVIEWER_NAME="Victor Durojaiye"
LAB_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TF_DIR="$LAB_ROOT/terraform"
REPORTS_DIR="$LAB_ROOT/reports"
REPORT_FILE="${1:-$REPORTS_DIR/tf-drift-report.txt}"
PLAN_BIN="$REPORTS_DIR/tfplan.binary"
PLAN_JSON="$REPORTS_DIR/tfplan.json"

checks=("plan_status" "destructive_actions" "open_ingress")

mkdir -p "$REPORTS_DIR"

plan_status_result="UNKNOWN"
destructive_result="UNKNOWN"
ingress_result="UNKNOWN"
plan_exit=99
destructive_count=0
ingress_count=0
destructive_detail=""
ingress_detail=""

gather_evidence() {
  cd "$TF_DIR" || exit 1
  terraform plan -detailed-exitcode -input=false -no-color -out="$PLAN_BIN" > /dev/null 2>&1
  plan_exit=$?
  if [ -f "$PLAN_BIN" ]; then
    terraform show -json "$PLAN_BIN" > "$PLAN_JSON" 2>/dev/null
    rm -f "$PLAN_BIN"
  fi
}

check_plan_status() {
  case "$plan_exit" in
    0) plan_status_result="PASS" ;;
    2) plan_status_result="WARN" ;;
    *) plan_status_result="FAIL" ;;
  esac
}

check_destructive_actions() {
  if [ ! -f "$PLAN_JSON" ]; then
    destructive_result="FAIL"
    destructive_detail="No plan JSON available."
    return
  fi
  destructive_count=$(jq '[.resource_changes[]? | select(any(.change.actions[]?; . == "delete"))] | length' "$PLAN_JSON")
  destructive_detail=$(jq -r '[.resource_changes[]? | select(any(.change.actions[]?; . == "delete")) | "\(.address) [\(.change.actions | join(","))]"] | join("; ")' "$PLAN_JSON")
  if [ "$destructive_count" -gt 0 ]; then
    destructive_result="FAIL"
  else
    destructive_result="PASS"
    destructive_detail="No delete or replace actions in the plan."
  fi
}

check_open_ingress() {
  if [ ! -f "$PLAN_JSON" ]; then
    ingress_result="FAIL"
    ingress_detail="No plan JSON available."
    return
  fi
  ingress_count=$(jq '
    [ .resource_changes[]?
      | select(.type == "aws_security_group")
      | .address as $a
      | (.change.before, .change.after)
      | select(. != null)
      | .ingress[]?
      | select(any(.cidr_blocks[]?; . == "0.0.0.0/0"))
    ] | length' "$PLAN_JSON")
  ingress_detail=$(jq -r '
    [ .resource_changes[]?
      | select(.type == "aws_security_group")
      | .address as $a
      | (.change.before, .change.after)
      | select(. != null)
      | .ingress[]?
      | select(any(.cidr_blocks[]?; . == "0.0.0.0/0"))
      | "\($a) port \(.from_port)-\(.to_port)/\(.protocol) open to 0.0.0.0/0"
    ] | unique | join("; ")' "$PLAN_JSON")
  if [ "$ingress_count" -gt 0 ]; then
    ingress_result="FAIL"
  else
    ingress_result="PASS"
    ingress_detail="No ingress rule allows 0.0.0.0/0."
  fi
}

overall_status() {
  if [ "$plan_status_result" = "FAIL" ] || [ "$destructive_result" = "FAIL" ] || [ "$ingress_result" = "FAIL" ]; then
    echo "FAIL"
  elif [ "$plan_status_result" = "WARN" ]; then
    echo "WARN"
  else
    echo "HEALTHY"
  fi
}

plan_status_meaning() {
  case "$plan_exit" in
    0) echo "exit 0: no pending changes, configuration and infrastructure agree" ;;
    1) echo "exit 1: terraform plan failed to run" ;;
    2) echo "exit 2: changes are pending" ;;
    *) echo "exit $plan_exit: unexpected" ;;
  esac
}

gather_evidence
check_plan_status
check_destructive_actions
check_open_ingress
STATUS=$(overall_status)

{
  echo "==========================================================="
  echo " Terraform Drift and Policy Review"
  echo "==========================================================="
  echo "Reviewer:   $REVIEWER_NAME"
  echo "Generated:  $(date -u '+%Y-%m-%d %H:%M:%S UTC')"
  echo "Project:    $TF_DIR"
  echo "Checks run: ${checks[*]}"
  echo "-----------------------------------------------------------"
  echo "[1] plan_status          : $plan_status_result"
  echo "    $(plan_status_meaning)"
  echo "[2] destructive_actions  : $destructive_result"
  echo "    Resources with a delete action: $destructive_count"
  echo "    $destructive_detail"
  echo "[3] open_ingress         : $ingress_result"
  echo "    Ingress rules open to 0.0.0.0/0: $ingress_count"
  echo "    $ingress_detail"
  echo "-----------------------------------------------------------"
  echo "Overall Status: $STATUS"
  echo "Plan JSON: $PLAN_JSON"
  echo "==========================================================="
  echo "This review is read only. No infrastructure was changed."
} | tee "$REPORT_FILE"

case "$STATUS" in
  HEALTHY) exit 0 ;;
  WARN)    exit 1 ;;
  *)       exit 2 ;;
esac
