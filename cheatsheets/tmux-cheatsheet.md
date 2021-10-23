My Tmux Cheat Sheet
===================

External cheatsheets (open with `gx`):
* https://tmuxcheatsheet.com/

**Table of Content**

1. [Sessions](#sessions)
	1. [Start a new session](#start-a-new-session)
	2. [Start a new session with the name _mysession_](#start-a-new-session-with-the-name-_mysession_)
	3. [Kill/delete session _mysession_](#kill/delete-session-_mysession_)
	4. [Kill/delete all sessions but the current](#kill/delete-all-sessions-but-the-current)
	5. [Kill/delete all sessions but _mysession_](#kill/delete-all-sessions-but-_mysession_)
	6. [Rename session](#rename-session)
	7. [Detach from session](#detach-from-session)
	8. [Detach others on the session (Maximize window by detach other clients)](#detach-others-on-the-session-(maximize-window-by-detach-other-clients))
	9. [Show all sessions](#show-all-sessions)
	10. [Attach to last session](#attach-to-last-session)
	11. [Attach to a session with the name _mysession_](#attach-to-a-session-with-the-name-_mysession_)
	12. [Move to session](#move-to-session)
2. [Windows](#windows)
	1. [Start a new session with a new window](#start-a-new-session-with-a-new-window)
	2. [Create window](#create-window)
	3. [Rename current window](#rename-current-window)
	4. [Close current window](#close-current-window)
	5. [Previous window](#previous-window)
	6. [Next window](#next-window)
	7. [Switch/select window by number](#switch/select-window-by-number)
	8. [Reorder/swap windows](#reorder/swap-windows)
	9. [Move current window to the left by one position](#move-current-window-to-the-left-by-one-position)


Sessions
--------

### Start a new session
* `$ tmux`
* `$ tmux new`
* `$ tmux new-session`
* `: new`

### Start a new session with the name _mysession_
* `$ tmux new -s mysession`
* `: new -s mysession`

### Kill/delete session _mysession_
* `$ tmux kill-ses -t mysession`
* `$ tmux kill-session -t mysession`

### Kill/delete all sessions but the current
* `$ tmux kill-session -a`

### Kill/delete all sessions but _mysession_
* `$ tmux kill-session -a -t mysession`

### Rename session
* `CRTL-W $`

### Detach from session
* `CTRL-W d`

### Detach others on the session (Maximize window by detach other clients)
* `: attach -d`

### Show all sessions
* `$ tmux ls`
* `$ tmux list-sessions`
* `CTRL-W s`

### Attach to last session
* `$ tmux a`
* `$ tmux at`
* `$ tmux attach`
* `$ tmux attach-session`

### Attach to a session with the name _mysession_
* `$ tmux a -t mysession`
* `$ tmux at -t mysession`
* `$ tmux attach -t mysession`
* `$ tmux attach-session -t mysession`

### Move to session
* `CTRL-W (`  - previous
* `CTRL-W )`  - next

Windows
-------

### Start a new session with a new window
* `$ tmux new -s mysession -n mywindow`

### Create window
* `CTRL-W c`

### Rename current window
* `CTRL-W ,`

### Close current window
* `CTRL-W &`

### Previous window
* `CTRL-W p`

### Next window
* `CTRL-W n`

### Switch/select window by number
* `CTRL-W 0 ... 9`

### Reorder/swap windows
* `: swap-window -s 2 -t 1`  # Swaps window numner 2(src) and 1(dst)

### Move current window to the left by one position
* `: swap-window -t -1`


Rest to be done...
