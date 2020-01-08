# the magic script that gets called by all the others to filter and forward the key combo

import re

#if re.match('^((?!.*Emacs).)*$', window.get_active_class()):
if re.match('.*(xfce4-terminal)', window.get_active_class()) is not None:
    h = store.get_global_value('hotkey')
    if h == '<alt>+t':
        keyboard.send_keys('<ctrl>+<shift>+t')
    elif h == '<alt>+v':
        keyboard.send_keys('<ctrl>+<shift>+v')
    elif h == '<alt>+a':
        keyboard.send_keys('<ctrl>+<shift>+a')
    elif h == '<alt>+f':
        keyboard.send_keys('<ctrl>+<shift>+f')
    else:
        keyboard.send_keys(h)
else:
    keyboard.send_keys(store.get_global_value('keycmd'))

store.remove_global_value('hotkey')
store.remove_global_value('keycmd')
