#!/usr/bin/env bash
pushd $HOME
set -e
mkdir -p ~/Applications ~/.local/packages ~/.local/src
SRCDIR="$HOME/.local/src/workrave"
PACKAGE_DIR="$HOME/.local/packages/workrave"
rm -rf ~/Library/Preferences/com.workrave.plist || true
rm -rf ~/Library/Preferences/workrave.plist || true
rm -rf ~/.workrave || true
rm -rf "$SRCDIR" || true
rm -rf "$PACKAGE_DIR" || true
# Officially required packages:
wr_dependencies_official="gettext intltool gobject-introspection autoconf-archive gtk+ gtk-mac-integration gtkmm3 ice"
# These packages get it working without crashes, with caveat of no symbols/icons. IDK which one does the trick.
wr_dependencies_extra="automake autoconf libtool gnome-icon-theme hicolor-icon-theme"
brew install $wr_dependencies_official $wr_dependencies_extra
brew link --force gettext libffi
rm -rf "$SRCDIR"
git clone --depth 1 --single-branch --branch os-x-fixes https://github.com/palfrey/workrave/ "$SRCDIR"
cd "$SRCDIR"
autoreconf -if
intltoolize --automake --copy --force
./configure --prefix="$PACKAGE_DIR" --config-cache
make
make install
stow  --dir="$HOME/.local/packages" workrave --target="$HOME/.local"
popd
