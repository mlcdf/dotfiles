#!/usr/bin/env bash

### Node.js ###

# Download & install nvm
wget -qO- --directory-prefix=".tmp" https://raw.githubusercontent.com/creationix/nvm/v0.31.7/install.sh | bash

# Install Node.js LTS
nvm install 6.9

# Use Node.js 6.9 by default
nvm alias default 6.9

npm config set sign-git-tag true

### Aptitude packages ###

# Add arc-theme repo for Elementary OS and Ubuntu <= 16.04
sudo sh -c "echo 'deb http://download.opensuse.org/repositories/home:/Horst3180/xUbuntu_16.04/ /' > /etc/apt/sources.list.d/arc-theme.list"
wget http://download.opensuse.org/repositories/home:Horst3180/xUbuntu_16.04/Release.key
sudo apt-key add - < Release.key

# Add yarn repo
sudo apt-key adv --fetch-keys http://dl.yarnpkg.com/debian/pubkey.gpg
echo "deb http://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

sudo add-apt-repository ppa:numix/ppa
sudo add-apt-repository ppa:ubuntu-desktop/ubuntu-make

sudo apt-get update

sudo apt-get install evolution
sudo apt-get install python3
sudo apt-get install vim
sudo apt-get install vlc
sudo apt-get install xclip
sudo apt-get install zsh
sudo apt-get install arc-theme
sudo apt-get install numix-icon-theme-circle
sudo apt-get install ubuntu-make
sudo apt-get install yarn

### npm, cook & apm package ###

# Install global npm packages
yarn global add http-server
yarn global add np
yarn global add opaline-cli
yarn global add yo

# Install cook-pm (see https://github.com/mlcdf/cook)
yarn global add cook-pm

cook sublime-text
cook vivaldi
cook hyper
cook atom

## Install Atom plugins
apm install atom-beautify
apm install atom-ternjs
apm install editorconfig
apm install file-icons
apm install language-babel
apm install linter
apm install linter-eslint
apm install minimap


# Install rvm, Ruby & Rails
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | bash -s stable --ruby=2.3.1 --rails -- --ignore-dotfiles


### Shell stuff (zsh, z, oh-my-zsh, ...) ###

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
