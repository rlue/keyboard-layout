#!/bin/sh

# FAILURE CASES ================================================================
if [ $(whoami) != "root" ]; then
  >&2 echo "$(basename "$0"): requires superuser privileges (use sudo)"
  exit 1
fi

# RESTORATION OF DEFAULT XKB INSTALLATION ======================================
rm /usr/share/X11/xkb/symbols/hhkb 2>/dev/null && \
  echo "Removing custom hhkb symbols from /usr/share/X11/xkb/symbols..." || \
  >&2 echo "Custom hhkb symbols file not found. Skipping..."

if [ -f "/usr/share/X11/xkb/rules/base.orig" ]; then
  echo "Restoring base rules files in /usr/share/X11/xkb/rules..."
  mv /usr/share/X11/xkb/rules/base.orig /usr/share/X11/xkb/rules/base
elif grep 'hhkb:from_us' "/usr/share/X11/xkb/rules/base" >/dev/null 2>&1; then
  >&2 echo "Backup of base rules not found. Modifying current version instead..."
  sed -i '/hhkb:from_us/d' /usr/share/X11/xkb/rules/base
else
  >&2 echo "Backup of base rules not found, and current version appears unmodified. Skipping..."
fi

if [ -f "/usr/share/X11/xkb/rules/evdev.orig" ]; then
  echo "Restoring edev rules files in /usr/share/X11/xkb/rules..."
  mv /usr/share/X11/xkb/rules/evdev.orig /usr/share/X11/xkb/rules/evdev
elif grep 'hhkb:from_us' "/usr/share/X11/xkb/rules/evdev" >/dev/null 2>&1; then
  >&2 echo "Backup of evdev rules not found. Modifying current version instead..."
  sed -i '/hhkb:from_us/d' /usr/share/X11/xkb/rules/evdev
else
  >&2 echo "Backup of evdev rules not found, and current version appears unmodified. Skipping..."
fi

if grep '^XKBOPTIONS="hhkb:from_us"$' "/etc/default/keyboard" >/dev/null 2>&1; then
  echo "Removing XKBOPTIONS entry from /etc/default/keyboard..."
  sed -i '/^XKBOPTIONS="hhkb:from_us"$/d' /etc/default/keyboard
else
  >&2 echo "No reference to custom hhkb options found in /etc/default/keyboard. Skipping..."
fi

echo
echo "Removal complete! Your XKB installation should now be restored to its original state."
