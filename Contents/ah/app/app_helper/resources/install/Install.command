#!/bin/bash
if ! xcode-select -p &>/dev/null; then
    echo "Install Xcode Command Line Tools ..."
    xcode-select --install
fi

# 获取脚本当前所在的目录（保证路径正确）
script_dir="$(cd "$(dirname "$0")" && pwd)"
file_name=$(basename "$script_dir")

if [[ -f "$script_dir/Resources/homebrew.sh" ]]; then
    chmod +x "$script_dir/Resources/homebrew.sh"
    "$script_dir/Resources/homebrew.sh"
fi

cd $script_dir/Contents
for item in ./*; do
    if [[ -d "$item" ]]; then
        ./"$item"/Install.command
    fi
done

grep -q '$HOME/sh' ~/.zshrc || echo 'export PATH="$HOME/sh:$PATH"' >> ~/.zshrc
source ~/.zshrc

echo "are you want to delete $file_name and $file_name.zip ? (y/n)"
read -r confirm
if [[ "$confirm" == "y" ]]; then
    rm -r $script_dir
    rm $script_dir.zip
fi

read -n 1 -s -r -p "Press any key to exit"
