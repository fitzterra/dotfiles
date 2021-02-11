Dotfiles
========

**Contents**

1. [Assumptions](#assumptions)
2. [Usage](#usage)
3. [Components](#components)
	1. [bash](#bash)
	2. [vim](#vim)
		1. [airline](#airline)

This is my dotfiles repo. I think I should have done this a long time ago :-)

Some really good resource: https://github.com/webpro/awesome-dotfiles

This will finally replace my easyEnv project started years ago: https://github.com/fitzterra/easyEnv

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

Components
----------

Dotfiles and their supporting files, etc. are organized in components.

Components:
* Can be installed/removed individually
* Each have their own directory
* Have a `README.component` file in the component directory giving a short
  description of what this component does. This text is used when listing
  components on the command line (`-c list` option).
* Have their own dotfiles and dir structures in the component directory
* May have any one of the following install/uninstall scripts:
    - `_pre_setup.sh` - always called before installing/re-installing the component
    - `_post_setup.sh` - always called after install/re-install
    - `_pre_remove.sh` - called before removing the component
    - `_post_remove.sh` - called after removing the component
* Could have it's own `xstow.ini` file to configure dot file installation
  specifically for the component.


### bash

### vim

#### airline
To get the nice arrows in the status line, install the `fonts-powerline` package:

    $ sudo aptitude install fonts-powerline

See [here][https://github.com/vim-airline/vim-airline/wiki/Dummies-Guide-to-the-status-bar-symbols-(Powerline-fonts)-on-Fedora,-Ubuntu-and-Windows] for help.

### tmux
For tmux, we use the [Oh My Tmux] repo as base for setup and config of a very
nice tmux environment.

This tmux repo is installed as a git submodule. To setup this the `ohmtmux`
submodule a fresh clone of this repo, do:
`$ git submodule init`
`$ git submodule update`

Anothger way to do this when cloning this repo is to pass the
`--recurse-summodules` arg to the clone command. This will automatically
initialize and update all submodules.

The OhMyTmux installation has a default `.tmux.conf` in the repo which we
create a symlink to in the `tmux` subdir of this repo. This is the base tmux
config for OhMyTmux, and we create a symlink to it in the `tmux` subdir of this
repo.
We also have a `tmux.conf.local` config file in the `tmux` subdir. These are
our local tmux modifications on top of OhMYTmux.
At installtion of the dotfiles, symlinks in the home dir will be created to
both the `.tmux.conf` and `.tmux.conf.local` config files.
The default `~/.tmux.conf` file will try source the `~/.tmux.conf.local` file
if it exists, and this is how we set up the base OhMyTux with our own tmux
config changes.

[Oh My Tmux]: https://github.com/gpakosz/.tmux 
