#!/bin/bash

#   ----------------------------------
#       COLORING MESSAGES
#   ----------------------------------

# Color variables
GREEN=$(tput setab 0)$(tput setaf 2)$(tput bold)
RED=$(tput setab 0)$(tput setaf 1)$(tput bold)
YELLOW=$(tput setab 0)$(tput setaf 3)$(tput bold)
RESET=$(tput sgr0)

# Message colored green
function success(){
    echo "${GREEN} ✓ ${1} ${RESET}"
}

# Message colored red
function error(){
    echo "${RED} ⚠ ${1} ${RESET}"
}

# Message colored yellow
function alert(){
    echo "${YELLOW} � ${1} ${RESET}"
}

#   ----------------------------------
#       EXPORT
#   ----------------------------------

# If local/sbin directory exists - add all to export
[ -d "/usr/local/sbin" ] && export PATH="/usr/local/sbin:$PATH"

# If symfony/bin directory exists - add all to export
# Install: curl -sS https://get.symfony.com/cli/installer | bash
[ -d "$HOME/.symfony/bin" ] && export PATH="$HOME/.symfony/bin:$PATH"

# If composer/bin directory exists - add all to export
[ -d "$HOME/.composer/vendor/bin" ] && export PATH="$PATH:$HOME/.composer/vendor/bin"

# If postgresql@10/bin directory exists - add all to export
[ -d "/usr/local/opt/postgresql@10/bin" ] && export PATH="/usr/local/opt/postgresql@10/bin:$PATH"

