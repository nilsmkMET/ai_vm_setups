#!/bin/bash -i
set -euo pipefail

echo "install opencode"
curl -fsSL https://opencode.ai/install | bash

# the installer adds ~/.opencode/bin to ~/.bashrc; add it to this session's PATH as well
if [ -d "$HOME/.opencode/bin" ] && [[ ":$PATH:" != *":$HOME/.opencode/bin:"* ]]; then
    export PATH="$HOME/.opencode/bin:$PATH"
fi

opencode --version || echo "WARNING: opencode not found in PATH after installation"

# Ensure global guidelines and skills repositories are cloned (keep existing checkouts intact)
AGENT_GUIDELINES_DIR="$HOME/git/agent_guidelines"
if [ ! -d "$AGENT_GUIDELINES_DIR" ]; then
    mkdir -p "$HOME/git"
    git clone https://github.com/nilsmkMET/agent_guidelines.git "$AGENT_GUIDELINES_DIR"
fi

SKILLCOLLECTION_DIR="$HOME/git/skillcollection"
if [ ! -d "$SKILLCOLLECTION_DIR" ]; then
    mkdir -p "$HOME/git"
    git clone https://github.com/nilsmkMET/skillcollection.git "$SKILLCOLLECTION_DIR"
fi

# Configure OpenCode global AGENTS.md and skills
OPENCODE_CONFIG_DIR="$HOME/.config/opencode"
mkdir -p "$OPENCODE_CONFIG_DIR"

if [ -f "$AGENT_GUIDELINES_DIR/AGENTS.md" ]; then
    echo "Linking $AGENT_GUIDELINES_DIR/AGENTS.md to $OPENCODE_CONFIG_DIR/AGENTS.md"
    ln -sfn "$AGENT_GUIDELINES_DIR/AGENTS.md" "$OPENCODE_CONFIG_DIR/AGENTS.md"
fi

OPENCODE_SKILLS_DIR="$OPENCODE_CONFIG_DIR/skills"
if [ -L "$OPENCODE_SKILLS_DIR" ] || [ ! -e "$OPENCODE_SKILLS_DIR" ]; then
    ln -sfn "$SKILLCOLLECTION_DIR" "$OPENCODE_SKILLS_DIR"
elif [ -d "$OPENCODE_SKILLS_DIR" ]; then
    for skill_path in "$SKILLCOLLECTION_DIR"/*; do
        [ -d "$skill_path" ] || continue
        skill_name="$(basename "$skill_path")"
        [ "$skill_name" = ".git" ] && continue
        ln -sfn "$skill_path" "$OPENCODE_SKILLS_DIR/$skill_name"
    done
fi
