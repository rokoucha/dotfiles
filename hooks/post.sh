## Post install

# Finish zplug install
curl -sL zplug.sh/installer | zsh

# For prezto
ln -s $HOME/.zplug/repos/sorin-ionescu/prezto $HOME/.zprezto

# I want to automated install vim-plug!!!
echo "You need to exec this command in zsh 'zplug install'"
echo "You need to exec this command in vim ':PlugInstall'"
