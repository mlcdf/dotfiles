#!/usr/bin/env bash

# Install Aptitude packages
# sudo apt-get install bleachbit
sudo apt-get install evolution
# sudo apt-get install firefox
# sudo apt-get install git
sudo apt-get install python-virtualenv
sudo apt-get install python3
sudo apt-get install vim
sudo apt-get install vlc
sudo apt-get install xclip
sudo apt-get install zsh


# Install Arc-Theme
sudo sh -c "echo 'deb http://download.opensuse.org/repositories/home:/Horst3180/xUbuntu_16.04/ /' > /etc/apt/sources.list.d/arc-theme.list"
sudo apt-get update
sudo apt-get install arc-theme


# Install Numix Circle
sudo add-apt-repository ppa:numix/ppa
sudo apt-get update
sudo apt-get install numix-icon-theme-circle


# Download and install Atom
curl -sSL --directory-prefix="~/Downloads" https://github.com/atom/atom/releases/download/v1.12.1/atom-amd64.deb || sudo dpkg -i atom-amd64

## Install Atom plugins
apm install atom-beautify
apm install atom-ternjs
apm install editorconfig
apm install file-icons
apm install language-babel
apm install linter
apm install linter-eslint
apm install minimap


# Download & install nvm
wget -qO- --directory-prefix=".tmp" https://raw.githubusercontent.com/creationix/nvm/v0.31.7/install.sh | bash

# Install node LTS
nvm install 6.9

# Use Node 6.9 by default
nvm alias default 6.9

# Install global npm packages
# npm i -g alex
npm i -g http-server
npm i -g np
npm i -g opaline-cli
# npm i -g public-ip
# npm i -g spoof
# npm i -g torrent
npm i -g yo


# Install rvm, Ruby & Rails
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | bash -s stable --ruby=2.3.1 --rails -- --ignore-dotfiles


# Set Zsh as default shell
chsh -s $(which zsh)

# Install z.sh
if [ ! -f ~/.oh-my-zsh/plugins/z/z.zh ]; then
	curl -sSLo ~/.oh-my-zsh/plugins/z/z.sh https://raw.githubusercontent.com/rupa/z/master/z.sh
fi

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Install zsh-syntax-highlighting
if [ ! -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]; then
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

# Install pure.zsh theme
if [ ! -f ~/.oh-my-zsh/custom/themes/pure.zsh-theme ]; then
	curl -sSLo ~/.oh-my-zsh/custom/themes/pure.zsh-theme https://raw.githubusercontent.com/sindresorhus/pure/master/pure.zsh
fi
if [ ! -f ~/.oh-my-zsh/custom/async.zsh ]; then
	curl -sSLo ~/.oh-my-zsh/custom/async.zsh https://raw.githubusercontent.com/sindresorhus/pure/master/async.zsh
fi
