#!/usr/bin/env bash
source "$DOTFILES_DIR/shell/script_functions.sh"
source "$DOTFILES_DIR/shell/functions.sh"

installID="Tmux"
installText="source-file $($SCRIPTDIR_CMD)/tmux/tmux.conf"
baseRC="${HOME}/.tmux.conf"

eval "$(cat <<END
do${installID}() {
    printErr "Enabling custom tmux setup..."
    addTextIfAbsent "${installText}" "${baseRC}"
  }
END
)"

eval "$(cat <<END
undo${installID}(){
    sed -in "s|.*${installText}.*||g" "${baseRC}"
  }
END
)"

installID="Kitty"
installText="include $($SCRIPTDIR_CMD)/kitty/kitty.conf"
baseRC="${HOME}/.config/kitty/kitty.conf"

eval "$(cat <<END
do${installID}() {
    printErr "Enabling Kitty setup..."
    addTextIfAbsent "${installText}" "${baseRC}"
    terminal_kitty_install
  }
END
)"

terminal_kitty_install(){
    local cacheDir="${XDG_CACHE_HOME:-$HOME/.cache}"/kitty
    mkdir -p "$cacheDir"
    git clone --depth 1 git@github.com:dexpota/kitty-themes.git "$cacheDir"/kitty-themes
    if ! command -v kitty > /dev/null 2>&1; then
      curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
    fi
}

eval "$(cat <<END
undo${installID}(){
    sed -in "s|.*${installText}.*||g" "${baseRC}"
  }
END
)"

installID="iTerm2"

eval "$(cat <<END
do${installID}() {
    printErr "Enabling iTerm2 setup..."
    # Specify the preferences directory
    defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "$($SCRIPTDIR_CMD)/iterm2"
    # Tell iTerm2 to use the custom preferences in the directory
    defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true
  }
END
)"

eval "$(cat <<END
undo${installID}(){
    true
  }
END
)"

installID="Termux"
eval "$(cat <<END
do${installID}() {
    printErr "Enabling Termux setup..."
    . "$($SCRIPTDIR_CMD)/termux/setup.sh"
  }
END
)"
eval "$(cat <<END
undo${installID}(){
    rm -rf "$HOME/.termux"
  }
END
)"

installID="Xresources"
installText="xrdb -merge \"$($SCRIPTDIR_CMD)/x/Xresources\""
baseRC="${HOME}/.Xresources"

eval "$(cat <<END
do${installID}() {
    printErr "Enabling custom Xresoruces setup..."
    addTextIfAbsent "${installText}" "${baseRC}"
  }
END
)"

eval "$(cat <<END
undo${installID}(){
    sed -in "s|.*${installText}.*||g" "${baseRC}"
  }
END
)"

# If directly run instead of sourced, do all
if [ ! "${BASH_SOURCE[0]}" != "${0}" ]; then
  doTmux
  if substrInStr "kitty" "$TERM"; then
    doKitty
  elif substrInStr "Android" "$(uname -a)"; then
    doTermux
  fi
  doXresources
fi
