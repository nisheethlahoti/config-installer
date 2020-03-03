sudo apt -y install neovim bat ripgrep git
git clone --bare --config status.showUntrackedFiles=no https://github.com/nisheethlahoti/dotfiles.git ~/.dotfiles.git
git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME checkout
git --git-dir=$HOME/.dotfiles.git/ config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
echo "source ~/.additional.bash.rc" >> ~/.bashrc
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
nvim -c "PlugInstall | qa"
