set -e

sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt -y install bat git neovim ripgrep zsh
git clone --bare --config status.showUntrackedFiles=no https://github.com/nisheethlahoti/dotfiles.git ~/.dotfiles.git
git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME checkout
git --git-dir=$HOME/.dotfiles.git/ config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
git config --global --add include.path .additional.gitconfig
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
nvim -c "PlugInstall | qa" - < /dev/null

read -ren 1 -p "Do you know your password? [Y/n] " <&2
if [[ $REPLY =~ ^[Nn]$ ]]
then
	sudo cp /etc/pam.d/chsh /etc/pam.d/chsh.bak
	sed -Ee 's/required(\s+pam_shells\.so)/sufficient\1/' /etc/pam.d/chsh.bak |
		sudo tee /etc/pam.d/chsh > /dev/null
	chsh -s /usr/bin/zsh
	sudo mv /etc/pam.d/chsh.bak /etc/pam.d/chsh
else
	chsh -s /usr/bin/zsh
fi
