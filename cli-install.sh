#!/bin/bash
# Simple script to install packages on DEBIAN BASED distros
# Run as default user...
SCRIPT_VERSION="1.0.0"

# Normally all output is hidden. Redirect these streams to log files if needed...
REDIRECT_STDERR='/dev/null'
REDIRECT_STDOUT='/dev/null'

# Development environment config
NODEJS_LATEST_STABLE="16.14.2"
NODEJS_DOWNLOAD_URL="https://nodejs.org/dist/v$NODEJS_LATEST_STABLE/node-v$NODEJS_LATEST_STABLE-linux-x64.tar.xz"
DOTFILES_REPO_URL="https://github.com/varajala/dotfiles.git"
DOTNET_INSTALL_SCRIPT_URL="https://dot.net/v1/dotnet-install.sh"

# Temporary location for all downloaded files during install
DOWNLOAD_DIR="/tmp/.install-downloads"

echo " -- Commandline environment install script (v$SCRIPT_VERSION) -- "
echo -n "Press ENTER to start, CTRL+C to cancel... "
read user_prompt

echo "Starting installation. All downloads can be found in '$DOWNLOAD_DIR'."
echo ""

apt_install_pkgs() {
    local pkg_list=$(echo "$@" | tr ' ' '\n')
    for pkg in $pkg_list; do
        echo " + (APT) $pkg"
    done
    sudo apt-get install -y -qq "$@" 2>"$REDIRECT_STDERR" 1>"$REDIRECT_STDOUT"
}

pip_install_pkgs() {
    local pkg_list=$(echo "$@" | tr ' ' '\n')
    for pkg in $pkg_list; do
        echo " + (PIP) $pkg"
    done
    python3 -m pip install "$@" 2>"$REDIRECT_STDERR" 1>"$REDIRECT_STDOUT"
}

npm_install_pkgs() {
    local pkg_list=$(echo "$@" | tr ' ' '\n')
    for pkg in $pkg_list; do
        echo " + (NPM) $pkg"
    done
    "$HOME/dev/js/.node/$NODEJS_LATEST_STABLE/bin/npm" install -g "$@" 2>"$REDIRECT_STDERR" 1>"$REDIRECT_STDOUT"
}

mkdir -p "$DOWNLOAD_DIR"

# Essential packages
echo "-> Installing base packages..."
apt_install_pkgs \
    git \
    vim \
    wget \
    zip \
    tar \
    gzip \
    build-essential

# CLI tools
echo "-> Installing CLI tools..."
apt_install_pkgs \
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

# Dev folders
echo "-> Setting up user directories..."
mkdir -p "$HOME/dev"
mkdir -p "$HOME/dev/py"
mkdir -p "$HOME/dev/cs"
mkdir -p "$HOME/dev/js"
mkdir -p "$HOME/dev/sh"
mkdir -p "$HOME/dev/clang"

# SSH
echo "-> Generating SSH key..."
mkdir -p "$HOME/.ssh"
ssh-keygen -t ed25519 -N '' -f "$HOME/.ssh/id_ed25519" 2>"$REDIRECT_STDERR" 1>"$REDIRECT_STDOUT"
if [[ -z $SSH_AUTH_SOCK ]]; then
    echo "-> Starting ssh-agent..."
    eval $(ssh-agent -s) 2>"$REDIRECT_STDERR" 1>"$REDIRECT_STDOUT"
fi
echo "-> Adding SSH key to agent..."
ssh-add "~/.ssh/id_ed25519" 2>"$REDIRECT_STDERR" 1>"$REDIRECT_STDOUT"

# Python
echo "-> Installing development packages for Python..."
apt_install_pkgs \
    python3 \
    python3-pip \
    python3-venv

# C
echo "-> Installing development packages for C..."
apt_install_pkgs \
    gcc \
    clang \
    make \
    pkg-config \
    gdb \
    valgrind

# .NET
echo "-> Setting up .NET..."
wget -q "$DOTNET_INSTALL_SCRIPT_URL" -O "$DOWNLOAD_DIR/dotnet-install.sh"
chmod u+x "$DOWNLOAD_DIR/dotnet-install.sh"
echo "-> Installing .NET SDK version 3.1..."
"$DOWNLOAD_DIR/dotnet-install.sh" -c "3.1" --install-dir "$HOME/.dotnet" 2>"$REDIRECT_STDERR" 1>"$REDIRECT_STDOUT"
echo "-> Installing .NET SDK version 5.0..."
"$DOWNLOAD_DIR/dotnet-install.sh" -c "5.0" --install-dir "$HOME/.dotnet" 2>"$REDIRECT_STDERR" 1>"$REDIRECT_STDOUT"
echo "-> Installing .NET SDK version 6.0..."
"$DOWNLOAD_DIR/dotnet-install.sh" -c "6.0" --install-dir "$HOME/.dotnet" 2>"$REDIRECT_STDERR" 1>"$REDIRECT_STDOUT"

# NodeJS
echo "-> Setting up NodeJS..."
mkdir -p "$HOME/dev/js/.node"
wget -q "$NODEJS_DOWNLOAD_URL" -O "$DOWNLOAD_DIR/nodejs-linux-binaries.tar.xz"
tar xf "$DOWNLOAD_DIR/nodejs-linux-binaries.tar.xz" --directory "$HOME/dev/js/.node"
mv "$HOME/dev/js/.node/node-v$NODEJS_LATEST_STABLE-linux-x64" "$HOME/dev/js/.node/$NODEJS_LATEST_STABLE"
export PATH="$PATH:$HOME/dev/js/.node/$NODEJS_LATEST_STABLE/bin"
echo "-> Installing NPM packages..."
npm_install_pkgs typescript yarn

# DOTFILES
echo "-> Setting up dotfiles..."
mkdir -p "$HOME/.vim"
git clone "$DOTFILES_REPO_URL" "$DOWNLOAD_DIR/dotfiles" 2>"$REDIRECT_STDERR" 1>"$REDIRECT_STDOUT"
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
mv "$DOWNLOAD_DIR/dotfiles/.gitconfig" $HOME
source "$HOME/.bashrc"

# VIM
echo "-> Setting up vim..."
mkdir -p "$HOME/.vim/undo"
mkdir -p "$HOME/.vim/autoload"
wget -q "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" -O "$HOME/.vim/autoload/plug.vim"
echo "-> Installing dependencies..."
pip_install_pkgs mypy python-language-server pyls_mypy
apt_install_pkgs clangd exuberant-ctags
echo "-> Update the clangd path in .vimrc if needed. Default is '/usr/lib/llvm-13'."
vim -c "PlugInstall | qa" 2>"$REDIRECT_STDERR" 1>"$REDIRECT_STDOUT"
echo -ne "colorscheme nord\n\n" >> "$HOME/.vimrc"

echo ""
echo "Install complete. Use 'source ~/.bashrc' for updated shell config..."

