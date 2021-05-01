echo "Create .ssh directory"
mkdir -f /home/maxime/.ssh

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
	stow \
	ansible
