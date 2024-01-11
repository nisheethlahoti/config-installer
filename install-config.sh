# Function to prompt user for yes/no and return with corresponding value
confirm() { read -ren 1 -p "$1 [Y/n] " <&2 ; ! [[ $REPLY =~ ^[Nn]$ ]]; }

git config --global --add include.path .additional.gitconfig

# Clone and checkout dotfiles
git clone --bare --config status.showUntrackedFiles=no\
	https://github.com/nisheethlahoti/dotfiles.git ~/.dotfiles.git &&
git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME checkout &&
git --git-dir=$HOME/.dotfiles.git/ config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*" &&
git --git-dir=$HOME/.dotfiles.git/ config branch.master.remote origin &&
echo "All config files downloaded and checked out" || echo "Unable to checkout config files"

# Install neovim plugins
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim &&
nvim -c "PlugInstall | qa" - < /dev/null &&
echo "Neovim plugins installed" || echo "Unable to install neovim plugins"

# Install micromamba, and basic python tools
zsh <(curl -L micro.mamba.pm/install.sh)
micromamba install python isort black

# Install nvm, npm and pyright
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
nvm install stable
npm install -g pyright

# Generate ssh keypair
ssh-keygen -t ed25519
