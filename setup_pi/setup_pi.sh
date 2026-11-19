#!/bin/bash -i
set -euo pipefail

echo "install pi coding agent"
curl -fsSL https://pi.dev/install.sh | bash

# Ensure ~/.local/bin is in PATH in ~/.bashrc if not already there
if ! grep -q '\.local/bin' "$HOME/.bashrc" 2>/dev/null; then
cat << 'EOF' >> "$HOME/.bashrc"

# set up ~/.local/bin in PATH (used by pi, agy, and others)
if [ -d "$HOME/.local/bin" ] && [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

EOF
fi

if [ -d "$HOME/.local/bin" ] && [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/.pi/agent/bin" ] && [[ ":$PATH:" != *":$HOME/.pi/agent/bin:"* ]]; then
    export PATH="$HOME/.pi/agent/bin:$PATH"
fi

pi --version || echo "WARNING: pi not found in PATH after installation"

# Setup ~/.pi/agent directory and configurations
PI_AGENT_DIR="$HOME/.pi/agent"
mkdir -p "$PI_AGENT_DIR"

# Clone global guidelines before linking them. Keep existing checkouts intact.
AGENT_GUIDELINES_DIR="$HOME/git/agent_guidelines"
if [ ! -d "$AGENT_GUIDELINES_DIR" ]; then
    mkdir -p "$HOME/git"
    git clone https://github.com/nilsmkMET/agent_guidelines.git "$AGENT_GUIDELINES_DIR"
fi

# Link global AGENTS.md instructions if present in the checkout.
AGENTS_GUIDELINES_SRC="$AGENT_GUIDELINES_DIR/AGENTS.md"
if [ -f "$AGENTS_GUIDELINES_SRC" ]; then
    echo "Linking $AGENTS_GUIDELINES_SRC to $PI_AGENT_DIR/AGENTS.md"
    ln -sfn "$AGENTS_GUIDELINES_SRC" "$PI_AGENT_DIR/AGENTS.md"
fi

# Clone shared skills before configuring Pi to use them. Keep existing checkouts intact.
SKILLCOLLECTION_DIR="$HOME/git/skillcollection"
if [ ! -d "$SKILLCOLLECTION_DIR" ]; then
    mkdir -p "$HOME/git"
    git clone https://github.com/nilsmkMET/skillcollection.git "$SKILLCOLLECTION_DIR"
fi

# Configure skillcollection in ~/.pi/agent/settings.json
python3 - << 'PYEOF'
import json
import os

settings_path = os.path.expanduser("~/.pi/agent/settings.json")
skill_dir = os.path.expanduser("~/git/skillcollection")

data = {}
if os.path.exists(settings_path):
    try:
        with open(settings_path, "r", encoding="utf-8") as f:
            data = json.load(f)
    except Exception:
        data = {}

if "$schema" not in data:
    data["$schema"] = "https://pi.dev/schemas/settings.schema.json"

skills = data.get("skills", [])
if not isinstance(skills, list):
    skills = []

if skill_dir not in skills:
    skills.append(skill_dir)

data["skills"] = skills

with open(settings_path, "w", encoding="utf-8") as f:
    json.dump(data, f, indent=2)
    f.write("\n")
print(f"Configured skills in {settings_path}")
PYEOF
