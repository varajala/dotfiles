# dotfiles

Personal Linux config files.


## Setup

    mkdir /tmp/dotfiles-repo
    git clone https://github.com/varajala/dotfiles /tmp/dotfiles-repo
    rm -rf /tmp/dotfiles-repo/.git
    rm /tmp/dotfiles-repo/LICENSE
    rm /tmp/dotfiles-repo/README.md
    mv /tmp/dotfiles-repo/coc-settings.json ~/.vim
    mv /tmp/dotfiles-repo/* $HOME

