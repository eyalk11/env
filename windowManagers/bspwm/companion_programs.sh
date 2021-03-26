#! /bin/sh
pgrep sxhkd || \
  sxhkd -m -1 -c "$HOME/.config/sxhkd/sxhkdrc" \
  "$DOTFILES_DIR"/windowManagers/bspwm/sxhkd/*.sxhkd \
   >| $HOME/.logs/sxhkd.log 2>| $HOME/.logs/sxhkd.err &

wallpaper="$HOME/Pictures/wallpaper.jpg"
if [ -f "$wallpaper" ]; then
  feh --bg-fill "$wallpaper" &
fi
unset wallpaper

# -b starts as a bg process
picom --config "$DOTFILES_DIR"/desktop_elements/picom.conf -b \
   >| $HOME/.logs/picom.log 2>| $HOME/.logs/picom.err

"$DOTFILES_DIR"/windowManagers/bspwm/scripts/floating_noborder.sh &

# flashfocus &
# pgrep autokey-gtk || autokey-gtk \
#    > $HOME/.logs/autokey.log 2> $HOME/.logs/autokey.err &
#   autokey-run -s "$DOTFILES_DIR"/windowManagers/bspwm/autokey/bindings.py