#!/bin/bash

# 获取脚本当前所在的目录（保证路径正确）
script_dir="$(cd "$(dirname "$0")" && pwd)"

app_root_path="$HOME/sh"
src_dir="$script_dir"

file_name=$(find "$src_dir" -maxdepth 1 -type f ! -name ".*" ! -name "Install.command" -exec basename {} \; | head -n 1)
file_src="$src_dir/$file_name"
file_dst="$app_root_path/$file_name"

if [ -d "$src_dir/app" ]; then
    app_type_name=app
elif [ -d "$src_dir/dev" ]; then
    app_type_name=dev
fi

# 创建目标路径（如果不存在）
mkdir -p "$app_root_path/$app_type_name"

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
        cp -r "$src_dir"/*/ "$app_root_path/$app_type_name"
    fi
else
    cp "$file_src" "$file_dst"
    cp -r "$src_dir"/*/ "$app_root_path/$app_type_name"
fi

if [ ! -z $app_type_name ]; then
    cd "$src_dir/$app_type_name"
    cd */
    if [[ -f "./dependencies" ]]; then
        while IFS= read -r line || [[ -n $line ]]; do
            [[ -z "$line" || "$line" =~ ^[[:space:]]*$ ]] && continue
            if [[ $line == brew/* ]]; then
                sh_name="${line#brew/}"
                read -r brew_option brew_app <<< "$sh_name"
                if brew list --versions $sh_name >/dev/null 2>&1; then
                    continue
                fi
                echo "configure $sh_name ..."
                if [[ -z $brew_app ]]; then
                    brew_app=$brew_option
                    brew_option="--formula"
                fi
                sh_name=$brew_app  
                   
                if [[ "$brew_option" == "--cask" ]]; then       
                    if ! brew list --cask | grep -qw "$sh_name"; then
                        brew install --cask $sh_name
                    fi
                else
                    if ! brew list --formula | grep -qw "$sh_name"; then
                        brew install --formula $sh_name
                    fi
                fi
            fi

        done < "./dependencies"
    fi
fi
