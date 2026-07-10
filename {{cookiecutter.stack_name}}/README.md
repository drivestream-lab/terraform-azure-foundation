# {{ cookiecutter.stack_name }}

{{ cookiecutter.stack_description }} — Azure infrastructure stack for
**{{ cookiecutter.client }}**, generated from terraform-azure-foundation.

## Prerequisites

Install tools first: **[docs/setup/README.md](docs/setup/README.md)** (macOS / Linux / WSL / Windows).

Pin Terraform to the version in [`.terraform-version`](.terraform-version) / [`.tool-versions`](.tool-versions) (`~> 1.9.0`). With **asdf**, the generated `.tool-versions` selects 1.9.8 automatically.

## Is my setup fine? (day-one contract)

| Stage | Command | Question answered | Needs |
|---|---|---|---|
| 1 | `make setup && make check` | Is the repo itself sound? | nothing — offline |
| 2 | `make preflight ENV=dev` | Are my creds & portal setup correct? | `az login` |
| 3 | `make plan ENV=dev` | Does the whole chain work end-to-end? | bootstrap done |

Stage 3 plans **data sources only** (`whoami`) — proves backend, lock, RBAC, and
provider with zero resources at stake.

## First-time setup

```bash
make setup && make check                  # green immediately
# once per client, by a subscription Owner:
cd bootstrap && cp terraform.tfvars.example terraform.tfvars && terraform init && terraform apply
{% if cookiecutter.ci_platform == "github" -%}
terraform output github_setup             # wire GitHub environments (OIDC)
{% endif -%}
cd .. && make preflight ENV=dev && make plan ENV=dev
```

Wire `.cursor/rules/` (terraform-infra-rules submodule) and `docs/specification/`
via your org harness when ready — not part of this accelerator.

## Layout

```text
bootstrap/              once-per-client: state storage{% if cookiecutter.ci_platform == "github" %}, CI OIDC{% endif %}
envs/<env>/             thin roots: backend + provider + naming + module calls
modules/                substrate contracts (README stubs; wire per your ADRs)
docs/setup/             tool install guides
docs/specification/     product / adr / as-built (empty — populated by harness)
scripts/preflight.sh    Makefile
{% if cookiecutter.ci_platform == "github" -%}
.github/workflows/      plan + apply (when ci_platform=github)
{% endif -%}
```

## Makefile targets

| Target | Purpose |
|--------|---------|
| `make setup` | Verify tools on PATH |
| `make check` | Offline: fmt, validate, lint, scan |
| `make test` | Module unit tests (`terraform test`) |
| `make preflight ENV=<env>` | Azure creds + backend checks |
| `make plan ENV=<env>` | Plan + optional policy gate |

Apply workflow and governance: see `.cursor/rules/` and your harness — not defined in this scaffold.
