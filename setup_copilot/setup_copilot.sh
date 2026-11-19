#!/bin/bash -i
set -euo pipefail

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

# Configure Copilot CLI personal instructions and skillDirectories
COPILOT_DIR="$HOME/.copilot"
mkdir -p "$COPILOT_DIR"

if [ -f "$AGENT_GUIDELINES_DIR/AGENTS.md" ]; then
    echo "Linking $AGENT_GUIDELINES_DIR/AGENTS.md to $COPILOT_DIR/copilot-instructions.md"
    ln -sfn "$AGENT_GUIDELINES_DIR/AGENTS.md" "$COPILOT_DIR/copilot-instructions.md"
fi

python3 - << 'PYEOF'
import json
import os

settings_path = os.path.expanduser("~/.copilot/settings.json")
skill_dir = os.path.expanduser("~/git/skillcollection")

data = {}
if os.path.exists(settings_path):
    try:
        with open(settings_path, "r", encoding="utf-8") as f:
            data = json.load(f)
    except Exception:
        data = {}

skill_dirs = data.get("skillDirectories", [])
if not isinstance(skill_dirs, list):
    skill_dirs = []

if skill_dir not in skill_dirs:
    skill_dirs.append(skill_dir)

data["skillDirectories"] = skill_dirs

with open(settings_path, "w", encoding="utf-8") as f:
    json.dump(data, f, indent=2)
    f.write("\n")
print(f"Configured skillDirectories in {settings_path}")
PYEOF
