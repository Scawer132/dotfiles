#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "初始化 submodule..."
git -C "$DOTFILES_DIR" submodule update --init --recursive

echo "建立软链接..."
ln -sf "$DOTFILES_DIR/powershell" ~/.config/powershell
ln -sf "$DOTFILES_DIR/wezterm" ~/.config/wezterm

echo "完成。终端配置已就绪。"
