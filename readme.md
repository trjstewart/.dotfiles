# .dotfiles

Managed with [chezmoi](https://www.chezmoi.io/). This repo _is_ the chezmoi
source directory, cloned to `~/.dotfiles`.

## Bootstrapping a clean system

1. Install chezmoi (e.g. `sh -c "$(curl -fsLS get.chezmoi.io)"`).
2. Clone the repo and apply, in a single command:

   ```sh
   chezmoi init --apply --source="$HOME/.dotfiles" https://github.com/trjstewart/.dotfiles.git
   ```

   chezmoi clones this repo into `~/.dotfiles`, prompts for the values in
   `.chezmoi.yaml.tmpl`, writes `~/.config/chezmoi/chezmoi.yaml` (which persists
   `sourceDir`, so later `chezmoi` commands no longer need `--source`), then
   applies everything.

Day-to-day: `chezmoi add ~/.somefile` to track a file, edit under `~/.dotfiles`,
`chezmoi apply` to push changes to home, then commit + push from `~/.dotfiles`.

## Setting up on Windows

### Windows Terminal Settings

1. Launch [Windows Terminal](https://apps.microsoft.com/detail/9n0dx20hk701?hl=en-US&gl=AU).
1. Open the **Settings** panel (`Ctrl + ,`).
1. Copy the contents from [windows-terminal-settings.json](./windows-terminal-settings.json) over the top of the settings.json file.

### Ensure Latest Ubuntu LTS Version for WSL

> [!NOTE]
> This assumes you already have WSL 2 installed, updated, etc. If you don't, follow the [setup guide](https://learn.microsoft.com/en-us/windows/wsl/install) from Microsoft.

The [Microsoft Store](https://apps.microsoft.com/detail/9pdxgncfsczv?hl=en-US&gl=AU) doesn't always have the latest version of Ubuntu available if a new LTS version has recently been released. To ensure you're always installing the latest version, download the latest LTS [straight from Canonical](https://ubuntu.com/download/wsl), then run `wsl --install --from-file <YOUR_DOWNLOADED_FILE> --name Ubuntu`.

testing
