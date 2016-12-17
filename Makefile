#!/usr/bin/env make

default:	\
	nodejs yarnpkg \
	python \
	shell

lint:
	shellcheck -s bash \
		zsh/*.zsh \
		bootstrap.sh \
		Makefile

upgrade:
	apt-get update && apt-get --yes upgrade

nodejs:
	wget -qO- --directory-prefix=".tmp" https://raw.githubusercontent.com/creationix/nvm/v0.31.7/install.sh | bash

	nvm install 6.9 # LTS
	nvm install 7.2 # Current
	nvm alias default 6.9

	npm config set sign-git-tag true

yarnpkg:
	apt-key adv --keyserver pgp.mit.edu --recv D101F7899D41F3C3
	echo "deb http://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
	apt-get update && apt-get install yarn --yes

python:
	apt-get install --yes \
		python3{,-dev} \
		python3-venv \
		python{,3}-pip \
		python{,3}-setuptools \
		pip install wheel \
		ipython \

ruby:
	# Install rvm, Ruby & Rails
	gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
	curl -sSL https://get.rvm.io | bash -s stable --ruby=2.3.1 --rails --ignore-dotfiles

rust:
	curl -sSf https://static.rust-lang.org/rustup.sh | sh
	cargo install racer


zsh:
	sudo apt-get install zsh --yes
	chsh -s "$(which zsh)"

z:
	if ! type z ; then \
		curl -sSLo ~/.oh-my-zsh/plugins/z/z.sh https://raw.githubusercontent.com/rupa/z/master/z.sh \
	; fi

oh-my-zsh:
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

zsh-syntax-highlighting:
	if [ ! -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]; then \
		git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
		"${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" \
	; fi

pure-theme:
	if [ ! -f ~/.oh-my-zsh/custom/themes/pure.zsh-theme ]; then \
		curl -sSLo ~/.oh-my-zsh/custom/themes/pure.zsh-theme \ https://raw.githubusercontent.com/sindresorhus/pure/master/pure.zsh \
	; fi
	if [ ! -f ~/.oh-my-zsh/custom/async.zsh ]; then \
		curl -sSLo ~/.oh-my-zsh/custom/async.zsh \
		https://raw.githubusercontent.com/sindresorhus/pure/master/async.zsh \
	; fi

shell: zsh z oh-my-zsh zsh-syntax-highlighting pure-theme

base-package:
	apt-get install --yes \
		xsel \
		evolution \
		vlc \
		vim \
		deluge \
		dropbox

	yarn global add cook-pm
	cook atom
	cook vivaldi
	cook hyper
	cook keeweb

clean:
	apt remove \
		transmission \
		thunderbird

atom:
	apm install \
		minimap \
		editorconfig \
		file-icons \
		language-babel \
		linter \
		linter-eslint \
		linter-stylelint \
		linter-pylint \
		atom-ternjs \
		autocomplete-python

bootstrap:
	./bootstrap.sh
