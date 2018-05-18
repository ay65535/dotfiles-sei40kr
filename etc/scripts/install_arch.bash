#!/usr/bin/env bash

# install_arch.bash --- dotfiles installer for Arch Linux
# author: Seong Yong-ju <sei40kr@gmail.com>

set -euo pipefail
IFS=$'\n\t'

DOTFILES_PATH="$(realpath "$(dirname "$0")/../..")"

# compton
ln -sF "${DOTFILES_PATH}/compton/compton.conf" "${HOME}/.config/compton.conf"

# dmenu
ln -sF "${DOTFILES_PATH}/dmenu/dmenurc" "${HOME}/.dmenurc"

# dropbox
mkdir -p "${HOME}/Dropbox/notes"
systemctl --user enable dropbox

# dunst
ln -sF "${DOTFILES_PATH}/dunst/dunstrc" "${HOME}/.dmenurc"

# fcitx
mkdir -p "${HOME}/.config/fcitx"
ln -sF "${DOTFILES_PATH}/fcitx/config" "${HOME}/.config/fcitx/config"

# feh
mkdir -p "${HOME}/.local/share/backgrounds"
cp -sF "${DOTFILES_PATH}/share/backgrounds"/*.png "${HOME}/.local/share/backgrounds"
ln -sF "${DOTFILES_PATH}/feh/fehbg" "${HOME}/.fehbg"

# i3
mkdir -p "${HOME}/.config/i3"
ln -sF "${DOTFILES_PATH}/i3/config" "${HOME}/.config/i3/config"

# i3status
mkdir -p "${HOME}/.config/i3status"
ln -sF "${DOTFILES_PATH}/i3status/config" "${HOME}/.config/i3status/config"

# scrot
mkdir -p "${HOME}/screenshots"

# xorg
ln -sF "${DOTFILES_PATH}/xorg/Xresources" "${HOME}/.Xresources"
ln -sF "${DOTFILES_PATH}/xorg/xprofile" "${HOME}/.xprofile"
