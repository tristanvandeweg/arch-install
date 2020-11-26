#!/bin/bash

# install intel drivers base packages and xorg
sudo pacman -S xf86-video-intel xorg xorg-xinit konsole firefox git base-devel vim --noconfirm
# install yay
git clone https://aur.archlinux.org/yay-git.git
cd ./yay-git/
makepkg -si
cd ./..
# install kde
sudo pacman -S plasma sddm blender gimp libreoffice --noconfirm
