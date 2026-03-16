#!/usr/bin/env sh
HYPRGAMEMODE=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')

if [ "$HYPRGAMEMODE" = 1 ] ; then
    hyprctl --batch "\
        keyword animations:enabled 1;\
        keyword animations:first_launch_animation 0;\
        keyword decoration:blur:enabled 1;\
        keyword decoration:blur:passes 1;\
        keyword decoration:blur:size 3;\
        keyword decoration:drop_shadow 0;\
        keyword misc:vfr 1"
    exit
fi

