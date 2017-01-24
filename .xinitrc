#!/bin/sh
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
source ~/.xprofile

#For awesome
#source ~/.awesomerc
#exec awesome

#For i3
source ~/.i3rc
exec i3 -V >> ~/.config/i3/i3log-$(date +'%F-%k-%M-%S') 2>&1

#For Xmonad
#source ~/.xmonadrc
#exec xmonad

LANG=en_US.UTF-8
