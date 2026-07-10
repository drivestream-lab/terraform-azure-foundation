# Windows setup

**Recommended:** use **WSL2** (Ubuntu) and follow [linux.md](linux.md). This stack uses
bash (`scripts/preflight.sh`) and GNU **make** — WSL matches the Makefile contract.

## WSL2 (recommended)

1. `wsl --install` (Ubuntu)
2. Open Ubuntu terminal; follow [linux.md](linux.md)
3. Clone / generate the stack inside the Linux filesystem (`~/...`), not `/mnt/c/...`

## Native Windows (limited)

Native is possible but awkward: no bash preflight, make requires extra tooling.

| Tool | Install |
|------|---------|
| Terraform 1.9.8 | `winget install Hashicorp.Terraform` — **verify** `terraform version` is 1.9.x |
| Azure CLI | `winget install Microsoft.AzureCLI` |
| Make | `choco install make` or use Git Bash / WSL |
| Git | `winget install Git.Git` |

Run `make check` from Git Bash or WSL. Prefer WSL for `make preflight` and bootstrap.

## Verify (WSL)

```bash
terraform version
make setup && make check
```
