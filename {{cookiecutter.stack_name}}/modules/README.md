# modules/

Azure **substrate** module contracts — born from accepted ADRs, shaped by
`module-structure.mdc`, promoted to `terraform-azure-modules` when a second
consumer appears.

## What is seeded here

Common platform building blocks most enterprise stacks need. Each folder is a
**contract only** (README + future `tests/` when implemented) — nothing is wired
into `envs/*` on day one.

| Module | Role |
|--------|------|
| `virtual-network` | VNet, subnets, NSGs, private DNS links |
| `aks` | Kubernetes substrate |
| `key-vault` | Secrets and certificates |
| `storage-account` | Blob/file/diagnostics storage |
| `log-analytics` | Observability / diagnostics sink |
| `postgres-flexible-server` | Managed relational DB (common default) |
| `azure-cache-redis` | Managed cache (common default) |

## What is not seeded

Product-specific data-plane components (e.g. Kafka, ClickHouse, CrateDB) are
**not** in the scaffold. They are added under `modules/` as the project
progresses — each requires an accepted ADR and matching spec in the same PR.

## Rules

- Seeded folders are **contracts, not implementations** — see each README.
- Wiring any module into an env root requires its accepted ADR (`infra-adr.mdc`).
- If you're adding a resource block to an env root instead of a module here: stop.
