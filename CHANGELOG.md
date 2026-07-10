# Changelog

All notable changes to `terraform-azure-foundation` are documented here.

---

## v0.1.2

### Summary

Accelerator-only spec tree — empty `docs/specification/` dirs; OS setup guides.

### Changes

- **Removed** spec templates: `adr/0000-template.md`, `product/README.md`, `as-built/implementation-status.md`
- **Added** empty `docs/specification/{product,adr,as-built}/` (`.gitkeep` only)
- **Added** `docs/setup/` — README + macOS, Linux/WSL, Windows install guides
- **Generated README** — links setup docs; harness/spec population called out separately; conditional `github_setup` when `ci_platform=github`
- **`make setup`** — points to `docs/setup/` when terraform missing

### Migration guide

- Regenerate from v0.1.2+ or copy `docs/setup/` and empty spec dirs into existing stacks
- Populate `docs/specification/` via your org harness

---

## v0.1.1

### Summary

Align with python-fastapi-foundation / nextjs-bff-foundation boundary — harness
out of scaffold, substrate-only module catalog.

### Changes

- **Removed** harness files from template: `AGENTS.md`, `.harness-pin.yaml`, `.gitmodules`
- **Removed** `rules_version` cookiecutter prompt
- **`make setup`** — tool checks only; no launchpad/submodule wiring
- **Removed** product data-plane module seeds: `kafka`, `clickhouse`, `cratedb`
- **`modules/README.md`** — substrate catalog + explicit ADR-gated growth model
- Added `VERSION` and `CHANGELOG.md`

### Migration guide

- Regenerate from v0.1.1+ or copy updated files into existing stacks
- Wire `.cursor/rules/` submodule and harness via launchpad separately

---

## v0.1.0

### Summary

Initial Azure Terraform cookiecutter chassis (pre-boundary-cleanup baseline).
