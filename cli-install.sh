#!/bin/bash
# Simple script to install packages on DEBIAN BASED distros
# Run as default user...

# Development environment config
NODEJS_LATEST_STABLE="16.14.2"
NODEJS_DOWNLOAD_URL="https://nodejs.org/dist/v$NODEJS_LATEST_STABLE/node-v$NODEJS_LATEST_STABLE-linux-x64.tar.xz"
DOTFILES_REPO_URL="https://github.com/varajala/dotfiles.git"
DOTNET_INSTALL_SCRIPT_URL="https://dot.net/v1/dotnet-install.sh"


# Temporary location for all downloaded files during install
DOWNLOAD_DIR="/tmp/.install-downloads"
mkdir -p "$DOWNLOAD_DIR"

install_pkgs() {
    sudo apt-get install -y "$@"
}


# Essential packages
echo "- Installing base packages..."
install_pkgs \
    git \
    vim \
    wget \
    zip \
    tar \
    gzip \
    build-essential

echo "- Base packages installed."

# CLI tools
echo "- Installing CLI tools..."
install_pkgs \
    zsh \
    zsh-syntax-highlighting \
    zsh-autosuggestions \
    exa \
    fzf \
    ripgrep \
    bat \
    tmux \
    net-tools \
    docker \
    less \
    tree \
    curl \
    man-db \
    manpages \
    sed \
    openconnect \
    htop
echo "- CLI tools installed."

# Dev folders
echo "- Setting up development environment..."
mkdir -p "$HOME/dev"
mkdir -p "$HOME/dev/py"
mkdir -p "$HOME/dev/cs"
mkdir -p "$HOME/dev/js"
mkdir -p "$HOME/dev/sh"
mkdir -p "$HOME/dev/clang"

# Python
echo "   > Installing development packages for Python..."
install_pkgs \
    python3 \
    python3-pip \
    python3-venv
echo "   > Packages installed for Python."

# C
echo "   > Installing development packages for C..."
install_pkgs \
    gcc \
    clang \
    make \
    pkg-config \
    gdb \
    valgrind
echo "   > Packages installed for C."

# .NET
echo "   > Setting up .NET..."
echo "     -> Fetching .NET install script..."
wget -q "$DOTNET_INSTALL_SCRIPT_URL" -O "$DOWNLOAD_DIR/dotnet-install.sh"
chmod u+x "$DOWNLOAD_DIR/dotnet-install.sh"
echo "     -> Installing .NET..."
"$DOWNLOAD_DIR/dotnet-install.sh" -c "3.1" --install-dir "$HOME/.dotnet"
"$DOWNLOAD_DIR/dotnet-install.sh" -c "5.0" --install-dir "$HOME/.dotnet"
"$DOWNLOAD_DIR/dotnet-install.sh" -c "6.0" --install-dir "$HOME/.dotnet"
echo "     -> .NET SDKs installed."
echo "   > .NET setup complete."

# NodeJS
echo "   > Setting up NodeJS..."
mkdir -p "$HOME/dev/js/.node"
echo "     -> Fetching LTS binaries for Linux-x64..."
wget -q "$NODEJS_DOWNLOAD_URL" -O "$DOWNLOAD_DIR/nodejs-linux-binaries.tar.xz"
tar xf "$DOWNLOAD_DIR/nodejs-linux-binaries.tar.xz" --directory "$HOME/dev/js/.node"
mv "$HOME/dev/js/.node/node-v$NODEJS_LATEST_STABLE-linux-x64" "$HOME/dev/js/.node/$NODEJS_LATEST_STABLE"
export PATH="$PATH:$HOME/dev/js/.node/$NODEJS_LATEST_STABLE/bin"
echo "     -> installing NPM packages..."
"$HOME/dev/js/.node/$NODEJS_LATEST_STABLE/bin/npm" install -g typescript yarn
echo "   > NodeJS setup complete."


# DOTFILES
echo "   > Fetching dotfiles..."
mkdir -p "$HOME/.vim"
git clone "$DOTFILES_REPO_URL" "$DOWNLOAD_DIR/dotfiles"
mv "$DOWNLOAD_DIR/dotfiles/coc-settings.json" ~/.vim
mv "$DOWNLOAD_DIR/dotfiles/.vimrc" $HOME
mv "$DOWNLOAD_DIR/dotfiles/.bashrc" $HOME
mv "$DOWNLOAD_DIR/dotfiles/.zshrc" $HOME
mv "$DOWNLOAD_DIR/dotfiles/.nanorc" $HOME
mv "$DOWNLOAD_DIR/dotfiles/.inputrc" $HOME
mv "$DOWNLOAD_DIR/dotfiles/.shell-config" $HOME
mv "$DOWNLOAD_DIR/dotfiles/.bash-completions" $HOME
mv "$DOWNLOAD_DIR/dotfiles/.zsh-completions" $HOME
mv "$DOWNLOAD_DIR/dotfiles/.tmux.conf" $HOME
mv "$DOWNLOAD_DIR/dotfiles/.profile" $HOME
source "$HOME/.bashrc"

# VIM
echo "  > Setting up vim..."
mkdir -p "$HOME/.vim/undo"
mkdir -p "$HOME/.vim/autoload"
wget -q "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" -O "$HOME/.vim/autoload/plug.vim"
python3 -m pip install mypy python-language-server pyls_mypy
install_pkgs clangd exuberant-ctags
echo "  [NOTE] Update the clangd path in .vimrc if needed. Default is '/usr/lib/llvm-13'."
vim -c "PlugInstall | qa"
echo -ne "colorscheme nord\n\n" >> "$HOME/.vimrc"
echo "  > Vim setup complete."


echo "- Development environment setup complete."

