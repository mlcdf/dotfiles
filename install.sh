#!/bin/bash

# Commands run here should be idempotent.

set -e

echo "Install packages"
sudo apt update -y
sudo apt install -y \
	curl \
	git \
	make \
	tree \
	htop \
	vim \
	vlc \
	stow

echo "Remove unused packages"
sudo apt autoremove -y

echo "Create .ssh directory"
mkdir -p /home/maxime/.ssh

echo "Create symlinks"
stow --target=$HOME sh -R
stow --target=$HOME bin -R
stow --target=$HOME git -R
stow --target=$HOME fonts -R
stow --target=$HOME vim -R

echo "Source .maxime from existing ~/.bashrc"
grep -q -F "source .maxime" ~/.bashrc || echo -e "\nsource .maxime" >> ~/.bashrc