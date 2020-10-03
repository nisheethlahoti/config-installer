# Function to prompt user for yes/no and return with corresponding value
confirm() { read -ren 1 -p "$1 [Y/n] " <&2 ; ! [[ $REPLY =~ ^[Nn]$ ]]; }

# Install system packages
sudo apt -y install git neovim ripgrep zsh ||
	{ echo "Unable to install packages. Aborting" && exit 1; }
git config --global --add include.path .additional.gitconfig

# Clone and checkout dotfiles
git clone --bare --config status.showUntrackedFiles=no\
	https://github.com/nisheethlahoti/dotfiles.git ~/.dotfiles.git &&
git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME checkout &&
git --git-dir=$HOME/.dotfiles.git/ config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*" &&
echo "All config files downloaded and checked out" ||
	{ confirm "Unable to checkout config files. Abort?" && exit 1; }

# Install neovim plugins
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim &&
nvim -c "PlugInstall | qa" - < /dev/null &&
echo "Neovim plugins installed" || echo "Unable to install neovim plugins"

# [Optional] set neovim as default editor
sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 30
if confirm "Set neovim to default editor?"; then
	sudo update-alternatives --set editor /usr/bin/nvim &&
	echo "Neovim is now the default editor."
fi

# [Optional] set zsh as default shell
if confirm "Set zsh to default shell?"; then
	if confirm "Do you know your password?"; then
		chsh -s /usr/bin/zsh && echo "Zsh is now the default shell."
	elif sudo cp /etc/pam.d/chsh /etc/pam.d/chsh.bak; then
		sed -Ee 's/required(\s+pam_shells\.so)/sufficient\1/' /etc/pam.d/chsh.bak |
			sudo tee /etc/pam.d/chsh > /dev/null &&
		chsh -s /usr/bin/zsh && echo "Zsh is now the default shell."
		sudo mv /etc/pam.d/chsh.bak /etc/pam.d/chsh
	fi
fi
