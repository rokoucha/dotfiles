#!/bin/sh

###############################
#.xinitrc - executed by startx#
# atnanasi/dotfiles           #
###############################

#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
      [ -x "$f" ] && . "$f"
  done
  unset f
fi

LANG=ja_JP.UTF-8

###HOSTCONF###

LANG=en_US.UTF-8
