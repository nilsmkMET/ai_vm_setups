#!/usr/bin/env bash
# Exercise shared agent guidelines and skillcollection setup across pi, opencode, copilot, and agy.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEST_DIR="$(mktemp -d)"
trap 'rm -rf "$TEST_DIR"' EXIT
export HOME="$TEST_DIR/home"
export GIT_CALLS="$TEST_DIR/git_calls"
mkdir -p "$HOME" "$TEST_DIR/bin"
touch "$HOME/.bashrc" "$GIT_CALLS"
export PATH="$TEST_DIR/bin:$PATH"

printf '#!/usr/bin/env bash\nset -euo pipefail\nexit 0\n' > "$TEST_DIR/bin/curl"
cp "$TEST_DIR/bin/curl" "$TEST_DIR/bin/pi"
cp "$TEST_DIR/bin/curl" "$TEST_DIR/bin/opencode"
cp "$TEST_DIR/bin/curl" "$TEST_DIR/bin/agy"
cat > "$TEST_DIR/bin/git" << 'EOF'
#!/usr/bin/env bash
set -euo pipefail
printf '%s\n' "$*" >> "$GIT_CALLS"
[ "$#" -eq 3 ]
[ "$1" = clone ]
case "$2" in
    https://github.com/nilsmkMET/agent_guidelines.git)
        [ "$3" = "$HOME/git/agent_guidelines" ]
        mkdir -p "$3"
        printf '# Global guidelines\n' > "$3/AGENTS.md"
        ;;
    https://github.com/nilsmkMET/skillcollection.git)
        [ "$3" = "$HOME/git/skillcollection" ]
        mkdir -p "$3/sample-skill"
        printf '# Sample skill\n' > "$3/sample-skill/SKILL.md"
        ;;
    *) exit 1 ;;
esac
EOF
chmod +x "$TEST_DIR/bin/"*

# Run all four setup scripts in sequence (simulating main_setup.sh order)
bash "$REPO_DIR/setup_copilot/setup_copilot.sh"
bash "$REPO_DIR/setup_antigravity/setup_antigravity.sh"
bash "$REPO_DIR/setup_opencode/setup_opencode.sh"
bash "$REPO_DIR/setup_pi/setup_pi.sh"

# Clones should only happen once across all four scripts
[ "$(wc -l < "$GIT_CALLS")" -eq 2 ]

# Verify AGENTS.md / copilot-instructions.md links
[ "$(readlink "$HOME/.copilot/copilot-instructions.md")" = "$HOME/git/agent_guidelines/AGENTS.md" ]
[ "$(readlink "$HOME/.gemini/AGENTS.md")" = "$HOME/git/agent_guidelines/AGENTS.md" ]
[ "$(readlink "$HOME/.config/opencode/AGENTS.md")" = "$HOME/git/agent_guidelines/AGENTS.md" ]
[ "$(readlink "$HOME/.pi/agent/AGENTS.md")" = "$HOME/git/agent_guidelines/AGENTS.md" ]

# Verify skills configuration for all four agents
grep -Fq "$HOME/git/skillcollection" "$HOME/.copilot/settings.json"
[ "$(readlink "$HOME/.gemini/skills")" = "$HOME/git/skillcollection" ]
[ -f "$HOME/.gemini/skills/sample-skill/SKILL.md" ]
[ "$(readlink "$HOME/.config/opencode/skills")" = "$HOME/git/skillcollection" ]
[ -f "$HOME/.config/opencode/skills/sample-skill/SKILL.md" ]
grep -Fq "$HOME/git/skillcollection" "$HOME/.pi/agent/settings.json"

echo 'PASS: shared guidelines and skills configured for copilot, agy, opencode, and pi'
