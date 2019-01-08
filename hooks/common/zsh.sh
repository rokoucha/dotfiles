#!/bin/sh

# zplug
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | ZPLUG_HOME=$_INSTALL/.zplug zsh

# prezto
ln -s $_INSTALL/.zplug/repos/sorin-ionescu/prezto $_INSTALL/.zprezto

