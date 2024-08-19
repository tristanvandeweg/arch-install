#!/bin/bash

# install packages
sudo pacman -S sudo wget git lsd awesome zsh tmux emacs lightdm-gtk-greeter xterm firefox net-tools --noconfirm

# install yay
cd ~
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
rm -r yay

# install oh-my-zsh
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

# copy configs
cp -r config ~