# If avalet aliases directory exist add all it files as sources or delete
_AVALET_ALIASES_DIR="$HOME/.config/avalet/aliases"
if [[ -d "$_AVALET_ALIASES_DIR" && "$(ls -A $_AVALET_ALIASES_DIR)" ]]; then
    for file in "$_AVALET_ALIASES_DIR"/*; do
        [ -f "$file" ] && source $file || rm -f "$file"
    done
fi

#   ----------------------------------
#       NAVIGATE aliases configuration
#   ----------------------------------

# Navigate up to directory path
alias .="cd $1"

# Navigate down to previous directory
alias ..=". .."

# Navigate down to 2 previous directories
alias ...=". ../.."

# Navigate to directory home
alias ~=". $HOME"

#   ----------------------------------
#       BREW aliases configuration
#   ----------------------------------

alias bc="brew cleanup"
alias bd="brew doctor"
alias bi="brew install $@"
alias bic="brew install --cask $@"
alias bs="brew_services_action start $@"
alias bsr="brew_services_action restart $@"
alias bss="brew_services_action stop $@"
alias bsl="brew_services_list"

# Brew services action type
function brew_services_action() {
    if [[ "$2" == "all" ]]; then
        success "Action $1 all brew services!"
        brew_services_action_service $1 dnsmasq $3
        brew_services_action_service $1 nginx $3
        brew_services_action_service $1 mailhog $3
        brew_services_action_service $1 mysql $3
        brew_services_action_service $1 php $3
    elif [[ "$1" == "stop" && "$2" == "all" ]]; then
        success "Action $1 all brew services!"
        sudo brew services stop --all
        brew services stop --all
    else
        success "Action $1 brew service!"
        brew_services_action_service $@
    fi
    brew_services_list
}

# Brew services action service name
function brew_services_action_service() {
    if [[ "$2" == "dnsmasq" || "$2" == "nginx" ]]; then
        sudo brew services $@
    else
        brew services $@
    fi
}

# Brew services list services
function brew_services_list() {
    success "Listing all brew services!"
    alert "Sudo brew services list:"
    sudo brew services list

    alert "User brew services list:"
    brew services list
}

#   ----------------------------------
#       FINDER aliases configuration
#   ----------------------------------

# Finder Find a File with a name
alias fff="finder_find_file_name $1"

# Finder Remove all .DS_Store starting from current directory and its subdirectories
alias frd="find . -name '.DS_Store' -type f -delete"

# Finder Show All hidden files and folders
alias fsa="finder_show_all_files true"

# Finder Hide All hidden files and folders
alias fha="finder_show_all_files false"

# Finder Find a File with a @NAME
function finder_find_file_name() {
    find . -type f -iname '*'"$1"'*' -ls
}

# Finder Remove all .DS_Store
function finder_show_all_files() {
    defaults write com.apple.Finder AppleShowAllFiles "$1"
    killall Finder
}

#   ----------------------------------
#       SETUP aliases configuration
#   ----------------------------------

alias s="setup_bash $@"
alias sl="setup_bash -l"

function setup_bash(){
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/homcenco/macos-setup/main/setup.sh)" -o "$@"
}

#   ----------------------------------
#       UPDATE aliases configuration
#   ----------------------------------

alias u="update_global"
alias ub="update_brew"
alias uc="update_composer"
alias un="update_npm"
alias ud="update_dock"
alias uz="update_zprofile"
alias ug="update_git"

# Update all global (Applications, Brew, Composer, Npm)
function update_global(){
    update_brew
    update_composer
    update_npm
}

function update_brew(){
    success "Starting brew upgrade"
    brew upgrade && brew upgrade --cask --greedy && brew cleanup
}

function update_composer(){
    success "Starting composer upgrade"
    composer global update --quiet
}

function update_npm(){
    success "Starting npm upgrade"
    ncu -g -u
}

# Update Dock (Used to restore all dock applications if cask update removed it)
function update_dock(){
    success "Updating all dock apps & folders"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/homcenco/macos-setup/main/dock/setup.sh)"
}

# Update .Zprofile file
function update_zprofile(){
    success "Updating .Zprofile file"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/homcenco/macos-setup/main/zprofile/setup.sh)"
    source "$HOME/.zprofile"
}

# Update Git project
function update_git(){
    git pull --all
}

#   ----------------------------------
#       MacOS installer aliases
#   ----------------------------------

# Create a MacOS usb installer
alias macos="create_macos_usb_installer 'Install macOS Monterey'"

# Before starting add "Full Disk Access" in "Security & Privacy > Privacy" for your terminal.
# This fixes all errors for "usb installer autoloader generation".
function create_macos_usb_installer() {
    success "Creating macOS USB installer!"

    # Set installer variables and check installer
    INSTALLER_NAME=$1
    INSTALLER_PATH="/Applications/"$INSTALLER_NAME".app"
    INSTALLER_VOLUME_PATH="/Volumes/"$INSTALLER_NAME

    # Download if no if no installer
    if installer_app_exists = 0; then
        softwareupdate --list-full-installers
        echo
        echo "Enter version of macOS to download (ex: 12.3.1):"
        read version
        softwareupdate --fetch-full-installer --full-installer-version "$version"
    fi

    # Set USB volume variables and checking USB volume
    if usb_installer_path_exists = 0; then
        set_installer_volume;
    fi

    # Set VOLUME_PATH
    [ -z "$INSTALLER_VOLUME" ] && local VOLUME_PATH=$INSTALLER_VOLUME_PATH || local VOLUME_PATH=$INSTALLER_VOLUME

    # Setup USB installer
    if [ -d "$VOLUME_PATH" ] && [ -d "$INSTALLER_PATH" ]; then
        sudo killall Finder # Fixes: Error erasing disk error
        sudo "$INSTALLER_PATH/Contents/Resources/createinstallmedia" --volume "$VOLUME_PATH"
        sudo diskutil unmountDisk force "$INSTALLER_VOLUME_PATH"
        success "macOS USB installer was created and unmounted!"
    else
        error "macOS USB installer failed!"
    fi
}

# Check USB installer path with NAME exists
function usb_installer_path_exists(){
    if [ ! -d "$INSTALLER_VOLUME_PATH" ]; then
        error "Installer usb \"$INSTALLER_VOLUME_PATH\" not found!"
        return 0
    else
        return 1
    fi
}

# Check installer application with NAME exists
function installer_app_exists(){
    if [ ! -d "$INSTALLER_PATH" ]; then
        error "Installer app \"$INSTALLER_PATH\" not found!"
        return 0
    else
        return 1
    fi
}

# Set USB installer volumes list
function set_installer_volume(){
    local SAVEIFS=$IFS
    local IFS=$'\n'
    local VOLUMES=($(find /Volumes/*  -maxdepth 0 -type d))
    local IFS=$SAVEIFS
    select_installer_volume_from_array "${VOLUMES[@]}"
}

# Select USB installer volume from volumes list
function select_installer_volume_from_array(){
    [ $# -eq 0 ] && error "Insert USB to continue!"
    [ ! $# -eq 0 ] && alert "Type the number of your USB volume to continue:"
    select option; do # in "$@" is the default
        if [ 1 -le "$REPLY" ] && [ "$REPLY" -le $# ];
        then
        echo "You chooze #$REPLY with an USB volume \"$option\""
        INSTALLER_VOLUME=$option
        break;
        else
        error "Incorrect: Type a number between 1-$#"
        fi
    done
}

#   ----------------------------------
#       Crypt functions
#   ----------------------------------

# Decrypt string
function decrypt() {
  echo "${1}" | openssl enc -aes-128-cbc -a -d -salt -pass pass:wtf
}

# Encrypt string
function encrypt() {
  echo "${1}" | openssl enc -aes-128-cbc -a -salt -pass pass:wtf
}
