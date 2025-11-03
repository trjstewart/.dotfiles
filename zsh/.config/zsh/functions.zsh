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

asdf.update_everything() {
  echo "Updating everything to do with asdf!\n"

  echo "Updating asdf itself..."
  if command -v brew &> /dev/null && [[ "$(where asdf)" == *"brew"* ]]; then
    if ! brew outdated asdf &> /dev/null; then
      current_version=$(asdf --version | awk '{print $3}')
      brew upgrade asdf &> /dev/null
      new_version=$(asdf --version | awk '{print $3}')
      echo "  asdf updated from version $current_version to $new_version!\n"
    else
      echo "  asdf is already version $(asdf --version | awk '{print $3}'). No update needed.\n"
    fi
  else
    echo "  Please update asdf manually (not installed via Homebrew).\n"
  fi

  echo "Updating asdf plugins...\n"
  asdf plugin update --all &> /dev/null

  echo "Updating all installed tool versions..."
  pushd ~ &> /dev/null # Move to home directory to find .tool-versions
  installed_plugins=($(asdf plugin list))
  for plugin in $installed_plugins; do
    current_version=$(asdf current $plugin --no-header | awk '{print $2}')
    latest_version=$(asdf latest $plugin)
    if [[ "$current_version" != "$latest_version" ]]; then
      echo "  $plugin is currently at version $current_version. Updating to $latest_version..."
      asdf install $plugin $latest_version &> /dev/null
      asdf set $plugin $latest_version &> /dev/null
    else
      echo "  $plugin is already at the latest version ($current_version). No update needed."
    fi
  done
  popd &> /dev/null # Return to previous directory now that we're done
  echo "\nEverything is up to date!"
}