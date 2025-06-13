kill_gitkraken() { sudo kill -9 $(pidof gitkraken); }

what_is_my_ip() {
  local ip=$(curl -s 'https://api64.ipify.org?format=json' | jq -r .ip)
  echo "My IP address is: $ip"
}

zsh.update_plugins() {

}

terraform() {
  if [[ "$1" == "init" && "$2" == "-upgrade" && $# -eq 2 ]]; then
    command terraform init -upgrade && terraform providers lock -platform=linux_amd64 -platform=darwin_amd64
  else
    command terraform "$@"
  fi
}
