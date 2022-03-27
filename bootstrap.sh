#!/usr/bin/env bash
echo "Installing Zsh and set is as default login shell..." && \
brew install zsh
# Switch to using brew-installed bash as default shell
if ! fgrep -q '/usr/local/bin/zsh' /etc/shells; then
  echo '/usr/local/bin/zsh' | sudo tee -a /etc/shells;
  chsh -s /usr/local/bin/zsh;
  sudo dscl . -create /Users/$USER UserShell /usr/local/bin/zsh
fi;

#Install Shell plugins
echo -ne "installing custom plugins: thefuck, hostess... "
brew install thefuck hostess >/dev/null 2>&1
cd $HOME && \
# clone .dotfile
rm -fr $HOME/.dotfiles/.git && \
mv .zshrc .zshrc.pre-nurrony-dotfiles && \
ln -sf $HOME/.dotfiles/.{zshrc,curlrc,gemrc,gitattribute,gitconfig,gitignore,vimrc,wgetrc} $HOME/
echo 'All are done. Applying changes..'
source $HOME/.zshrc && \
printf "\nTo prepare your pc more developer friendly you can run the following scripts\n\n"
printf 'chmod +x ./brew.sh && ./brew.sh\n\n'

printf "To customise your macOS installation according to most developer\'s preferences run the following command\n"

printf 'chmod +x ./.macos && ./.macos\n\n'

echo 'Happy Hacking!!!'
