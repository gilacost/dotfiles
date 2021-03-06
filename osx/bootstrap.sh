#!/bin/bash

# Custom Host Name

HOSTNAME_RESULT="$(scutil --get HostName 2>&1 > /dev/null)"
if [[ $HOSTNAME_RESULT =~ "not set" ]]; then
  read -p "Do you want to change the computer name? " -n 1 -r; echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    read -p "New Computer Name: " -r; echo
    sudo scutil --set HostName $REPLY
    echo "Restart terminal session to see results"
  fi
fi

# Brew

if ! [ -x "$(command -v brew)" ]; then
  read -p "Install Brew (OS X Package Manager)? " -n 1 -r; echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew cask
  fi
fi

# Git

read -p "Do you want to update git? " -n 1 -r; echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  brew install git
fi

# Fonts

read -p "Do you want to install nerd fonts? " -n 1 -r; echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  brew tap caskroom/fonts
  brew cask install font-hack-nerd-font font-hack-nerd-font-mono font-firacode-nerd-font font-firacode-nerd-font-mono
fi

# ZSH / Prezto

read -p "Do you want to update and configure zsh? " -n 1 -r; echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  brew install zsh fzf peco
  git clone --recursive https://github.com/sorin-ionescu/prezto.git ~/.zprezto
  git clone https://github.com/bhilburn/powerlevel9k.git  ~/.zprezto/modules/prompt/external/powerlevel9k
  ln -s ~/.zprezto/modules/prompt/external/powerlevel9k/powerlevel9k.zsh-theme ~/.zprezto/modules/prompt/functions/prompt_powerlevel9k_setup
  chsh -s /bin/zsh
  $(brew --prefix)/opt/fzf/install
  cp zsh/zshrc ~/.zshrc
  cp ~/.chunkwmrc ./zsh/chunkwmrc
fi

# Git

read -p "Do you want to configure git? " -n 1 -r; echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  read -p "Name? " -r
  git config --global user.name "$REPLY"
  read -p "Email? " -r
  git config --global user.email "$REPLY"
  echo "Now configure you SSH and GPG keys in GitHub, GitLab, BitBucket, etc."
  echo "GO TO: https://gist.github.com/bmhatfield/cc21ec0a3a2df963bffa3c1f884b676b"
  exit 0
fi

# Keyboard

if ! [ -d /Applications/Karabiner-Elements.app ]; then
  read -p "Configure the Keyboard? " -n 1 -r; echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    defaults write -g ApplePressAndHoldEnabled -bool true
    defaults write -g InitialKeyRepeat -int 10
    defaults write -g KeyRepeat -int 1
    brew cask install karabiner-elements
    mkdir -p ~/.config/karabiner
    cp -f ./karabiner/karabiner.json  ~/.config/karabiner/karabiner.json
    echo "L_CAP_LOCK remapped to CTRL/ESC. Restart the system now"
    exit 0
  fi
fi

# Window Tiling

if ! [ -x "$(command -v chunkwm)" ]; then
  read -p "Install chunkwm/skhd? " -n 1 -r; echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    brew tap crisidev/homebrew-chunkwm
    brew install chunkwm
    brew install koekeishiya/formulae/skhd
    cp ./skhd/skhdrc ~/.skhdrc
    cp ./chunkwm/chunkwmrc ~/.chunkwmrc
    brew services restart chunkwm
    brew services restart skhd
  fi
fi

# Kitty

if ! [ -d /Applications/kitty.app ]; then
  read -p "Install Kitty? " -n 1 -r; echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    brew cask install kitty
    mkdir -p ~/Library/Preferences/kitty
    cp ./kitty/kitty.conf ~/Library/Preferences/kitty/kitty.conf
    cp ./kitty/nvim.session ~/.nvim.session
  fi
fi

# Firefox

if ! [ -d /Applications/Firefox.app ]; then
  read -p "Install Firefox? " -n 1 -r; echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    brew cask install firefox
    brew install defaultbrowser
    defaultbrowser firefox
    echo "Now manually install uBlock, TST and userChrome.css (available in firefox folder)"
    exit 0
  fi
fi

# Franz (Mail / IM)

if ! [ -d /Applications/Franz.app ]; then
  read -p "Install Franz? " -n 1 -r; echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    brew cask install franz
  fi
fi

# NeoVim

if ! [ -x "$(command -v nvim)" ]; then
  read -p "Install neovim? " -n 1 -r; echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    brew install neovim python3
    pip3 install neovim-remote
    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    mkdir -p ~/.config/nvim
    cp ./nvim/init.vim ~/.config/nvim/init.vim
  fi
fi
