# the magic script that gets called by all the others to filter and forward the key combo

import re

#if re.match('^((?!.*Emacs).)*$', window.get_active_class()):
if re.match('.*(Guake|Gnome-terminal)', window.get_active_class()):
    keyboard.send_keys(store.get_global_value('hotkey'))
else:
    keyboard.send_keys(engine.get_return_value())
