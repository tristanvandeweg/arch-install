#!/bin/bash

# install intel drivers base packages and xorg
sudo pacman -S xf86-video-intel xorg xorg-xinit konsole firefox git base-devel vim xf86-input-wacom --noconfirm
# install yay
git clone https://aur.archlinux.org/yay-git.git
cd ./yay-git/
makepkg -si
cd ./..
# install utilities
sudo pacman -S tmux zsh cmatrix nano vim nvim lsd neoftch --noconfirm
# install oh-my-zsh
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
# install kde and applications
sudo pacman -S plasma sddm sddm-kcm blender gimp libreoffice inkscape mc elinks grub-customizer discord keepassxc thunderbird kicad kicad-library kicad-library-3d --noconfirm
sudo systemctl enable sddm
sudo pacman -S kde-applications-meta --noconfirm

# copy configs
cp ./zshrc ~/.zshrc
