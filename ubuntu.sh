# Function to prompt user for yes/no and return with corresponding value
confirm() { read -ren 1 -p "$1 [Y/n] " <&2 ; ! [[ $REPLY =~ ^[Nn]$ ]]; }

# Install system packages
sudo apt -y install gcc git ripgrep zsh ||
	{ echo "Unable to install packages. Aborting" && exit 1; }
sudo snap install --classic nvim

# [Optional] set neovim as default editor
sudo update-alternatives --install /usr/bin/editor editor /snap/nvim/current/usr/bin/nvim 30
if confirm "Set neovim to default editor?"; then
	sudo update-alternatives --set editor /snap/nvim/current/usr/bin/nvim &&
	echo "Neovim is now the default editor."
fi

# [Optional] set zsh as default shell
if confirm "Set zsh to default shell?"; then
	sudo usermod -s /usr/bin/zsh $USER && echo "Zsh is now the default shell."
fi
