#!/bin/bash -i

echo "install antigravity cli"
curl -fsSL https://antigravity.google/cli/install.sh | bash

# Ensure ~/.local/bin is in PATH in ~/.bashrc if not already there
if ! grep -q '\.local/bin' "$HOME/.bashrc" 2>/dev/null; then
cat << 'EOF' >> "$HOME/.bashrc"

# set up ~/.local/bin in PATH (used by antigravity agy cli and others)
if [ -d "$HOME/.local/bin" ] && [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

EOF
fi

if [ -d "$HOME/.local/bin" ] && [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi
