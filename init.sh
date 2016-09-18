tempDir=".tmp"


sudo apt-get install xclip git bleachbit guake snap vim evolution
# add xclip shortchuts
clip: xclip -selection clipboard

# atom

# install atom
wget --directory-prefix=$tempDir https://github.com/atom/atom/releases/download/v1.9.5/atom-amd64.deb || sudo dpkg -i atom-amd64

## install atom plugins
apm install file-icons advanced-open-file atom-beautify atom-panda-syntax atom-ternjs emmet editorconfig language-babel linter linter-xo linter-eslint linter-stylelint linter-pylama merge-conflicts minimap pigments react sort-lines terminal-plus

# symlink atom config
ls -s -f atom/config.cson ~/.atom/config.cson


# git

## config
git config --global user.email "maxime.lcdf@gmail.com"
git config --global user.name "Maxime Le Conte des Floris"

## gpg signing
git config --global user.signingkey EF94DD95

##
ln -s -f git/gitignore ~/.gitignore
ln -s -f it/gitconfig ~/.gitconfig


# node

## install nvm
wget -qO- --directory-prefix=$tempDir https://raw.githubusercontent.com/creationix/nvm/v0.31.7/install.sh | bash

## install node v4 & v6
nvm install 4 && nvm install 6

## install global npm packages
npm install --global alex http-server np public-ip opaline-cli torrent spoof yo

## signing tag
npm config set sign-git-tag true


# ruby

## install rvm, ruby & rails
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
get https://get.rvm.io | bash -s stable --rails


# zsh

## install zsh
sudo apt-get install zsh
chsh -s $(which zsh)

## install z
wget --directory-prefix=zsh https://raw.githubusercontent.com/rupa/z/master/z.sh
mkdir ~/.oh-my-zsh/plugins/z
ln -s -f z.zsh ~/.oh-my-zsh/plugins/z/z.zsh
ln -s -f zsh/.zshrc ~/.zshrc
ln -s -f zsh/aliases.zsh ~/aliases.zsh


## install pure zsh theme
wget --directory-prefix=zsh https://raw.githubusercontent.com/sindresorhus/pure/master/pure.zsh
wget --directory-prefix=zsh https://raw.githubusercontent.com/sindresorhus/pure/master/async.zsh
mkdir ~/.oh-my-zsh/plugins/pure
ln -s -f pure.zsh ~/.oh-my-zsh/plugins/pure/pure.zsh
ln -s -f pure.zsh ~/.oh-my-zsh/plugins/pure/async.zsh
ln -s -f .zshrc ~/.zshrc
