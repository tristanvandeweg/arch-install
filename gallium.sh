#!/bin/bash

# Update packages and install flatpak
sudo sh -c 'apt -y update && apt -y upgrade && apt -y autoremove && apt -y install flatpak'

# Setup flatpak
flatpak remote-add flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Install programs
flatpak install -y flathub app/org.kicad.KiCad/x86_64/stable
flatpak install -y flathub cc.arduino.IDE2
flatpak install -y flathub org.fritzing.Fritzing
