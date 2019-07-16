MacOS-like [Autokey](https://github.com/autokey/autokey) bindings for Ubuntu
==============

Some [Autokey](https://apps.ubuntu.com/cat/applications/autokey-gtk/) settings to change the keybindings in Ubuntu to mostly match those found in macOS. Originally pulled from [this repo](https://github.com/metakermit/dotfiles/tree/83108c4fda4fe38c108447dfde9c5660b3bbc1b8/autokey).

Instead of re-mapping `ctrl` to `left-alt` across the entire operating-system, these settings only map the most commonly used `Apple + keyX` shortcuts. Feel free to contribute any you use as well.

To achieve this, a remapping of the old functions (new window, tab, print, select all, ...) was also done so that they are accessible through the `alt` key (`alt+n`, `alt+t` etc.)

A list of apps that are not included is defined in the `combo.py` script.

Note that I'm using `<alt>` to represent `<cmd>`, because I'm using a PC keyboard on my Ubuntu laptop, but you can easily make this work as expected on an Apple keyboard, too - just go to system settings -> keyboard -> keyboard layout -> options... and select under Alt/Win key behaviour "Left Alt is swapped with Left Win". Alternatively, you can edit my scripts (the content and the .json files) and just replace all the `<alt>` keys with `<super>`.

It's also handy to modify your terminal keybindings for copy/cut/paste to use `left-alt` instead of `ctrl+shift`.

Installation
------------
Place the scripts anywhere inside `~/.config/autokey/` (or symlink from this repo to that directory) and add `autokey` to your startup applications (dash -> startup applications in Ubuntu).
