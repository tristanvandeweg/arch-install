#!/bin/bash

# install intel drivers base packages and xorg
sudo pacman -S xf86-video-intel xorg xorg-xinit konsole firefox git base-devel vim xf86-input-wacom --noconfirm
# install yay
git clone https://aur.archlinux.org/yay-git.git
cd ./yay-git/
makepkg -si
cd ./..
# install utilities
sudo pacman -S tmux zsh cmatrix nano --noconfirm
# install oh-my-zsh
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
# install kde
sudo pacman -S plasma sddm sddm-kcm blender gimp libreoffice inkscape grub-customizer --noconfirm
sudo systemctl enable sddm
sudo pacman -S kde-applications-meta --noconfirm
