# OS-specific stuff
case $(uname -s) in
	Linux)
		# Install system packages
		case $(cat /etc/os-release | grep "^ID=" | sed "s/ID=//") in
			ubuntu)
				sudo apt -y install gcc git ripgrep zsh rsync npm trash-cli atuin &&
				sudo snap install --classic nvim &&
				curl -LsSf https://astral.sh/uv/install.sh | sh;;
			fedora)
				sudo dnf install \
					https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
					https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm  # Use rpmfusion nonfree repos
				sudo dnf update &&
				sudo dnf -y install gcc git ripgrep zsh neovim rsync nodejs-npm trash-cli uv &&
				curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh;;  # Install atuin
			arch)
				sudo pacman --noconfirm -S gcc git ripgrep zsh neovim uv htop tmux rsync npm pkgfile trash-cli atuin unzip &&
				sudo pkgfile --update;;
			*) echo "Unrecognized linux flavor" && false
		esac || { echo "Unable to install packages. Aborting" && exit 1; }

		sudo timedatectl set-timezone Asia/Kolkata
		sudo usermod -s /usr/bin/zsh $USER && echo "Zsh is now the default shell." ;;
	Darwin)
		# Install homebrew
		curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash

		# Install packages
		brew install --cask stats
		brew install ghostty ripgrep neovim rsync node uv atuin;;
	*) echo "Unrecognized OS. Aborting" && exit 1 ;;
esac

# Install iterm shell integration
curl -fsSL https://iterm2.com/shell_integration/zsh -o ~/.iterm2_shell_integration.zsh

git config --global --add include.path .additional.gitconfig

# Clone and checkout dotfiles
git clone --no-checkout --config status.showUntrackedFiles=no\
	https://github.com/nisheethlahoti/dotfiles.git ~/.temp &&
mv ~/.temp/.git ~/.dotfiles.git &&
rm -d ~/.temp &&
git --git-dir=$HOME/.dotfiles.git/ config core.worktree ~ &&
git --git-dir=$HOME/.dotfiles.git/ checkout HEAD -- ~ &&
echo "All config files downloaded and checked out" || echo "Unable to checkout config files"

# Install TMUX plugins
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/bin/install_plugins

# Create base python environment and install neovim's python client in it
PATH=$HOME/.local/bin:$PATH  # In case uv is a local install
uv venv ~/basepython --managed-python
uv pip install -p ~/basepython/bin/python pynvim
