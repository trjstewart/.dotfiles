#!/usr/bin/env bash

# enable debug logging if necessary
DEBUG=false
[ "$DEBUG" == 'true' ] && set -x

# Clear the screen so we can see the script run nicely
clear

# We haven't pulled in our helpers quite yet but there are a few potential errors we need to handle
error_message_and_close() { printf '%b\n' "\e[31m$*\e[0m"; exit 1; }

# verify we're running the bootstrap script from within the .dotfiles directory
if [[ ! "${PWD##*/}" == ".dotfiles" ]]; then
  error_message_and_close "You must be in the .dotfiles folder to run the bootstrap script!"
fi

# import some helper functions to make our life a little easier
if [[ -e ./bootstrap-helpers.sh ]]; then . ./bootstrap-helpers.sh; else error_message_and_close "Couldn't load bootstrap-helpers (this should never actually happen)"; fi
