# TODO: Update to log keystrokes to a file (e.g., keylog.txt)
# TODO: Implement cross-platform compatibility if needed
import keyboard
keys = keyboard.record(until ='ENTER')
keyboard.play(keys)
