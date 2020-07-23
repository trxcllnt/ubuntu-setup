# the magic script that gets called by all the others to filter and forward the key combo

import re

hotkey = store.get_global_value('hotkey')
keycmd = store.get_global_value('keycmd')

store.remove_global_value('hotkey')
store.remove_global_value('keycmd')

# print('window class:', window.get_active_class())
# print('window title:', window.get_active_title())
# print('hotkey:', str(hotkey))
# print('keycmd:', str(keycmd))

#if re.match('^((?!.*Emacs).)*$', window.get_active_class()):
if re.match('.*(xfce4-terminal)', window.get_active_class()) is not None:
    # If "Find" window is open, send translated key command.
    # Otherwise send alt version so terminal accels are used.
    keyboard.send_keys(
        hotkey
        if window.get_active_title() != 'Find' else 
        keycmd
    )
else:
    keyboard.send_keys(keycmd)
