# Function to prompt user for yes/no and return with corresponding value
confirm() { read -ren 1 -p "$1 [Y/n] " <&2 ; ! [[ $REPLY =~ ^[Nn]$ ]]; }

# OS-specific stuff
case $(uname -s) in
	Linux)
		# Install system packages
		NVIM_PATH=/usr/bin/nvim
		case $(cat /etc/os-release | grep "^ID=" | sed "s/ID=//") in
			ubuntu)
				sudo apt -y install gcc git ripgrep zsh &&
				sudo snap install --classic nvim &&
				NVIM_PATH=/snap/nvim/current/usr/bin/nvim &&
				curl -sSL https://pdm-project.org/install-pdm.py | python3 - ;;
			fedora)
				sudo dnf -y install gcc git ripgrep zsh neovim &&
				curl -sSL https://pdm-project.org/install-pdm.py | python3 - ;;
			arch) sudo pacman --noconfirm -S gcc git ripgrep zsh neovim python-pdm;;
			*) echo "Unrecognized linux flavor" && false
		esac || { echo "Unable to install packages. Aborting" && exit 1; }

		# [Optional] set neovim as default editor
		sudo update-alternatives --install /usr/bin/editor editor $NVIM_PATH 30
		if confirm "Set neovim to default editor?"; then
			sudo update-alternatives --set editor $NVIM_PATH &&
			echo "Neovim is now the default editor."
		fi

		# [Optional] set zsh as default shell
		if confirm "Set zsh to default shell?"; then
			sudo usermod -s /usr/bin/zsh $USER && echo "Zsh is now the default shell."
		fi ;;
	Darwin)
		# Install homebrew
		curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash

		# Install packages
		brew install --cask docker stats
		brew install iterm2 ripgrep docker-compose neovim pdm

		# Install iterm shell integration and remove zshrc (so it can be loaded later)
		curl -fsSL https://iterm2.com/shell_integration/install_shell_integration.sh | bash
		rm ~/.zshrc ;;
	*) echo "Unrecognized OS. Aborting" && exit 1 ;;
esac

git config --global --add include.path .additional.gitconfig

# Clone and checkout dotfiles
git clone --no-checkout --config status.showUntrackedFiles=no\
	https://github.com/nisheethlahoti/dotfiles.git ~/.temp &&
mv ~/.temp/.git ~/.dotfiles.git &&
rm -d ~/.temp &&
git --git-dir=$HOME/.dotfiles.git/ config core.worktree ~ &&
git --git-dir=$HOME/.dotfiles.git/ checkout &&
echo "All config files downloaded and checked out" || echo "Unable to checkout config files"

zsh <(curl -L micro.mamba.pm/install.sh)  # Install micromamba
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash  # Install nvm
ssh-keygen -t ed25519 # Generate ssh keypair

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh  # Install Rust
cargo install atuin  # Install rust-based packages

# Remove changes done to zshrc etc. on plugin installation
git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME checkout HEAD -- $HOME

# Do the rest in a new zsh session
zsh -c "micromamba install python pynvim ruff debugpy ; nvm install stable ; npm install -g pyright"
