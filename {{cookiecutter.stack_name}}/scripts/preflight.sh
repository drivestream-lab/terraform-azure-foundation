#!/usr/bin/env bash
# preflight.sh <env> — answers ONE question: is my Azure setup fine?
# Ordered checks; each failure names the exact portal/bootstrap fix. Exit 0 = SETUP OK.
set -uo pipefail

ENV="${1:?usage: preflight.sh <env>}"
ENV_DIR="envs/${ENV}"
FINDINGS=0

ok()   { printf "✓ %s\n" "$1"; }
fail() { printf "✗ %s\n  → %s\n" "$1" "$2"; FINDINGS=$((FINDINGS+1)); }

[ -d "$ENV_DIR" ] || { echo "unknown environment '$ENV' (no $ENV_DIR)"; exit 2; }

# 1. az CLI present and logged in
if ! command -v az >/dev/null; then
  fail "Azure CLI installed" "install az (https://aka.ms/azure-cli) and run 'az login'"
  echo; echo "SETUP INCOMPLETE — $FINDINGS finding(s) above"; exit 1
fi
ACCOUNT_JSON=$(az account show -o json 2>/dev/null) \
  && ok "az CLI logged in ($(echo "$ACCOUNT_JSON" | grep -o '"name": *"[^"]*"' | head -1 | cut -d'"' -f4))" \
  || fail "az CLI logged in" "run 'az login'"

# 2. subscription_id set in tfvars and visible
SUB_ID=$(grep -Eo '^subscription_id *= *"[0-9a-f-]{36}"' "$ENV_DIR/terraform.tfvars" | cut -d'"' -f2 || true)
if [ -z "${SUB_ID:-}" ] || [ "$SUB_ID" = "00000000-0000-0000-0000-000000000000" ]; then
  fail "subscription_id set in $ENV_DIR/terraform.tfvars" "replace the TODO placeholder with the real subscription GUID"
else
  az account show --subscription "$SUB_ID" -o none 2>/dev/null \
    && ok "subscription $SUB_ID visible" \
    || fail "subscription $SUB_ID visible" "check access: Portal → Subscriptions → IAM, or 'az account set'"
fi

# 3. caller has at least Reader on the subscription
if [ -n "${SUB_ID:-}" ] && [ "$SUB_ID" != "00000000-0000-0000-0000-000000000000" ]; then
  ME=$(az ad signed-in-user show --query id -o tsv 2>/dev/null || true)
  if [ -n "$ME" ]; then
    ROLES=$(az role assignment list --assignee "$ME" --scope "/subscriptions/$SUB_ID" --include-inherited --query "[].roleDefinitionName" -o tsv 2>/dev/null || true)
    [ -n "$ROLES" ] \
      && ok "RBAC on subscription: $(echo "$ROLES" | tr '\n' ',' | sed 's/,$//')" \
      || fail "RBAC role on subscription" "ask the Owner: Subscription → IAM → add 'Reader' (or run via CI identity)"
  fi
fi

# 4. state storage account exists (name from backend.tf — set by bootstrap)
SA=$(grep -Eo 'storage_account_name *= *"[a-z0-9]+"' "$ENV_DIR/backend.tf" | cut -d'"' -f2 || true)
RG=$(grep -Eo 'resource_group_name *= *"[^"]+"' "$ENV_DIR/backend.tf" | cut -d'"' -f2 || true)
if [ -n "$SA" ]; then
  az storage account show -n "$SA" -g "$RG" -o none 2>/dev/null \
    && ok "state storage account '$SA' exists" \
    || fail "state storage account '$SA' exists" "bootstrap not run for this env? see bootstrap/README.md"
fi

# 5. state container listable with Entra auth (proves Storage Blob Data role)
if [ -n "$SA" ]; then
  az storage blob list --account-name "$SA" -c tfstate --auth-mode login -o none 2>/dev/null \
    && ok "state container readable (Entra auth)" \
    || fail "state container readable" "missing 'Storage Blob Data Contributor' on $SA → Storage account → IAM"
fi

# 6. rules submodule initialized
[ -f ".cursor/rules/infra-guidelines-index.mdc" ] \
  && ok "rules submodule initialized" \
  || fail "rules submodule initialized" "run 'make setup' (git submodule update --init)"

echo
if [ "$FINDINGS" -eq 0 ]; then
  echo "SETUP OK — proceed to: make plan ENV=$ENV"
  exit 0
else
  echo "SETUP INCOMPLETE — $FINDINGS finding(s) above"
  exit 1
fi
