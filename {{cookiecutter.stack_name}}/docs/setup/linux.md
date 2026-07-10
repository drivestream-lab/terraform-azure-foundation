# Linux / WSL2 setup

Works on Ubuntu, Debian, and **WSL2 on Windows** (recommended Windows path).

## Terraform 1.9.8 (required)

**Option A — HashiCorp apt repo:**

```bash
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform=1.9.8-*
```

**Option B — asdf:**

```bash
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0
# or install asdf via your distro / package manager (0.16+)
asdf plugin add terraform
asdf install terraform 1.9.8
cd <this-repo> && asdf set terraform 1.9.8
```

For asdf 0.16+, add only shims to PATH in `~/.bashrc` / `~/.zshrc`:

```bash
export ASDF_DATA_DIR="${ASDF_DATA_DIR:-$HOME/.asdf}"
export PATH="$ASDF_DATA_DIR/shims:$PATH"
```

**Option C — tfenv** — see [tfenv](https://github.com/tfutils/tfenv)

## Make and Git

```bash
sudo apt install make git
```

## Azure CLI

```bash
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
az login
```

## Optional gates

```bash
# tflint — see https://github.com/terraform-linters/tflint
# trivy — see https://aquasecurity.github.io/trivy/
# conftest — see https://www.conftest.dev/install/
```

## Verify

```bash
terraform version
make setup && make check
```
