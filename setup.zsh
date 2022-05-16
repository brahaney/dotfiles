#!/usr/bin/env zsh

## Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing sudo time stamp until setup has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

## MacOS settings config
echo "#### MacOS settings setup"
source macos.zsh

## Install brew
if ! command -v brew &> /dev/null
then
    echo "##### Installing homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# brew packages to install
echo "##### Installing packages from brew"
brew update --force # https://github.com/Homebrew/brew/issues/1151
brew bundle --file=brew.txt

## Install oh-my-zsh if it isn't already
if ! [ -d ~/.oh-my-zsh ]; then
    echo "##### Installing oh-my-zsh"
    /bin/bash -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "##### oh-my-zsh is already installed"
fi
# Install powerlevel10k
if ! [ -d ~/.oh-my-zsh/custom/themes/powerlevel10k ]; then
    echo "##### Installing p10k"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
else
    echo "##### p10k is already installed"
fi

echo "##### copying custom scripts and dotfiles"
rsync -au .zshrc ${HOME}/.zshrc
rsync -au ./.oh-my-zsh ${HOME}/.oh-my-zsh
rsync -au ./.p10k.zsh ${HOME}/.p10k.zsh
rsync -au ./.ssh ${HOME}/.ssh