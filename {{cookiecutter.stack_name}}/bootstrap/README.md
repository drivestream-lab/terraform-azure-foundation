# bootstrap/ — run once, by a human Owner

Creates everything the real Terraform needs before it can run:
per-env **state storage accounts** (RBAC-only, versioned, GRS),
per-env **CI identities** (plan = Reader, apply = Contributor),
**GitHub OIDC federation** (no stored secrets), and the **RBAC grants**.

This is the **only documented exception** to the never-apply rule
(`plan-apply-workflow.mdc`): agents and CI never touch this directory.

## Procedure (once per client / subscription)

```bash
cd bootstrap
cp terraform.tfvars.example terraform.tfvars   # fill real values
terraform init
terraform apply                                 # requires Owner + Entra app-creation rights
terraform output github_setup                   # follow the GitHub wiring checklist
git add terraform.tfstate && git commit         # local state is committed on purpose (ids only)
```

Then verify from the repo root: `make preflight ENV=dev`.

## Notes

- `subscription_strategy = per-env`: run with each env's subscription and trim
  `environments` accordingly; merge the outputs.
- State storage accounts carry `prevent_destroy` — decommissioning a client is a
  deliberate, ADR-documented act.
- Adding a new environment later: extend `environments`, re-run apply, add the
  matching `envs/<env>/` root (copy an existing one) and GitHub environment.
