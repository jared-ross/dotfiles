#!/bin/sh

dropbox start
xmodmap ~/.Xmodmap

while xsetroot -name "`date '+%R | %A of %B | %d/%m/%y'` | `uptime | sed 's/.*,//'`"
do
	sleep 1
done &

xrandr |grep VGA| grep -q " connected " 
if [ $? -eq 0 ]; then
    xrandr --output VGA1 --right-of LVDS1
fi

exec ssh-agent dwm
