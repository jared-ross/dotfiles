#!/bin/sh

#   Settings 
xmodmap ~/.Xmodmap &
setxkbmap -option compose:menu
xsetroot -solid '#073642'

#   Daemons
dropbox start &
urxvtd &

while xsetroot -name "`date '+%R | %A of %B | %d/%m/%y'` | `uptime | sed 's/.*,//'`"
do sleep 1; done &

{ 
right='VGA1'
left='LVDS1'
if `xrandr | grep -q "${right} connected"`; then
    xrandr --output "${right}" --auto --output "${left}" --auto
    xrandr --output "${right}" --right-of "${left}"
    xrandr --output "${right}" --auto --output "${left}" --auto
fi
} &

exec ssh-agent dwm
