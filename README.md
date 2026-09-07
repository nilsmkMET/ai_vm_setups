# AI VM Setups

My standard setups on my machine for AI VMs (fork of [jerabaul29/setups](https://github.com/jerabaul29/setups)). Typically used on fresh Ubuntu installs. Assumes that it will be run non-interactive, with an empty sudo password, at the early stage of machine setup.

The main work script `main_setup.sh` assumes that this repository is cloned in `$HOME/Desktop/Git/ai_vm_setups` (or `$HOME/Desktop/Git/setups`), for example clone and install as:

```bash
mkdir -p "$HOME/Desktop/Git"
cd "$HOME/Desktop/Git"
git clone https://github.com/nilsmkMET/ai_vm_setups.git
cd ai_vm_setups
bash main_setup.sh
```

The helper `main.sh` script should work from any location and calls `main_setup.sh`.

## Components Installed and Configured

- **Standard Libraries**: Build essentials (`build-essential`, `libc6-dev`, runtime/development libraries, `lld`, `netcdf-bin`).
- **Command Line Tools**: `bash-git-prompt`, `z` directory jumping, `tree`, `fzf`, and custom productivity scripts (`zg`, `zx`, `histg`, `histx`, `sync_with_IP`, `ga`, `ct`).
- **Tmux**: Terminal multiplexer configuration based on `gpakosz/.tmux`.
- **Rust**: Latest Rust toolchain via `rustup`.
- **Helix**: AppImage installation, custom languages config, snippets, and LSPs (`codebook-lsp`, `hx-lsp`).
- **Node & AI CLIs**: Node.js via `nvm`, plus global AI assistant CLIs:
  - GitHub Copilot (`@github/copilot`)
  - Claude Code (`@anthropic-ai/claude-code`)
  - OpenAI Codex (`@openai/codex`)
- **Antigravity CLI**: Google Antigravity CLI (`agy`) via `curl -fsSL https://antigravity.google/cli/install.sh | bash`, configured with `~/.local/bin` in PATH.
- **Bash Tools**: `bash-language-server` and `shellcheck`.
- **Python**: Miniforge3/mamba with a `dev` environment containing scientific packages (`numpy`, `scipy`, `pandas`, `polars`, `matplotlib`, `xarray`, etc.) and language servers (`python-lsp-server`, `jedi-language-server`, `python-lsp-ruff`, `ty`).
- **LaTeX**: TexLive installation and language tools.
- **Encrypted Secrets Blob**: Decryption and runner utility for post-installation secrets.

## Encrypted Secrets Blob

In order to support using secrets to perform the installation, the `generate_blob.sh` file can be used to turn the content of the `generate_blob/` folder into a gzipped gpg-symmetric-encrypted file that gets added to `setup_encrypted_blob`, see the dummy example there for explanation. Once the installation above has been executed, the encrypted blob can be decrypted and the entry script run using the system-installed terminal command `> setup_encrypted_blob.sh`. By gpg-encrypting the blob with a symmetric key, the encrypted `.zip.gpg` file can be uploaded on a location where it is openly available even though the decrypted content contains secrets. Make sure to not commit or make openly available any intermediate secret! Since I use this repo myself, the blob attached is my own that does not correspond to the hello world I show here, and is encrypted with a complex passphrase, so only I can use it :) .
