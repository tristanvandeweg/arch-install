#!/bin/bash

cd ~/arch-install/config

copy='cp --update=older'

copy -R ./awesome ~/.config/
copy -R ./.emacs.d ~/
copy ./.Xresources ~/
copy ./.zshrc ~/
copy ./.emacs ~/
copy -R ./hypr ~/.config/
copy -R ./waybar ~/.config/
copy -R ./kitty ~/.config/
