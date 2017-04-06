## Post install

# Finish zplug install
zplug install

# For prezto
ln -s $HOME/.zplug/repos/sorin-ionescu/prezto $HOME/.zprezto
ln -s $HOME/.zplug/repos/sorin-ionescu/prezto $HOME/.zpreztorc

# I want to automated install vim-plug!!!
echo "You need to exec this command in zsh ':PlugInstall'"
