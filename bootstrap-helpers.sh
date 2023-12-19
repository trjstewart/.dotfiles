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

print_with_newline() { printf '%b\n' "$*"; }
print_with_fixed_width() { printf '%-100s' "$*"; }

print_success() { print_with_newline "${foreground_green}$*${format_reset_all}"; }
print_message() { print_with_newline "${foreground_cyan}$*${format_reset_all}"; }
print_info() { print_with_newline "${foreground_magenta}$*${format_reset_all}"; }
print_warning() { print_with_newline "${foreground_yellow}$*${format_reset_all}"; }
print_error() { print_with_newline "${foreground_red}$*${format_reset_all}"; }

[[ "${BASH_SOURCE[0]}" != "${0}" ]] && print_info ">>> ${BASH_SOURCE[0]#"./"} has been sourced..."
