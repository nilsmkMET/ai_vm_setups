#!/bin/bash -i

# Only install standard, useful command line tools
sudo apt update
sudo apt install -y tree

# Setup my scripts directory for sync and git helpers
mkdir -p "$HOME/my_scripts"
cd "$HOME/my_scripts"

# grf and grt (IP sync helpers)
wget -q https://raw.githubusercontent.com/jerabaul29/config_scripts_snippets/refs/heads/main/scripts/sync_with_IP/sync_with_IP.sh
chmod +x sync_with_IP.sh

# ga (git add commit push helper)
wget -q https://raw.githubusercontent.com/jerabaul29/config_scripts_snippets/refs/heads/main/scripts/ga/git_add_commit_push.sh
chmod +x git_add_commit_push.sh

# Clean, standard terminal configuration
cat << 'EOF' >> "$HOME/.bashrc"

# Enable truecolor support for modern editors
export COLORTERM="truecolor"

# Keep the standard, clean Ubuntu bash prompt
PS1='\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# Sync and git helper commands
source "$HOME/my_scripts/sync_with_IP.sh"
alias ga="$HOME/my_scripts/git_add_commit_push.sh"

EOF

