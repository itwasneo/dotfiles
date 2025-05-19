setxkbmap -option ctrl:nocaps
export XCURSOR_THEME=Adwaita
export XCURSOR_SIZE=48
xrdb -merge ~/.Xresources
xsetroot -cursor_name left_ptr
exec i3
