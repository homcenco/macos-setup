## Dock setup
Reinstall all dock apps and folders using brew dockutil.
Mostly useful in case when setting up fresh macOS or updating brew casks (brew casks update deletes icons from dock).

## Start reinstall
Run this command in your terminal:
```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/homcenco/macos-setup/main/dock/setup.sh)"
```
