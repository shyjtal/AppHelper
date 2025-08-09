#!/bin/bash

# 获取脚本当前所在的目录（保证路径正确）
script_dir="$(cd "$(dirname "$0")" && pwd)"

app_root_path="$HOME/Applications"
src_dir="$script_dir"

file_name=$(basename "$(find "$src_dir" -maxdepth 1 -name "*.app" -type d)")
file_name="${file_name%.app}"
file_src="$src_dir/$file_name"
file_dst="$app_root_path/$file_name"

# 检查是否找到了文件
if [ -z "$file_name" ]; then
    echo "No file found in $src_dir"
    read -n 1 -s -r -p "Press any key to exit"
    exit 1
fi

# 判断目标路径下是否已有该文件
if [ -d "$file_dst.app" ]; then
    echo "Application '$file_name' already exists at destination. Overwrite? (y/n)"
    read -r confirm
    if [[ "$confirm" == "y" ]]; then
        cp -R "$file_src.app" "$file_dst.app"
    fi
else
    cp -R "$file_src.app" "$file_dst.app"
fi

app_root_path="$HOME/Library"
file_dst="$app_root_path/$file_name"

if [ -d "$file_dst" ]; then
    echo "Library '$file_name' already exists at destination. Overwrite? (y/n)"
    read -r confirm
    if [[ "$confirm" == "y" ]]; then
        cp -R "$file_src" "$file_dst"
    fi
else
    cp -R "$file_src" "$file_dst"
fi
