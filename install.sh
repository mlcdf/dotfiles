# hostname nepture || pluto

mkdir /home/maxime/.ssh

# Disable SELinux
sudo sed -i 's/=enforcing/=disabled/g' /etc/selinux/config /etc/selinux/config

# Add repository for Sublime Text
rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
sudo dnf config-manager -y --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo

# Add repository for VLC
sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
	 https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Install RPMs
sudo dnf update -y
sudo dnf install -y \
	curl \
	git \
	make \
	tree \
	htop \
	xsel \
	vim \
	tilix \
	gnome-tweaks \
	lollypop \
	black \
	golang \
	sublime-text \
	vlc \
	stow \
	nodejs \
	vagrant \
	dconf-editor \
	zsh \
	chsh -s $(which zsh) \
	util-linux-user # provides chsh used below to set zsh as default shell

sudo dnf remove -y rhythmbox
sudo dnf clean all

# Set zsh as default shell
chsh -s "$(which zsh)"

# Set Gnome configuration
dconf write /org/gnome/desktop/privacy/remember-recent-files false
dconf write /org/gnome/desktop/privacy/remove-old-temp-files true
dconf write /org/gnome/desktop/privacy/remove-old-trash-files true
dconf write /org/gnome/desktop/privacy/report-technical-problems false
dconf write /org/gnome/desktop/privacy/show-full-name-in-top-bar false

dconf write /org/gnome/desktop/datetime/automatic-timezone true

dconf write /org/gnome/desktop/file-sharing/require-password 'always'

dconf write /org/gnome/desktop/interface/show-battery-percentage true
dconf write /org/gnome/desktop/interface/gtk-theme 'Adwaita-dark'

dconf write /org/gnome/desktop/peripherals/touchpad tap-to-click

dconf write /org/gnome/desktop/wm.preferences/button-layout 'appmenu:minimize,maximize,close'

dconf write /org/gnome/desktop/system/locale/region 'fr_FR.UTF-8'

dconf write /org/gnome/software/enable-repos-dialog true

dconf write /org/gnome/software/first-run false

# dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings: "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"
# dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings:/custom0/binding "<Super>t"
# dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings:/custom0/command "tilix"
# dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings:/custom0/name "Terminal"


# Filesystem stuff
# sudo mkdir /data
# sudo mount /dev/sdc3 /data
# sudo mkdir /backup
# sudo mount /dev/sdd3 /backup
# vi fstab
