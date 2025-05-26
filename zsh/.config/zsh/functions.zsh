kill_gitkraken() { sudo kill -9 $(pidof gitkraken); }

what_is_my_ip() {
  local ip=$(curl -s 'https://api64.ipify.org?format=json' | jq -r .ip)
  echo "My IP address is: $ip"
}

zsh.update_plugins() {

}
