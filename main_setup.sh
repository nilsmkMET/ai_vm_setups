#!/bin/bash -i

# fighting bash to make things work in non interactive sessions...
HISTFILE=~/.bash_history
set -o history

###############################################################################
###############################################################################
# the ic scripts to print and debug

# Copyright (c) 2021 Jesús Lázaro
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT


# print file, function name, line, variable and its value
ic () {
    local tmp="${1}[@]"
    echo "(${BASH_SOURCE[1]},${FUNCNAME[1]}) ${BASH_LINENO[0]}: $1 - ${!tmp}"
}

# print file, function name, line, and message string
icp () {
    echo "(${BASH_SOURCE[1]},${FUNCNAME[1]}) ${BASH_LINENO[0]}: $1"
}

# print full call tree and variable and its value
ict () {
    local tmp="${1}[@]"
    for((i=${#BASH_SOURCE[@]}-2;i>=0;i--));
    do
        echo -n "(${BASH_SOURCE[$i+1]},${FUNCNAME[$i+1]}) ${BASH_LINENO[$i]}: "
    done
    echo "$1 - ${!tmp}"
}

# print full call tree and message string
ictp () {
    for((i=${#BASH_SOURCE[@]}-2;i>=0;i--));
    do
        echo -n "(${BASH_SOURCE[$i+1]},${FUNCNAME[$i+1]}) ${BASH_LINENO[$i]}: "
    done
    echo "$1"
}
###############################################################################
###############################################################################

###############################################################################
###############################################################################
# ----------------------------------------
# preamble

# exit if a command fails; to circumvent, can add specifically on commands that can fail safely: " || true "
set -o errexit
# make sure to show the error code of the first failing command
set -o pipefail
# do not overwrite files too easily
# to override the noclobber: >| instead of > only
set -o noclobber
# exit if try to use undefined variable
set -o nounset

# on globbing that has no match, return nothing, rather than return the dubious default ie the pattern itself
# see " help shopt "; use the -u flag to unset (while -s is set)
shopt -s nullglob
###############################################################################
###############################################################################

# ----------------------------------------
# determine repository root directory
if [ -d "$HOME/Desktop/Git/ai_vm_setups" ]; then
    REPO_DIR="$HOME/Desktop/Git/ai_vm_setups"
elif [ -d "$HOME/Desktop/Git/setups" ]; then
    REPO_DIR="$HOME/Desktop/Git/setups"
else
    REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi

# guard against re-running the setup on a machine where it has already been run
SETUP_MARKER_FILE="$HOME/.setup_ai_vm_setups_is_run"

if [ -f "$SETUP_MARKER_FILE" ] || [ -f "$HOME/.setup_jerabaul29_is_run" ]; then
    echo "ERROR: setup marker already exists; this setup has already been run on this machine. Aborting." >&2
    exit 1
fi

# ----------------------------------------
gsettings set org.gnome.desktop.interface color-scheme prefer-dark
# setxkbmap no

sudo apt update

echo "--- start setup_standard_libraries ---"
date
source "$HOME/.bashrc"
cd ./setup_standard_libraries
bash setup_standard_libraries.sh
cd "$REPO_DIR"
echo "--- done setup_standard_libraries ---"
echo ""
echo ""

echo "--- start setup_command_line ---"
date
source "$HOME/.bashrc"
cd ./setup_command_line
bash setup_command_line.sh
cd "$REPO_DIR"
echo "--- done setup_command_line ---"
echo ""
echo ""

echo "--- start setup_tmux ---"
date
source "$HOME/.bashrc"
cd ./setup_tmux
bash setup_tmux.sh
cd "$REPO_DIR"
echo "--- done setup_tmux ---"
echo ""
echo ""

echo "--- start setup_rust ---"
date
source "$HOME/.bashrc"
cd ./setup_rust
bash setup_rust.sh
cd "$REPO_DIR"
echo "--- done setup_rust ---"
echo ""
echo ""

echo "--- start setup_helix ---"
date
source "$HOME/.bashrc"
cd ./setup_helix
bash setup_helix.sh
cd "$REPO_DIR"
echo "--- done setup_helix ---"
echo ""
echo ""

echo "--- start setup_nvm_npm ---"
date
source "$HOME/.bashrc"
cd ./setup_nvm_npm
bash setup_nvm_npm.sh
cd "$REPO_DIR"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
npm install -g @github/copilot
mkdir -p "$HOME/.copilot"
history -s "copilot --yolo"
npm install -g @anthropic-ai/claude-code
history -s "claude --dangerously-skip-permissions"
npm install -g @openai/codex
history -s "codex --full-auto"
echo "--- done setup_nvm_npm ---"
echo ""
echo ""

echo "--- start setup_antigravity ---"
date
source "$HOME/.bashrc"
cd ./setup_antigravity
bash setup_antigravity.sh
cd "$REPO_DIR"
history -s "agy"
echo "--- done setup_antigravity ---"
echo ""
echo ""

echo "--- start setup_opencode ---"
date
source "$HOME/.bashrc"
cd ./setup_opencode
bash setup_opencode.sh
cd "$REPO_DIR"
history -s "opencode"
echo "--- done setup_opencode ---"
echo ""
echo ""

echo "--- start setup_bash ---"
date
source "$HOME/.bashrc"
cd ./setup_bash
bash setup_bash.sh
cd "$REPO_DIR"
history -s "eval \"$(ssh-agent -s)\""
echo "--- done setup_bash ---"
echo ""
echo ""

echo "--- start setup_python ---"
date
source "$HOME/.bashrc"
cd ./setup_python
bash python_dev_setup.sh
cd "$REPO_DIR"
echo "--- done setup_python ---"
echo ""
echo ""

echo "--- start setup_latex ---"
date
source "$HOME/.bashrc"
cd ./setup_latex
bash setup_latex.sh
cd "$REPO_DIR"
echo "--- done setup_latex ---"
echo ""
echo ""

echo "--- start setup_encrypted_blob  ---"
date
mkdir -p ~/bin
cp ./setup_encrypted_blob/setup_encrypted_blob.sh ~/bin/setup_encrypted_blob.sh
chmod +x ~/bin/setup_encrypted_blob.sh
history -s "setup_encrypted_blob.sh"
echo "--- done setup_encrypted_blob ---"
echo ""
echo ""

date
echo ""

# mark this setup as having been run on this machine, to guard against accidental re-runs
touch "$SETUP_MARKER_FILE"

history -w
sleep 10
