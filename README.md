# keyboard-layout #

These are [XKB](https://en.wikipedia.org/wiki/X_keyboard_extension)
configuration files for achieving a UNIX-like layout on today's
prevailing U.S. PC keyboards, where Caps lock is on the left edge of
the keyboard, Control is in the lower left corner, Escape is in the
top left corner beside the function keys, Backspace is one row below
on the right edge, and Backslash is one row below that one and also on
the right edge.

By "UNIX-like," I mean the layout found on the [Happy Hacking
Keyboard](https://en.wikipedia.org/wiki/Happy_Hacking_Keyboard), where

- Control is the leftmost key on the home row,
- Escape is directly to the left of the number keys,
- Backspace (or Delete) is directly above Enter,
- Backslash is above Backspace, and
- there is no dedicated Caps lock key.

The Happy Hacking and Sun Type 3 keyboards split what is the Backspace
key on PC keyboards into two—Backslash and Tilde—so I moved Tilde
left Control.


## Installation ##

### Automatic ###

```sh
$ sudo ./install.sh
```

### Manual ###

1. Copy the custom symbols file to your XKB installation directory:

   ```sh
   $ sudo cp {,/usr/share/X11/xkb/}symbols/hhkb
   ```

2. Register a new option in the appropriate rules file
   ([`evdev` on Linux; `base` on other \*NIX systems](https://unix.stackexchange.com/a/413429/176219)):

   ```sh
   # /usr/share/X11/xkb/rules/evdev (or base)

   ! options	=	symbol
     hhkb:from_us       =       +hhkb(from_us)
     ...
   ```
   
3. Add an `XKBOPTIONS` entry to your `/etc/default/keyboard` file:
   
   ```sh
   # /etc/default/keyboard
   
   # Base configuration
   XKBOPTIONS="hhkb:from_us"

   # Or, with swapped modifier keys
   XKBOPTIONS="hhkb:from_us,altwin:swap_alt_win,ctrl:rctrl_ralt"
   ```

## Reference ##

Some helpful information for defining keyboard layouts in XKB:

- [An Unreliable Guide to XKB Configuration](http://www.charvolant.org/doug/xkb/html/)
  - [5 XKB Configuration Files](http://www.charvolant.org/doug/xkb/html/node5.html)
- [A simple, humble but comprehensive guide to XKB for linux](https://medium.com/@damko/a-simple-humble-but-comprehensive-guide-to-xkb-for-linux-6f1ad5e13450)
  - [damko/xkb_kinesis_advantage_dvorak_layout: A US variant layout for XKB that supports Italians deadkeys. Especially meant for Kinesis Advantage keyboard](https://github.com/damko/xkb_kinesis_advantage_dvorak_layout)
- [Creating custom keyboard layouts for X11 using XKB](https://michal.kosmulski.org/computing/articles/custom-keyboard-layouts-xkb.html)
- [10.10 - Simplest way to swap esc key with ` key - Ask Ubuntu](https://askubuntu.com/questions/32966/simplest-way-to-swap-esc-key-with-key)
  - [ubuntu - keyboard layout howto](https://ubuntuforums.org/showthread.php?p=10286878#post10286878)
