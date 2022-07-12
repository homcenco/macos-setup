# MacOS setup
Bash script used to setup macOS (applications, configurations, environment) for web development.

### Start setup
Run this command in your terminal:
```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/homcenco/macos-setup/main/setup.sh)"
```
### Tested using:
- macOS v.12

### Options list:
- `-h` Help info
- `-s` Step NAME setup from list
- `-l` List all setup steps

### Steps list:
- `setup_ssh`
- `setup_brew`
- `setup_brew_apps`
- `setup_nodejs_env`
- `setup_laravel_env`
- `setup_iterm_terminal`
- `setup_dock_apps`
- `setup_all_configs`

### Bash step option example:
```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/homcenco/macos-setup/main/setup.sh)" -o "-s setup_ssh"
```

### Sources list:
- [dock setup documentation](https://github.com/homcenco/macos-setup/tree/main/dock)
- [zprofile setup documentation](https://github.com/homcenco/macos-setup/tree/main/zprofile)
