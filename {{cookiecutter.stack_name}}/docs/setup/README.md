# Developer setup

Install the tools below before `make setup && make check`. Pick your OS:

| Guide | Platform |
|-------|----------|
| [macos.md](macos.md) | macOS (Apple Silicon or Intel) |
| [linux.md](linux.md) | Ubuntu / Debian / WSL2 |
| [windows.md](windows.md) | Windows (WSL2 recommended) |

## Required tools

| Tool | Version | Used for |
|------|---------|----------|
| **Terraform** | `~> 1.9.0` — see [`.terraform-version`](../../.terraform-version) | `make check`, `plan` |
| **Make** | any | Makefile targets |
| **Git** | any | version control, rules submodule |
| **Azure CLI** (`az`) | recent | `make preflight`, bootstrap, plan |

Verify after install:

```bash
terraform version   # must be 1.9.x
make setup
```

## Optional tools (skipped if missing)

| Tool | Gate |
|------|------|
| **tflint** | `make check` — lint |
| **trivy** | `make check` — config scan |
| **conftest** | `make plan` — policy on `plan.json` (needs `.cursor/rules` submodule) |

## Version managers

Pin Terraform **1.9.8** (see `.terraform-version` and `.tool-versions` in the repo). With **asdf**, `cd` into the repo is enough if shims are on PATH.

- **asdf** 0.16+ — shims in PATH only; no `asdf.sh` (see [macos.md](macos.md))
- **tfenv**
- OS package manager or HashiCorp zip — ensure the binary is **1.9.x**, not latest

If multiple Terraform installs exist (e.g. Homebrew + asdf), the **1.9.x** binary must win in `PATH`.
