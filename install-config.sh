# OS-specific stuff
case $(uname -s) in
	Linux)
		# Install system packages
		case $(cat /etc/os-release | grep "^ID=" | sed "s/ID=//") in
			ubuntu)
				sudo apt -y install gcc git ripgrep zsh trash-cli atuin &&
				sudo snap install --classic nvim &&
				curl -LsSf https://astral.sh/uv/install.sh | sh;;
			fedora)
				sudo dnf -y install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm && # Enable non-free repos
				sudo dnf -y install gcc git ripgrep zsh neovim trash-cli uv PackageKit-command-not-found &&
				curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh;;  # Install atuin
			arch)
				sudo pacman --noconfirm -S gcc git ripgrep zsh neovim uv htop tmux pkgfile trash-cli atuin unzip nvidia-open &&
				sudo pkgfile --update;;
			*) echo "Unrecognized linux flavor" && false
		esac || { echo "Unable to install packages. Aborting" && exit 1; }

		sudo timedatectl set-timezone Asia/Kolkata
		sudo usermod -s /usr/bin/zsh $USER && echo "Zsh is now the default shell." ;;
	Darwin)
		# Install homebrew
		curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash

		# Install packages
		brew install --cask docker stats
		brew install iterm2 ripgrep docker-compose neovim uv atuin;;
	*) echo "Unrecognized OS. Aborting" && exit 1 ;;
esac

# Install iterm shell integration
curl -fsSL https://iterm2.com/shell_integration/install_shell_integration.sh | bash

git config --global --add include.path .additional.gitconfig

# Clone and checkout dotfiles
git clone --no-checkout --config status.showUntrackedFiles=no\
	https://github.com/nisheethlahoti/dotfiles.git ~/.temp &&
mv ~/.temp/.git ~/.dotfiles.git &&
rm -d ~/.temp &&
git --git-dir=$HOME/.dotfiles.git/ config core.worktree ~ &&
git --git-dir=$HOME/.dotfiles.git/ checkout HEAD -- ~ &&
echo "All config files downloaded and checked out" || echo "Unable to checkout config files"

# Create base python environment and install neovim's python client in it
uv venv ~/basepython --python-preference only-managed
uv pip install -p ~/basepython/bin/python pynvim

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash  # Install nvm
source "$HOME/.nvm/nvm.sh"  # This loads nvm
nvm install stable  # Install stable version of node.js
