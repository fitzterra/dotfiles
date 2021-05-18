Cheatsheets
===========

Remembering all functionality of all apps being used is daunting. There are
many cheatsheets for all types of apps out there, but getting to them is
cumbersome via searching in a browser or looking through bookmarks.

My ideal would be a desktop app that stays hidden, and by pressing something
like `CTRL-F1` or similar, the full screen will be filled with the cheetsheat for
one app, navigable via arrow keys, and searchable (using vim keybindings), and
something like `CTRL-q` will cycle through other available cheatsheets like
`alt-tab` does on the desktop. I'm not sure this app exists, so this is my next
best thing.

I'll start creating my own cheatsheets for the things I need most. Other
cheatsheet are great, but sometimes has either too much or too little info.

Layout
------
* I will store all cheatseets in `~/dotfiles/cheatsheets` as markdown files.
* These will have a semi-formal structure of links to other cheatsheets of
    interest for the app
* Then my own set of cheats, with details on what it does, the keystrokes and
    if available a link to where the details were found.
* There will be one bash alias added called `cheatsheets` that will open the
    last cheatsheet using `gview` (this is to make sure we do not accidentally
    make edits).
* From `gview` we can search for keywords to find the cheat, or visit URLS
    directly with `gx`
* Cheatsheets can be updated, but needs a `w!` to write from `gview`

Reality
-------
To do the above, we will need to learn some vim scripting.
To start getting this in place, I will only have one alias for now called
`vimcheatsheet` which will open the cheatsheet for vim that is the start.
This can grow later.

