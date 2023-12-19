#!/usr/bin/env bash

# enable debug logging if necessary
DEBUG=false
[ "$DEBUG" == 'true' ] && set -x

# Clear the screen so we can see the script run nicely
clear

# Ensure the script is being run from the right directory and execute the helpers
error_message_and_close() { printf '%b\n\n' "\e[31m$*\e[0m"; exit 1; }
if [[ ! "${PWD##*/}" == ".dotfiles" ]]; then error_message_and_close "You must be in the .dotfiles folder to run the bootstrap script!"; fi
if [[ -e ./bootstrap-helpers.sh ]]; then . ./bootstrap-helpers.sh; else error_message_and_close "Couldn't load bootstrap-helpers (this should never actually happen)"; fi


print_message "Welcome to bootstrapper $USER! Let's get started setting up your system... 🤔"
verify_location
request_sudo_access
mkdir -p $LOG_DIRECTORY

# ---------------------------------------------------------------------------------------------------------------------
# Bootstrapping that's specific to each platform
# ---------------------------------------------------------------------------------------------------------------------
if is_mac; then
  print_message "It looks like you're trying to setup a mac, let's get brewing!"
fi

if is_linux; then
  print_message_no_new_line "It looks like you're trying to setup linux, but which flavour?"

  if is_linux_ubuntu; then
    print_info " It's Ubuntu, let's apt-get going!"

    print_info "\nInstall System Updates"
    print_message_fixed_width " >> Updating package information..."
    apt_get_update
    print_message_fixed_width " >> Updating existing packages..."
    sudo apt-get dist-upgrade -y > "$LOG_PREFIX-apt-get-dist-upgrade.log" 2>&1; print_last_command_success_or_failure

    print_info "\nInstall Required Packages from APT"
    print_message_fixed_width " >> Installing prerequisites to use Brew..."
    sudo apt-get install -y build-essential procps curl file git > "$LOG_PREFIX-apt-get-install.log" 2>&1; print_last_command_success_or_failure
    print_message_fixed_width " >> Cleaning up unused packages..."
    sudo apt-get autoremove -y > "$LOG_PREFIX-apt-get-autoremove.log" 2>&1; print_last_command_success_or_failure
    print_message_fixed_width " >> Cleaning up unused cache files..."
    sudo apt-get autoclean -y > "$LOG_PREFIX-apt-get-autoclean.log" 2>&1; print_last_command_success_or_failure
  fi
fi

# ---------------------------------------------------------------------------------------------------------------------
# Bootstrapping that's common to all platforms
# ---------------------------------------------------------------------------------------------------------------------
print_info "\nGet Setup Using Brew 🍺"
install_brew
print_message_fixed_width " >> Installing everyting in the Brewfile..."
brew bundle > "$LOG_PREFIX-brew-bundle.log" 2>&1; print_last_command_success_or_failure

print_info "\nSetting up Git Config"
create_gitconfig "$(get_email)"

print_info "\nLink dotfiles with stow"
unpack_with_stow

print_info "\nSetup Zsh Shell"
install_zsh
install_oh_my_zsh
switch_default_shell_to_zsh
print_message_fixed_width " >> Installing zsh auto-suggestions..."
brew install zsh-autosuggestions > "$LOG_PREFIX-brew-install-zsh-autosuggestions.log" 2>&1
print_last_command_success_or_failure
print_message_fixed_width " >> Installing zsh syntax highlighting..."
brew install zsh-syntax-highlighting > "$LOG_PREFIX-brew-install-zsh-syntax-highlighting.log" 2>&1
print_last_command_success_or_failure

# ---------------------------------------------------------------------------------------------------------------------
# Job's Done!
# ---------------------------------------------------------------------------------------------------------------------
print_success "\nBootstrap Complete! 🎉\n"

# disable debug logging if set
[ "$DEBUG" == 'true' ] && set +x
