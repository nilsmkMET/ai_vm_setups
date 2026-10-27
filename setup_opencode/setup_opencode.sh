#!/bin/bash -i

echo "install opencode"
curl -fsSL https://opencode.ai/install | bash

# the installer adds ~/.opencode/bin to ~/.bashrc; add it to this session's PATH as well
if [ -d "$HOME/.opencode/bin" ] && [[ ":$PATH:" != *":$HOME/.opencode/bin:"* ]]; then
    export PATH="$HOME/.opencode/bin:$PATH"
fi

opencode --version || echo "WARNING: opencode not found in PATH after installation"
