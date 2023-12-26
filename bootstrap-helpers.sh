#!/usr/bin/env bash

START_TIME=$(date +%s)
LOG_DIRECTORY="logs"
LOG_PREFIX="$LOG_DIRECTORY/$START_TIME"

# text formatting and colours - https://misc.flogisoft.com/bash/tip_colors_and_formatting
format_set_bright='\e[1m'
format_set_dim='\e[2m'
format_set_underlined='\e[4m'
format_set_blink='\e[5m'
format_set_reverse='\e[7m'
format_set_hidden='\e[8m'
format_reset_all='\e[0m'
format_reset_bright='\e[21m'
format_reset_dim='\e[22m'
format_reset_underlined='\e[24m'
format_reset_blink='\e[25m'
format_reset_reverse='\e[27m'
format_reset_hidden='\e[28m'
foreground_default='\e[39m'
foreground_black='\e[30m'
foreground_red='\e[31m'
foreground_green='\e[32m'
foreground_yellow='\e[33m'
foreground_blue='\e[34m'
foreground_magenta='\e[35m'
foreground_cyan='\e[36m'
foreground_light_grey='\e[37m'
foreground_dark_grey='\e[90m'
foreground_light_red='\e[91m'
foreground_light_green='\e[92m'
foreground_light_yellow='\e[93m'
foreground_light_blue='\e[94m'
foreground_light_magenta='\e[95m'
foreground_light_cyan='\e[96m'
foreground_white='\e[97m'
background_default='\e[49m'
background_black='\e[40m'
background_red='\e[41m'
background_green='\e[42m'
background_yellow='\e[43m'
background_blue='\e[44m'
background_magenta='\e[45m'
background_cyan='\e[46m'
background_light_grey='\e[47m'
background_dark_grey='\e[100m'
background_light_red='\e[101m'
background_light_green='\e[102m'
background_light_yellow='\e[103m'
background_light_blue='\e[104m'
background_light_magenta='\e[105m'
background_light_cyan='\e[106m'
background_white='\e[107m'

print_with_new_line() { printf '%b\n' "$*"; }
print_with_no_new_line() { printf '%b' "$*"; }
print_with_fixed_width() { printf '%-75b' "$*"; }

print_success() { print_with_new_line "${foreground_green}$*${format_reset_all}"; }
print_message() { print_with_new_line "${foreground_cyan}$*${format_reset_all}"; }
print_info() { print_with_new_line "${foreground_magenta}$*${format_reset_all}"; }
print_warning() { print_with_new_line "${foreground_yellow}$*${format_reset_all}"; }
print_error() { print_with_new_line "${foreground_red}$*${format_reset_all}"; }

print_success_no_new_line() { print_with_no_new_line "${foreground_green}$*${format_reset_all}"; }
print_message_no_new_line() { print_with_no_new_line "${foreground_cyan}$*${format_reset_all}"; }
print_info_no_new_line() { print_with_no_new_line "${foreground_magenta}$*${format_reset_all}"; }
print_warning_no_new_line() { print_with_no_new_line "${foreground_yellow}$*${format_reset_all}"; }
print_error_no_new_line() { print_with_no_new_line "${foreground_red}$*${format_reset_all}"; }

print_success_fixed_width() { print_with_fixed_width "${foreground_green}$*${format_reset_all}"; }
print_message_fixed_width() { print_with_fixed_width "${foreground_cyan}$*${format_reset_all}"; }
print_info_fixed_width() { print_with_fixed_width "${foreground_magenta}$*${format_reset_all}"; }
print_warning_fixed_width() { print_with_fixed_width "${foreground_yellow}$*${format_reset_all}"; }
print_error_fixed_width() { print_with_fixed_width "${foreground_red}$*${format_reset_all}"; }

print_error_and_exit() { print_error "$*\n"; exit 1; }
request_sudo_access() { if ! sudo -v; then print_error_and_exit "You must have sudo access to run this script!"; fi }
silent() { "$@" > /dev/null  2>&1; }
get_system_os() { uname -s; }
is_mac() { if [[ "$(get_system_os)" == "Darwin" ]]; then return 0; else return 1; fi }
is_linux() { if [[ "$(get_system_os)" == "Linux" ]]; then return 0; else return 1; fi }
is_linux_ubuntu() { if [[ "$(lsb_release -i | tr -d '\t' | grep -Po '(?<=:).*')" == "Ubuntu" ]]; then return 0; else return 1; fi }
is_wsl() { if grep -q microsoft /proc/version; then return 0; else return 1; fi }

verify_location() {
  if [[ ! "${PWD##*/}" == ".dotfiles" ]]; then print_error_and_exit "You must be in the .dotfiles folder to run the bootstrap script!"; fi
  if [[ ! $(dirname "$PWD") == "$HOME" ]]; then print_error_and_exit "The .dotfiles folder must be located inside your home directory!"; fi
}

