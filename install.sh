#!/bin/bash

set -o nounset
set -o errexit

base() {
	add-apt-repository ppa:ubuntu-desktop/ubuntu-make

	apt-get update
	apt-get --yes upgrade

	apt-get install --yes \
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
		--no-install-recommends

		apt-get autoremove
		apt-get autoclean
		apt-get clean

		yarn global add cook-pm
		cook atom
		cook hyper
		cook keeweb
}

install_graphics() {
	apt-get install --yes \
		xorg \
		xserver-xorg \
		xserver-xorg-video-intel \
		--no-install-recommends
}

nodejs() {
	npm install -g n
	n lts
	n stable # will be the default

	npm config set sign-git-tag true
}

yarnpkg() {
	apt-key adv --keyserver pgp.mit.edu --recv D101F7899D41F3C3
	echo "deb http://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
	apt-get update && apt-get install --yes yarn
}

python() {
	apt-get install --yes \
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
	sudo apt-get install --yes zsh
	chsh -s "$(which zsh)"

	# z
	if ! type z ; then \
		curl -sSLo ~/.oh-my-zsh/plugins/z/z.sh https://raw.githubusercontent.com/rupa/z/master/z.sh \
	; fi

	# TODO: Use `antigen` instead of `oh-my-zsh`

	# oh-my-zsh
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

	# zsh-syntax-highlighting
	if [ ! -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]; then \
		git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
		"${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" \
	; fi

	# pure-theme
	if [ ! -f ~/.oh-my-zsh/custom/themes/pure.zsh-theme ]; then \
		curl -sSLo ~/.oh-my-zsh/custom/themes/pure.zsh-theme \ https://raw.githubusercontent.com/sindresorhus/pure/master/pure.zsh \
	; fi
	if [ ! -f ~/.oh-my-zsh/custom/async.zsh ]; then \
		curl -sSLo ~/.oh-my-zsh/custom/async.zsh \
		https://raw.githubusercontent.com/sindresorhus/pure/master/async.zsh \
	; fi
}
