#!/bin/bash

set -o nounset
set -o errexit

base() {
	add-apt-repository ppa:ubuntu-desktop/ubuntu-make

	apt update
	apt --yes upgrade

	apt install --yes \
		curl \
		git \
		gnupg2 \
		gzip \
		make \
		tree \
		ubuntu-make \
		unzip \
		vim \
		vlc \
		xsel \
		zip \
		htop \
		parcellite \
		software-properties-common \
		--no-install-recommends

	apt autoremove
	apt autoclean
	apt clean

	snap install --classic atom
}

install_graphics() {
	apt install --yes \
		xorg \
		xserver-xorg \
		xserver-xorg-video-intel \
		--no-install-recommends
}

nodejs() {
	npm install -g n
	n lts
	n stable # will be the default

	# Configuring npm this way because .npmrc contains a private token that
	# obviously should not be versioned
	npm config set sign-git-tag true
	npm set init.license=MIT
	npm set init.author.name=Maxime Le Conte des Floris

	npm install -g legit
}

yarnpkg() {
	apt-key adv --keyserver pgp.mit.edu --recv D101F7899D41F3C3
	echo "deb http://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
	apt update && apt install --yes yarn
}

python() {
	apt install --yes \
		python3{,-dev} \
		python3-venv \
		python{,3}-pip \
		python{,3}-setuptools \
		pip install wheel \
		ipython
}

ruby() {
	gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
	curl -sSL https://get.rvm.io | bash -s stable --ruby=2.3.1 --rails --ignore-dotfiles
}

atom() {
	apm install \
		minimap \
		editorconfig \
		file-icons \
		language-babel \
		linter \
		linter-xo \
		linter-eslint \
		atom-ternjs \
		git-plus \
		sort-lines \
		hyperclick
}

shell() {
	apt install --yes zsh
	chsh -s "$(which zsh)"

	git clone https://github.com/zsh-users/antigen.git ~/.antigen
}
