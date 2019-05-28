git clone --bare --config status.showUntrackedFiles=no https://github.com/nisheethlahoti/dotfiles.git ~/.dotfiles.git
git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME checkout
echo "source ~/.additional.bash.rc" >> ~/.bashrc
sudo add-apt-repository -y ppa:neovim-ppa/stable
sudo apt-get -y install neovim
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
nvim -c "PlugInstall | qa"
