#!/bin/bash
script_dir="$(cd "$(dirname "$0")" && pwd)"
cd $script_dir

if ! command -v brew >/dev/null 2>&1; then
    echo "Install HomeBrew ..."

    if [ ! -f "$HOME/.zprofile" ]; then
        touch "$HOME/.zprofile"
    fi

    export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
    export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
    export HOMEBREW_INSTALL_FROM_API=1
    export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"
    export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"

    grep -q 'HOMEBREW_API_DOMAIN' ~/.zprofile || echo 'export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"' >> ~/.zprofile
    grep -q 'HOMEBREW_BOTTLE_DOMAIN' ~/.zprofile || echo 'export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"' >> ~/.zprofile

    chmod +x ./install.sh
    ./install.sh
    read -p "Press Enter to exit..."
else 
    ls
fi