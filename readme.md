# .dotfiles

I use [chezmoi](https://www.chezmoi.io/) to manage my dotfiles and system bootstrap. I've tried to keep things as generic as possible so that you're able to use my configuration too (and so I can use it at work).

## Prerequisites

### Windows

#### Terminal Settings

1. Launch [Windows Terminal](https://apps.microsoft.com/detail/9n0dx20hk701?hl=en-US&gl=AU).
1. Open the **Settings** panel (`Ctrl + ,`) and click `Open JSON file` in the bottom left of the window.
1. Copy the contents from [windows-terminal-settings.json](./windows-terminal-settings.json) over the top of the settings.json file.

#### Ensure Latest Ubuntu LTS Version for WSL

> [!NOTE]
> This assumes you already have WSL 2 installed, updated, etc. If you don't, follow the [setup guide](https://learn.microsoft.com/en-us/windows/wsl/install) from Microsoft.

The [Microsoft Store](https://apps.microsoft.com/detail/9pdxgncfsczv?hl=en-US&gl=AU) doesn't always have the latest version of Ubuntu available if a new LTS version has recently been released. To ensure you're always installing the latest version, download the latest LTS [straight from Canonical](https://ubuntu.com/download/wsl), then run `wsl --install --from-file <YOUR_DOWNLOADED_FILE> --name Ubuntu`.

## chezmoi

### Installing and Initialising

[chezmoi](https://www.chezmoi.io) provides a handy helper script to get us started. The one-liner below installs chezmoi to `./bin` and initialises my system bootstrap and dotfiles. Technically this can be run from anywhere, but run it from your home directory.

```sh
sh -c "$(curl -fsLS https://get.chezmoi.io)" -- init --apply --source="~/.dotfiles" trjstewart/.dotfiles
```

Temporary script that sources the working feature branch.

```sh
sh -c "$(curl -fsLS https://get.chezmoi.io)" -- init --apply --source="~/.dotfiles" --branch feature/chezmoi trjstewart/.dotfiles
```

### Day to day use
