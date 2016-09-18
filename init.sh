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

##
rm ~/.gitignore
ln -s -f $PWD"/git/gitignore" ~/.gitignore
rm ~/.gitconfig
ln -s -f $PWD"/git/gitconfig" ~/.gitconfig


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
if [ ! -f $PWD"/zsh/z.zsh" ]; then
	wget --directory-prefix=zsh https://raw.githubusercontent.com/rupa/z/master/z.sh
fi
rm -rf ~/.oh-my-zsh/plugins/z
mkdir ~/.oh-my-zsh/plugins/z
ln -s -f $PWD"/z.zsh" ~/.oh-my-zsh/plugins/z/z.zsh
ln -s -f $PWD"/zsh/.aliases.zsh" ~/.aliases.zsh

## install syntax highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

## install pure zsh theme
if [ ! -f $PWD"/zsh/pure.zsh" ]; then
	wget --directory-prefix=zsh https://raw.githubusercontent.com/sindresorhus/pure/master/pure.zsh
fi
if [ ! -f $PWD"/zsh/async.zsh" ]; then
	wget --directory-prefix=zsh https://raw.githubusercontent.com/sindresorhus/pure/master/async.zsh
fi
rm -rf ~/.oh-my-zsh/plugins/pure
mkdir ~/.oh-my-zsh/plugins/pure
ln -s -f $PWD"/zsh/pure.zsh" ~/.oh-my-zsh/plugins/pure/pure.zsh
ln -s -f $PWD"/zsh/async.zsh" ~/.oh-my-zsh/plugins/pure/async.zsh
ln -s -f $PWD"/zsh/.zshrc" ~/.zshrc
