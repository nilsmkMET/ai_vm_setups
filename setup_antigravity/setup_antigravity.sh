#!/bin/bash -i
set -euo pipefail

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

# Add agyolo alias for executing antigravity cli with permissions skipped
if ! grep -q 'alias agyolo=' "$HOME/.bashrc" 2>/dev/null; then
cat << 'EOF' >> "$HOME/.bashrc"

# alias for executing antigravity cli with permissions skipped
alias agyolo="agy --dangerously-skip-permissions"

EOF
fi

alias agyolo="agy --dangerously-skip-permissions"

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

# Configure Antigravity (agy) global AGENTS.md and skills
GEMINI_DIR="$HOME/.gemini"
mkdir -p "$GEMINI_DIR"

if [ -f "$AGENT_GUIDELINES_DIR/AGENTS.md" ]; then
    echo "Linking $AGENT_GUIDELINES_DIR/AGENTS.md to $GEMINI_DIR/AGENTS.md"
    ln -sfn "$AGENT_GUIDELINES_DIR/AGENTS.md" "$GEMINI_DIR/AGENTS.md"
fi

GEMINI_SKILLS_DIR="$GEMINI_DIR/skills"
if [ -L "$GEMINI_SKILLS_DIR" ] || [ ! -e "$GEMINI_SKILLS_DIR" ]; then
    ln -sfn "$SKILLCOLLECTION_DIR" "$GEMINI_SKILLS_DIR"
elif [ -d "$GEMINI_SKILLS_DIR" ]; then
    for skill_path in "$SKILLCOLLECTION_DIR"/*; do
        [ -d "$skill_path" ] || continue
        skill_name="$(basename "$skill_path")"
        [ "$skill_name" = ".git" ] && continue
        ln -sfn "$skill_path" "$GEMINI_SKILLS_DIR/$skill_name"
    done
fi
