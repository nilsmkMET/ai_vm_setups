#!/bin/bash -i

# check if tmux is installed; if not, install
if command -v tmux &> /dev/null; then
  echo "tmux is installed."
else
  echo "tmux is not installed."
  echo "install it now"
  sudo apt install -y tmux
fi

cd "$HOME"
git clone --single-branch https://github.com/gpakosz/.tmux.git
ln -s -f .tmux/.tmux.conf
if [ -f "$HOME/Desktop/Git/ai_vm_setups/setup_tmux/tmux.conf.local" ]; then
  cp "$HOME/Desktop/Git/ai_vm_setups/setup_tmux/tmux.conf.local" .tmux.conf.local
elif [ -f "$HOME/Desktop/Git/setups/setup_tmux/tmux.conf.local" ]; then
  cp "$HOME/Desktop/Git/setups/setup_tmux/tmux.conf.local" .tmux.conf.local
else
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  cp "$SCRIPT_DIR/tmux.conf.local" .tmux.conf.local
fi

