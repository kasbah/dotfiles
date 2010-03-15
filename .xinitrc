#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

# exec gnome-session
# exec startkde
# exec startxfce4
# ...or the Window Manager of your choice
#exec openbox-session
#exec dbus-launch --exit-with-session openbox-session
#eval `cat $HOME/.fehbg`
feh --bg-scale /home/kaspar/Pictures/swahilidark.png
export AWT_TOOLKIT=MToolkit
#nm-applet 
xsetroot -cursor_name left_ptr
keytouchd &
syndaemon -i 0.5 &
echo ~ > ~/.cwd &
exec ck-launch-session xmonad
