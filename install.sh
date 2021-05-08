#!/bin/bash
# 
# This script is indented to be run after every changes. Therefore below commands
# should be idempotent.
#

set -e

# blue echo
info() {
    echo -e "\e[0;34m$1\e[m" 
}

info "Install packages"
sudo apt update -y
sudo apt install -y \
	curl \
	git \
	make \
	tree \
	htop \
	vim \
	ansible \
	stow

info "Remove unused packages"
sudo apt autoremove -y

info "Create .ssh directory"
mkdir -p /home/maxime/.ssh

info "Create symlinks"
stow --target=$HOME sh -R
stow --target=$HOME bin -R
stow --target=$HOME git -R
stow --target=$HOME fonts -R
stow --target=$HOME vim -R

info "Source .maxime from existing ~/.bashrc"
grep -q -F "source .maxime" ~/.bashrc || echo -e "\nsource .maxime" >> ~/.bashrc

info "Run ansible playbook on localhost"
ansible-playbook -i homelab/hosts/local homelab/playbook.yml