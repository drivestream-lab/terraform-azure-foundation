# {{ cookiecutter.stack_name }}

{{ cookiecutter.stack_description }} — Azure infrastructure stack for
**{{ cookiecutter.client }}**, scaffolded from terraform-azure-foundation.

Constitution: `.cursor/rules/` (terraform-infra-rules git submodule — pin a release tag).
Truth: `docs/specification/`.

## Is my setup fine? (day-one contract)

| Stage | Command | Question answered | Needs |
|---|---|---|---|
| 1 | `make setup && make check` | Is the repo itself sound? | nothing — offline |
| 2 | `make preflight ENV=dev` | Are my creds & portal setup correct? | `az login` |
| 3 | `make plan ENV=dev` | Does the whole chain work end-to-end? | bootstrap done |

Stage 3 plans **data sources only** (`whoami`) — proves backend, lock, RBAC, and
provider with zero resources at stake. After `SETUP OK` + a green plan, add
components via spec → ADR → module implementation.

## First-time setup

```bash
make setup && make check                  # green immediately
# once per client, by a subscription Owner:
cd bootstrap && cp terraform.tfvars.example terraform.tfvars && terraform init && terraform apply
terraform output github_setup             # wire GitHub environments (OIDC, no secrets)
cd .. && make preflight ENV=dev && make plan ENV=dev
```

## Layout

```
bootstrap/    once-per-client: state storage, CI identities, OIDC, RBAC (human-only)
envs/<env>/   thin roots: backend + provider + naming + module calls — NO resources
modules/      Azure substrate contracts; wired per ADR as the project progresses
docs/specification/{product,adr,as-built}/
scripts/preflight.sh   .github/workflows/{plan,apply}.yml   Makefile
```

## Apply path

Agents and developers stop at plan. Merge → `apply` workflow → GitHub environment
approval (stage/prod) → `terraform apply` of a plan generated on main. No other
path exists; `bootstrap/` is the single documented exception.
