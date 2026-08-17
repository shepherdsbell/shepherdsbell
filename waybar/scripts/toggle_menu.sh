#!/usr/bin/fish

# The name of our Eww window (defined in eww.yuck)
set WINDOW_NAME "sys_menu"

if eww active-windows | grep -q $WINDOW_NAME
    eww close $WINDOW_NAME
else
    eww open $WINDOW_NAME
end
