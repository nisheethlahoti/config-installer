# OS-specific stuff
case $(uname -s) in
	Linux)
		# Install system packages
		case $(cat /etc/os-release | grep "^ID=" | sed "s/ID=//") in
			ubuntu)
				sudo apt -y install gcc git ripgrep zsh trash-cli &&
				sudo snap install --classic nvim &&
				curl -sSL https://pdm-project.org/install-pdm.py | python3 - ;;
			fedora)
				sudo dnf -y install gcc git ripgrep zsh neovim trash-cli &&
				curl -sSL https://pdm-project.org/install-pdm.py | python3 - ;;
			arch) sudo pacman --noconfirm -S gcc git ripgrep zsh neovim python-pdm htop tmux pkgfile trash-cli atuin unzip;;
			*) echo "Unrecognized linux flavor" && false
		esac || { echo "Unable to install packages. Aborting" && exit 1; }

		# set zsh as default shell
		sudo usermod -s /usr/bin/zsh $USER && echo "Zsh is now the default shell." ;;
	Darwin)
		# Install homebrew
		curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash

		# Install packages
		brew install --cask docker stats
		brew install iterm2 ripgrep docker-compose neovim pdm atuin

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

# Remove changes done to zshrc etc. on plugin installation
git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME checkout HEAD -- $HOME

# Do the rest in a new zsh session
zsh -c "micromamba install python pynvim ; nvm install stable"