print_last_command_success_or_failure() {
  LAST_STATUS_CODE=$?

  if [ $# -eq 0 ]; then
    # if there is no arguments, then we're just checking the last command's exit code
    if [ $LAST_STATUS_CODE -eq 0 ]; then print_success "✔"; else print_error "✗"; fi
  else
    # if there are arguments, then we're checking the last command's exit code against any of the arguments
    for SUCCESS_STATUS in "$@"; do
      if [ $LAST_STATUS_CODE -eq "$SUCCESS_STATUS" ]; then print_success "✔"; return; fi
    done

    # if we get here, then we didn't find a matching exit code
    print_error "✗"
  fi
}

apt_get_update() {
  UNIX_TIME=$(date +%s)
  LAST_UPDATED=$(stat --format="%X" /var/cache/apt/pkgcache.bin)
  TIME_DIFF=$((UNIX_TIME - LAST_UPDATED))

  if [[ "${TIME_DIFF}" -gt 3600 ]]; then
    sudo apt-get update -y > "$LOG_PREFIX-apt-get-update.log" 2>&1
    print_last_command_success_or_failure
  else
    print_success "✔"
    print_warning "    ! apt was already updated in the past hour"
  fi
}

install_brew() { # TODO: This could do with some improvement. It definitely doesn't handle errors well.
  print_message_fixed_width " >> Installing Brew..."
  if ! silent command -v "brew"; then
    export CI=1
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" > "$LOG_PREFIX-brew-install.log" 2>&1
    print_last_command_success_or_failure
    unset CI

    # post install steps
    (echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> /home/elliot/.bashrc
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  else
    brew update > "$LOG_PREFIX-brew-update.log" 2>&1
    print_last_command_success_or_failure
    print_warning "    ! Brew is already installed, updated instead"
  fi
}

determine_personal_or_work() {
  if is_wsl; then
    DOMAIN=$(powershell.exe '(Get-WmiObject win32_computersystem).Domain' | tr -d '\r')
    case $DOMAIN in
      ndia.gov.au)
        echo "work_ndia"
        return 0
        ;;
      ndis.gov.au)
        echo "work_ndia"
        return 0
        ;;
    esac
  fi

  echo "personal"
  return 0
}

get_email() {
  case $(determine_personal_or_work) in
    work_ndia)
      echo "tylor.stewart@ndis.gov.au"
      return 0
      ;;
    *)
      echo "trjstewart@gmail.com"
      return 0
      ;;
  esac
}

create_gitconfig() {
  GIT_CONFIG_PATH="./git"
  GIT_CONFIG_TEMPLATE_DIRECTORY="templates"
  GIT_CONFIG_TEMPLATE_FILE=".gitconfig"

  if [[ ! -f "$GIT_CONFIG_TEMPLATE_DIRECTORY/$GIT_CONFIG_TEMPLATE_FILE" ]]; then print_error_and_exit "Couldn't find the .gitconfig template file!"; fi
  if [ $# -eq 0 ]; then print_error_and_exit "No argument supplied. You must supply your email address!"; fi
  if [ -z "$1" ]; then print_error_and_exit "Invalid argument supplied. You must supply your email address!"; fi

  print_message_fixed_width " >> Copying template .gitconfig file..."
  cp "$GIT_CONFIG_TEMPLATE_DIRECTORY/$GIT_CONFIG_TEMPLATE_FILE" "$GIT_CONFIG_PATH/.gitconfig"
  print_last_command_success_or_failure

  print_message_fixed_width " >> Replacing email template value in .gitconfig file..."
  if is_mac; then
    silent sed -i "" -e "s/__EMAIL_ADDRESS__/$1/" "$GIT_CONFIG_PATH/.gitconfig"
  else
    silent sed -i -e "s/__EMAIL_ADDRESS__/$1/" "$GIT_CONFIG_PATH/.gitconfig"
  fi
  print_last_command_success_or_failure
}

unpack_with_stow() {
  for point in $(echo */); do
    if [[ "$point" == "$LOG_DIRECTORY/" || "$point" == "templates/" ]]; then continue; fi
    print_message_fixed_width " >> Linking ${point/\//}..."
    silent stow $point # for some reason logfile creation fails if we try to direct output to a file
    print_last_command_success_or_failure
  done
}

install_zsh() {
  print_message_fixed_width " >> Installing Zsh..."

  if ! silent command -v "zsh"; then
    brew install zsh > "$LOG_PREFIX-brew-install-zsh.log" 2>&1
    print_last_command_success_or_failure
  else
    print_success "✔"
    print_warning "    ! ZSH is already installed"
  fi
}

install_oh_my_zsh() {
  print_message_fixed_width " >> Installing Oh My Zsh..."
  
  if ! [[ -e ~/.oh-my-zsh ]]; then
    /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended > "$LOG_PREFIX-oh-my-zsh-install.log" 2>&1
    print_last_command_success_or_failure
  else
    print_success "✔"
    print_warning "    ! Oh My Zsh is already installed"
  fi
}

switch_default_shell_to_zsh() {
  print_message_fixed_width " >> Switching default shell to Zsh..."

  ERRORS=()
  MESSAGES=()

  if ! silent command -v "zsh"; then ERRORS+=("    ! Unable to find Zsh command"); fi
  ZSH_SHELL_PATH="$(which zsh)"

  if ! silent grep "$ZSH_SHELL_PATH" < /etc/shells; then
    echo "$ZSH_SHELL_PATH" | silent sudo tee -a /etc/shells
    if [ $? -eq 1 ]; then ERRORS+=("    ! Unable to add Zsh shell path to /etc/shells"); fi
  else
    MESSAGES+=("    ! Zsh shell path is already in /etc/shells")
  fi

  if ((${#ERRORS[@]})); then
    print_error "✗"
    for ERROR in "${ERRORS[@]}"; do print_error "$ERROR"; done
    exit 1
  fi

  if ! [[ "$SHELL" == *"zsh" ]]; then
    sudo chsh -s $(which zsh) $USER > "$LOG_PREFIX-chsh.log" 2>&1
    print_last_command_success_or_failure
  else
    print_success "✔"
    print_warning "    ! Default shell is already ZSH"
  fi

  if ((${#MESSAGES[@]})); then
    for MESSAGE in "${MESSAGES[@]}"; do print_warning "$MESSAGE"; done
  fi
}

[[ "${BASH_SOURCE[0]}" != "${0}" ]] && print_info ">>> ${BASH_SOURCE[0]#"./"} has been sourced...\n"
