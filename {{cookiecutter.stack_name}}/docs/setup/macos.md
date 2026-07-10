# macOS setup

## Terraform 1.9.8 (required)

**Option A — asdf (Homebrew)** — good when you manage multiple versions:

```bash
brew install asdf
asdf plugin add terraform
asdf install terraform 1.9.8
cd <this-repo>
asdf set terraform 1.9.8
```

Add to `~/.zshrc` (asdf **0.16+** — no `asdf.sh`):

```bash
export ASDF_DATA_DIR="${ASDF_DATA_DIR:-$HOME/.asdf}"
export PATH="$ASDF_DATA_DIR/shims:$PATH"
```

Ensure shims come **before** `/opt/homebrew/bin` so Homebrew Terraform 1.13+ does not win.

**Option B — tfenv:**

```bash
brew install tfenv
tfenv install 1.9.8
tfenv use 1.9.8
```

**Option C — HashiCorp zip:** [releases.hashicorp.com/terraform/1.9.8](https://releases.hashicorp.com/terraform/1.9.8/)

## Azure CLI

```bash
brew install azure-cli
az login
```

## Optional gates

```bash
brew install tflint trivy
brew install conftest   # or see https://www.conftest.dev/install/
```

## Verify

```bash
which terraform && terraform version
make setup && make check
```
