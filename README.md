Dotfiles
========

**Contents**

1. [Introduction](#introduction)
2. [Dotfiles Structure and Setup](#dotfiles-structure-and-setup)
3. [Assumptions](#assumptions)
4. [Usage](#usage)
5. [Components](#components)
	1. [bash](#bash)
	2. [vim](#vim)
		1. [airline](#airline)
	3. [tmux](#tmux)

Introduction
------------

This is where I manage my dotfiles and general work environment.

This is not only for dotfiles, but allows me to set up my full *nix work
environment on a new machine, or to update other existing machine to ensure I
have consistent work environment no matter where I log on.

With work environment, I mean my shell, the tools I use, the config and
_look 'n' feel_ of all tools and apps.

I live in the command line, so this is only applicable to Unix like
environments like Linux and MacOS, etc. I assume this will work on BSD type
systems and various types of Linux distros, but my preference is [Debian].

I also run MacOS, but without touching the Mac Store for anything, so all tools
and apps on MacOS are normally installed via [Homebrew]

It is also useful to run [Homebrew] on Linux, so some tools on Linux are
installed from there too.

Dotfiles Structure and Setup
----------------------------

The dotfiles structure, features, requirements, etc. can be summed up as
consisting of these parts:

* Main `~/dotfiles` dir:
    * This is usually created by cloning from the [repo][dotfiles_repo]
    * The repo contains git submodules, so using the `--recurse-submodules`
        flag when cloning is a good idea, but if not, the _install_ process
        will offer to do this.
* All dotfiles are placed in their respective places and managed via **[stow]**.
* This setup is geared specifically for a **[bash] shell**, so YMMV to make it
    work with other shells. I prefer [bash] since I know it and I prefer
    extending my knowledge and use thereof rather than the learning curve
    required to learn a new shell :-)
* The various dotfiles, tools etc. are broken down into _components_
    * A _component_ is a can be installed or removed at will
    * A _component_ may be more than just a set of dotfiles, and it could be
        anything, including a set of dotfiles, but also installing a favourite
        tool, doing a specific OS setup, or anything that can be done by a
        script provided for the component.
* Installing all dotfiles and components are done with the `install.sh` script
    in the root.
    * Use the `-h` command line option to get help.
    * The `-c list` command line option lists all components
* Hook to the [bash] login enviroment.
    * In order to manage the various setups, environments, etc., the install
        command will _hook_ into the [bash] login flow.
    * The _hook_ into the login flow is done by install this hook into the
        `~/.bashrc` file - see the [bash] component setup script for more.
    * bash on MacOS ??????????????
* Components have a specific structure.
    * README.Component ????
    * setup scripts.... pre, post, setup, remove, source, etc.
    * 

Notes
-----
* Available package installation options:
    * apt:
        * will be detected first and used if available - works on Debian based
            systems
        * Will be run as sudo - so needs sudo privs
        * Will use default apt settings and force `--yes` to not be asked if
            you want to install the package
    * brew:
        * Main installation option for MacOS, but can also be used for linux
        * Does not need root privs
    * Default is to select `apt` first so will work on Debian based systems,
        and then `brew`. Since `apt` is not available on MacOS
* Linuxbrew
    * This is installed as new user `home/linuxbrew`
    * How does this work on multiuser systems?
    * Need to figure out how to clean it up
________
This is my dotfiles repo. I think I should have done this a long time ago :-)

Some really good resource: https://github.com/webpro/awesome-dotfiles

This will finally replace my easyEnv project started years ago: https://github.com/fitzterra/easyEnv

Assumptions
-----------

The following assumptions are made to make things easier to get this going, but
will not be very cross platform if not given attention:

* A Debian based environment is assumed - also a fair level of MacOS support
    now....
* A bash shell is used
* For this environment, setting up the bash shell adds a hook into `~/.bashrc`
    which then sources any local bash mods. This leaves `~/.bashrc` as close as
    possible to the maintainers version and makes it easy to add updated basrc
    version if needed.
* For installing via apt-get, we assume you have sudo powers

Usage
-----

Still a work in progress, but run the `install.sh` script to install/update all
dot files.

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

<!-- links -->
[Debian]: https://www.debian.org/
[Homebrew]: https://brew.sh/
[dotfiles_repo]: https://gitlab.com/fitzterra/dotfiles
[stow]: https://www.gnu.org/software/stow/
[bash]: https://www.gnu.org/software/bash/
