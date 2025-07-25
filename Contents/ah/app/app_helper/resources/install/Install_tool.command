#!/bin/bash

# 获取脚本当前所在的目录（保证路径正确）
script_dir="$(cd "$(dirname "$0")" && pwd)"

app_root_path="$HOME/sh/tools"
src_dir="$script_dir"

file_name=$(find "$src_dir" -maxdepth 1 -type f ! -name ".*" ! -name "Install.command" -exec basename {} \; | head -n 1)
file_src="$src_dir/$file_name"
file_dst="$app_root_path/$file_name"

# 创建目标路径（如果不存在）
mkdir -p "$app_root_path"

# 检查是否找到了文件
if [ -z "$file_name" ]; then
    echo "No file found in $src_dir"
    read -n 1 -s -r -p "Press any key to exit"
    exit 1
fi

# 判断目标路径下是否已有该文件
if [ -f "$file_dst" ]; then
    echo "File '$file_name' already exists at destination. Overwrite? (y/n)"
    read -r confirm
    if [[ "$confirm" == "y" ]]; then
        cp "$file_src" "$file_dst"
    fi
else
    cp "$file_src" "$file_dst"
fi
