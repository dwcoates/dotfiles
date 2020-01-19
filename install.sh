#!/usr/bin/env bash

config_path="$HOME/.config"
declare -a dependencies=(xcape feh i3blocks dunst shutter slop glances)
declare -a configs=(i3 dunst conky compton)
remove_dirs=()

for c in "${configs[@]}"; do
    if [ "$config_path/$c" ]; then
        echo "'$config_path/$c' already exists."
        remove_dirs+=($c)
    fi
done

if (( ${#remove_dirs[@]} > 0 )); then
    read -p "Pre-existent directories will be removed. Are you sure (Y/n)? " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        for rd in "${remove_dirs[@]}"; do
            rm -Rf "$config_path/$rd"
        done
    else
        echo "Cannot install configs. Exiting." && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
    fi
fi

echo "Adding configuration files to $config_path"
for c in "${configs[@]}"; do
    echo "Adding '$config_path/$c'..."
    ln -s $(readlink -f $(dirname "$0"))/$c $config_path/$c
done

read -p "Install dependencies (Y/n)?" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    for d in "${dependencies[@]}"; do
        if [[ ! $(command -v "$d") ]]; then
            sudo apt install -y "$d"
        else echo "'$d' already found... Skipping.";
        fi
    done
fi
