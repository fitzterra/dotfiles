#!/usr/bin/env bash
# Makes sure the ipython config dir exists before we create the config file
# link
echo "Making sure IPython config dir for the default profile exists..."
mkdir -pv ~/.ipython/profile_default
