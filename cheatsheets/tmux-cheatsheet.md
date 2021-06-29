My Tmux Cheat Sheet
===================

External cheatsheets (open with `gx`):
* https://tmuxcheatsheet.com/


Sessions
--------
* Start a new session
    - `$ tmux`
    - `$ tmux new`
    - `$ tmux new-session`
    - `: new`

* Start a new session with the name _mysession_
    - `$ tmux new -s mysession`
    - `: new -s mysession`

* Kill/delete session _mysession_
    - `$ tmux kill-ses -t mysession`
    - `$ tmux kill-session -t mysession`

* Kill/delete all sessions but the current
    - `$ tmux kill-session -a`

* Kill/delete all sessions but _mysession_
    - `$ tmux kill-session -a -t mysession`

* Rename session
    - `CRTL-W $`

* Detach from session
    - `CTRL-W d`

* Detach others on the session (Maximize window by detach other clients)
    - `: attach -d`

* Show all sessions
    - `$ tmux ls`
    - `$ tmux list-sessions`
    - `CTRL-W s`

* Attach to last session
    - `$ tmux a`
    - `$ tmux at`
    - `$ tmux attach`
    - `$ tmux attach-session`

* Attach to a session with the name _mysession_
    - `$ tmux a -t mysession`
    - `$ tmux at -t mysession`
    - `$ tmux attach -t mysession`
    - `$ tmux attach-session -t mysession`

* Move to session
    - `CTRL-W (`  - previous
    - `CTRL-W )`  - next


Rest to be done...
