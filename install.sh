#!/bin/sh

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

# FAILURE CASES ================================================================
if [ $(whoami) != "root" ]; then
  >&2 echo "$(basename "$0"): requires superuser privileges (use sudo)"
  exit 1
fi

if [ ! -f "$SCRIPTPATH/symbols/hhkb" ]; then
  >&2 echo "The installation source could not be found. Download a fresh copy of the repo and try again."
  exit 2
fi

if [ -f "/usr/share/X11/xkb/symbols/hhkb" ]; then
  >&2 echo "The installation target already exists. Consult the README for manual installation instructions."
  exit 2
fi

if [ ! -d "/usr/share/X11/xkb/symbols" ] || \
   [ ! -f "/usr/share/X11/xkb/rules/base" ] || \
   [ ! -f "/usr/share/X11/xkb/rules/evdev" ]; then
  >&2 echo "The system's XKB directory could not be found."
  exit 2
fi

# INSTALLATION =================================================================
echo "Copying custom hhkb symbols into /usr/share/X11/xkb/symbols..."
cp "$SCRIPTPATH/symbols/hhkb" /usr/share/X11/xkb/symbols/hhkb

echo "Modifying base and evdev rules files in /usr/share/X11/xkb/rules..."
sed -i.orig '/^! option[[:space:]]*=[[:space:]]*symbols$/a\ \ hhkb:from_us       =       +hhkb(from_us)' /usr/share/X11/xkb/rules/base
sed -i.orig '/^! option[[:space:]]*=[[:space:]]*symbols$/a\ \ hhkb:from_us       =       +hhkb(from_us)' /usr/share/X11/xkb/rules/evdev

echo "Adding XKBOPTIONS entry to /etc/default/keyboard..."
if grep "^XKBOPTIONS=" /etc/default/keyboard >/dev/null; then
  sed -i 's/^XKBOPTIONS=.*/# &\nXKBOPTIONS="hhkb:from_us"/' /etc/default/keyboard
else
  sed -i '$ a XKBOPTIONS="hhkb:from_us"' /etc/default/keyboard
fi

echo
echo "Installation complete! Restart your machine to use your new layout."
