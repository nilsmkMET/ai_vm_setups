#!/bin/bash -i

mkdir -p "$HOME/Desktop/Git"
cd "$HOME/Desktop/Git"
git clone https://github.com/nilsmkMET/ai_vm_setups.git
cd ai_vm_setups
bash main_setup.sh
