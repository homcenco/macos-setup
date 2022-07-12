# Zprofile setup
This sets the environment for interactive shells. It's typically a place where you "set it and forget it" type of parameters like $PATH , $PROMPT , aliases, and functions you would like to have in both login and interactive shells.

## Install .zprofile
Run this command in your terminal:
```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/homcenco/macos-setup/main/zprofile/setup.sh)"
```

### Brew
| Command         | Description                    |
|-----------------|--------------------------------|
| `bc`            | Brew Cleanup                   |
| `bd`            | Brew Doctor                    |
| `bi [PACKAGE]`  | Brew Install package name      |
| `bic [PACKAGE]` | Brew Install Cask package name |
| `bs [SERVICE]`  | Brew Services start service    |
| `bsr [SERVICE]` | Brew Services Restart service  |
| `bss [SERVICE]` | Brew Services Stop service     | 
| `bsl`           | Brew Services List             |

### Finder
| Command      | Description                                                                        |
|--------------|------------------------------------------------------------------------------------|
| `fff [NAME]` | Finder Find a File with a name                                                     |
| `frd`        | Finder Remove all .DS_Store starting from current directory and its subdirectories |
| `fsa`        | Finder Show All hidden files and folders                                           |
| `fha`        | Finder Hide All hidden files and folders                                           |

### Setup
| Command       | Description   |
|---------------|---------------|
| `s [COMMAND]` | Setup command |
| `sl`          | Setup list    |

### Update
| Command | Description                                                                   |
|---------|-------------------------------------------------------------------------------|
| `u`     | Update all global (Applications, Brew, Composer, Npm)                         |
| `ub`    | Update Brew                                                                   |
| `uc`    | Update Composer                                                               |
| `un`    | Update Npm                                                                    |
| `ud`    | Update Dock (Used to restore all dock applications if cask update removed it) |
| `uz`    | Update .Zprofile file                                                         |
| `ug`    | Update Git project                                                            |

### MacOS installer
| Command | Description                            |
|---------|----------------------------------------|
| `macos` | Create an usb macOS Monterey installer |

### Crypt
| Command            | Description                |
|--------------------|----------------------------|
| `decrypt [STRING]` | Decrypt openssl enc STRING |
| `encrypt [STRING]` | Encrypt openssl enc STRING |
