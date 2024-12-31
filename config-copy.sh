#!/bin/bash

cd ~/arch-install/config/

copy='cp --update=older'

$copy -R ~/.config/awesome .
$copy -R ~/.emacs.d .
$copy ~/.Xresources .
$copy ~/.zshrc .
$copy ~/.emacs .
$copy -R ~/.config/hypr .
$copy -R ~/.config/waybar .
$copy -R ~/.config/kitty .
