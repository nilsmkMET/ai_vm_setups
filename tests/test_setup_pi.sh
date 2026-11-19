#!/usr/bin/env bash
# Exercise shared repository cloning without network access or real installers.
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
cat > "$TEST_DIR/bin/git" << 'EOF'
#!/usr/bin/env bash
set -euo pipefail
printf '%s\n' "$*" >> "$GIT_CALLS"
if [ "$2" = "${FAIL_CLONE:-}" ]; then
    exit 128
fi
[ "$#" -eq 3 ]
[ "$1" = clone ]
case "$2" in
    https://github.com/nilsmkMET/agent_guidelines.git)
        [ "$3" = "$HOME/git/agent_guidelines" ]
        mkdir -p "$3"
        printf '# Global guidelines\n' > "$3/AGENTS.md"
        ;;
    git@github.com:nilsmkMET/skillcollection.git)
        exit 1
        ;;
    https://github.com/nilsmkMET/skillcollection.git)
        [ "$3" = "$HOME/git/skillcollection" ]
        mkdir -p "$3"
        ;;
    *) exit 1 ;;
esac
EOF
chmod +x "$TEST_DIR/bin/"*

# First run clones both repositories, links guidelines, and registers skills.
bash "$REPO_DIR/setup_pi/setup_pi.sh"
[ -d "$HOME/git/skillcollection" ]
[ "$(wc -l < "$GIT_CALLS")" -eq 2 ]
[ "$(readlink "$HOME/.pi/agent/AGENTS.md")" = "$HOME/git/agent_guidelines/AGENTS.md" ]
cmp "$HOME/.pi/agent/AGENTS.md" "$HOME/git/agent_guidelines/AGENTS.md"
grep -Fq "$HOME/git/skillcollection" "$HOME/.pi/agent/settings.json"

# Re-running preserves local files and does not clone or update the checkout.
touch "$HOME/git/skillcollection/local_file"
printf '# Local guidelines\n' > "$HOME/git/agent_guidelines/AGENTS.md"
bash "$REPO_DIR/setup_pi/setup_pi.sh"
[ -f "$HOME/git/skillcollection/local_file" ]
grep -q '^# Local guidelines$' "$HOME/.pi/agent/AGENTS.md"
[ "$(wc -l < "$GIT_CALLS")" -eq 2 ]

# Clone failures must stop setup before registering skills.
for repo in agent_guidelines skillcollection; do
    export HOME="$TEST_DIR/failure_$repo"
    mkdir -p "$HOME"
    touch "$HOME/.bashrc"
    if [ "$repo" = agent_guidelines ]; then
        export FAIL_CLONE="https://github.com/nilsmkMET/agent_guidelines.git"
    else
        export FAIL_CLONE="https://github.com/nilsmkMET/skillcollection.git"
    fi
    if bash "$REPO_DIR/setup_pi/setup_pi.sh"; then
        echo "ERROR: setup unexpectedly succeeded after $repo clone failure" >&2
        exit 1
    fi
    [ ! -e "$HOME/.pi/agent/settings.json" ]
done
echo 'PASS: fresh clones, guidelines link, existing checkouts, and clone failures'
