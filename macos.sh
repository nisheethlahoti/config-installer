# Install homebrew
curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash

# Install packages
brew install --cask docker stats
brew install iterm2 ripgrep docker-compose neovim

# Install iterm shell integration and remove zshrc (so it can be loaded later)
curl -fsSL https://iterm2.com/shell_integration/install_shell_integration.sh | bash
rm ~/.zshrc
