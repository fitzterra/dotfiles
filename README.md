Dotfiles
========

This is my dotfiles repo. I think I should have done this a long time ago :-)

Some really good resource: https://github.com/webpro/awesome-dotfiles

This will fianlly replace my easyEnv project started years ago: https://github.com/fitzterra/easyEnv

Assumptions
-----------

The following assumptions are made to make things easier to get this going, but
will not be very cross platform if not given attention:

* A Debian based environment is assumed
* A bash shell is used
* For this environment, setting up the bash shell adds a hook into `~/.bashrc`
    which then sources any local bash mods. This leaves `~/.bashrc` as close as
    possible to the maintainers version and makes it easy to add updated basrc
    version if needed.
* We use `xstow` instead of `stow` (no particular reason, other than it seems to
    add additional features which may be useful), and because this Debian, we
    offer to install it using apt-get if not installed
* For installing via apt-get, we assume you have sudo powers

Usage
-----

Still a work in progress, but make sure `xstow` is installed, then run the
`install.sh` script to install/update all dot files.

Also try `-h` to see more install options.
