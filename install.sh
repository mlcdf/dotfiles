#!/usr/bin/env bash

# Install Aptitude packages
sudo apt-get install bleachbit
sudo apt-get install evolution
sudo apt-get install firefox
sudo apt-get install git
sudo apt-get install python-virtualenv
sudo apt-get install python3
sudo apt-get install snap
sudo apt-get install vim
sudo apt-get install vlc
sudo apt-get install xclip
sudo apt-get install zsh


# Download and install Atom
wget --directory-prefix="~/Downloads" https://github.com/atom/atom/releases/download/v1.9.5/atom-amd64.deb || sudo dpkg -i atom-amd64

## Install Atom plugins
apm install advanced-open-file
apm install atom-beautify
apm install atom-panda-syntax
apm install atom-ternjs
apm install editorconfig
apm install file-icons
apm install language-babel
apm install linter
apm install linter-eslint
apm install linter-pylama
apm install linter-stylelint
apm install linter-xo
apm install merge-conflicts
apm install minimap
apm install pigments
apm install react
apm install sort-lines


# Download & install nvm
wget -qO- --directory-prefix=".tmp" https://raw.githubusercontent.com/creationix/nvm/v0.31.7/install.sh | bash

# Install node v4 & v6
nvm install 4 # it's the LTS version
nvm install 6

# Use Node 6.5 by default
nvm alias default 6.5

# Install global npm packages
sudo npm i -g alex
sudo npm i -g http-server
sudo npm i -g np
sudo npm i -g opaline-cli
sudo npm i -g public-ip
sudo npm i -g spoof
sudo npm i -g torrent
sudo npm i -g yo


# Install rvm, Ruby & Rails
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
get https://get.rvm.io | bash -s stable --ruby --rails


# Set Zsh as default shell
chsh -s $(which zsh)

# Install z.sh
if [ ! -f ~/.oh-my-zsh/plugins/z/z.zh ]; then
	wget -O ~/.oh-my-zsh/plugins/z/z.sh https://raw.githubusercontent.com/rupa/z/master/z.sh
fi

# Install zsh-syntax-highlighting
if [ ! -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]; then
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

# Install pure.zsh theme
if [ ! -f ~/.oh-my-zsh/custom/themes/pure.zsh-theme ]; then
	wget  -O ~/.oh-my-zsh/custom/themes/pure.zsh-theme https://raw.githubusercontent.com/sindresorhus/pure/master/pure.zsh
fi
if [ ! -f ~/.oh-my-zsh/custom/async.zsh ]; then
	wget  -O ~/.oh-my-zsh/custom/async.zsh https://raw.githubusercontent.com/sindresorhus/pure/master/async.zsh
fi
