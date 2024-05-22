#!/bin/bash

cd ~/arch-install
git add ./*
git pull
git commit -m "updated by script"
git push
