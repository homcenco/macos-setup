#!/bin/bash
set +u

# Setup list global variables
SETUP=(
  'setup_ssh'
  'setup_brew'
  'setup_brew_apps'
  'setup_nodejs_env'
  'setup_laravel_env'
  'setup_iterm_terminal'
  'setup_dock_apps'
  'setup_all_configs'
)

# Coloring global variables
GREEN=$(tput setab 0)$(tput setaf 2)$(tput bold)
RED=$(tput setab 0)$(tput setaf 1)$(tput bold)
YELLOW=$(tput setab 0)$(tput setaf 3)$(tput bold)
RESET=$(tput sgr0)

# Abort session with message
function abort() {
  printf "%s\n" "$@"
  exit 1
}

# Message colored green
function success() {
  echo "${GREEN} ✓ ${1} ${RESET}"
}

# Message colored red
function error() {
  echo "${RED} ⚠ ${1} ${RESET}"
}

# Message colored yellow
function alert() {
  echo "${YELLOW} � ${1} ${RESET}"
}

# Message step colored success
function step() {
  success "${1} (${2}/${3})"
}

# Decrypt string
function decrypt() {
  echo "${1}" | openssl enc -aes-128-cbc -a -d -salt -pass pass:wtf
}

# Encrypt string
function encrypt() {
  echo "${1}" | openssl enc -aes-128-cbc -a -salt -pass pass:wtf
}

# Encrypted global variables for blocking crawlers
NAME=$(decrypt "U2FsdGVkX19ufV7bK7wLJtzk7YnHy7FBXJz/9UmuKdhIrnfCUIc2TjizNDA6qhGf")
EMAIL=$(decrypt "U2FsdGVkX1/hh/UFUc3R8ORCcubfbujTCfimr9bsrTUEkLIRIM3AFaniB+Tq0QJb")

# Setup ssh
# Don't forget to add it to your repositories
function setup_ssh() {
  step "Setting ssh keys!" "${1}" "${2}"
  ssh-keygen -f "${HOME}/.ssh/id_rsa" -t rsa -b 2048 -C "$EMAIL"
}

# Setup brew
function setup_brew() {
  step "Setting brew!"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
}

# Setup brew applications
function setup_brew_apps() {
  step "Setting brew applications!" "${1}" "${2}"
  # Browser apps
  brew install --cask google-chrome
  open -a "Google Chrome"
  # Navigation apps
  brew install --cask transmit folx
  # Background apps
  brew install --cask contexts macs-fan-control authy
  open -a "Contexts"
  open -a "Macs Fan Control"
  # Chatting apps
  brew install --cask whatsapp telegram
  # Development apps
  brew install --cask phpstorm pycharm intellij-idea visual-studio-code figma dbeaver-community postman
}

# Setup nodejs environment
function setup_nodejs_env() {
  step "Setting Nodejs environment!" "${1}" "${2}"
  alert "Installing node & npm services:"
  brew install node npm
  alert "Installing npm tools global packages:"
  npm i -g npm-check-updates autocannon
  alert "Installing npm cli global packages:"
  npm i -g @adonisjs/cli
}

# Setup laravel environment
function setup_laravel_env() {
  step "Setting Laravel environment!" "${1}" "${2}"
  alert "Installing services:"
  brew install composer dnsmasq php nginx mysql wrk mailhog phpmyadmin
}

# Setup dock applications
function setup_dock_apps() {
  step "Setting dock applications!" "${1}" "${2}"
  # Reinstall all dock app and folders icons
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/homcenco/macos-setup/main/dock/setup.sh)"
}

# Setup iterm terminal
function setup_iterm_terminal() {
  step "Setting iterm terminal!" "${1}" "${2}"
  brew install iterm2 zsh
  brew install zsh-completions zsh-autosuggestions romkatv/powerlevel10k/powerlevel10k
  echo "source /usr/local/opt/powerlevel10k/powerlevel10k.zsh-theme" >>~/.zshrc
  echo "source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" >>~/.zshrc
  # Disable .zsh_history by setting its symlink to null
  [ -f "$HOME/.zsh_history" ] && rm -f "$HOME/.zsh_history"
  ln -s "/dev/null" "$HOME/.zsh_history"
  # Copy my `.zprofile` config
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/homcenco/macos-setup/main/zprofile/setup.sh)"
  source "$HOME/.zprofile"
}

# Setup all configs
function setup_all_configs() {
  step "Setting all configs!" "${1}" "${2}"
  ### Git
  git config --global user.name "$NAME"
  git config --global user.email "$EMAIL"
  ### Global
  defaults write NSGlobalDomain "AppleShowAllExtensions" -bool "true"
  defaults write NSGlobalDomain "AppleICUForce24HourTime" -bool "true"
  defaults write NSGlobalDomain "AppleMeasurementUnits" -string "Centimeters"
  defaults write NSGlobalDomain "AppleMetricUnits" -bool "true"
  defaults write NSGlobalDomain "AppleTemperatureUnit" -string "Celsius"
  defaults write NSGlobalDomain "_HIHideMenuBar" -bool "true"
  ### Dock
  defaults write com.apple.dock "autohide" -bool "true"
  defaults write com.apple.dock "tilesize" -int "26"
  defaults write com.apple.dock "show-recents" -bool "false"
  killall Dock
  ### Finder
  defaults write com.apple.Finder "FXEnableExtensionChangeWarning" -bool "false"
  defaults write com.apple.Finder "FXEnableRemoveFromICloudDriveWarning" -bool "false"
  defaults write com.apple.Finder "WarnOnEmptyTrash" -bool "false"
  defaults write com.apple.Finder "_FXSortFoldersFirst" -bool "true"
  killall Finder
  ### Macsfancontrol
  defaults write com.crystalidea.macsfancontrol "menubarIcon" -bool "false"
  defaults write com.crystalidea.macsfancontrol "menubarTwoLines" -bool "true"
  defaults write com.crystalidea.macsfancontrol "trayFan" -bool "false"
  defaults write com.crystalidea.macsfancontrol "traySensor" -string "cpucoreavg"
  killall "Macs Fan Control"
  open -a "Macs Fan Control"
}

# Setup list all
function setup_list() {
  success "Available setup step names:"
  for value in "${SETUP[@]}"; do
    echo "    $value"
  done
}

# Start step setup from SETUP list
function setup_step() {
  [[ " ${SETUP[*]} " =~ ${1} ]] && eval "$1 1 1" || error "Error: step '$1' not found!"
}

# Start setup all
function setup_all() {
  local c="1"
  for value in "${SETUP[@]}"; do
    eval "$value $((c++)) ${#SETUP[@]}"
  done
  open -a "iTerm"
}

# Setup help
setup_help() {
  echo "Example usage:"
  echo "/bin/bash setup.sh -s setup_ssh"
  echo "Options:"
  echo "-h     Help info"
  echo "-s     Step NAME setup from list"
  echo "-l     List all setup steps"
  echo
}

#########
# SETUP #
#########

# Check if bash is available
if [ -z "${BASH_VERSION:-}" ]; then
  error "Bash is required to interpret this script."
fi

# If option is set run commands
while getopts "hs:l" option; do
  case $option in
  h) # Setup help
    setup_help
    exit
    ;;
  s) # Setup step only
    STEP1="$OPTARG"
    setup_step "$STEP1"
    exit
    ;;
  l) # List all setup functions
    setup_list
    exit
    ;;
  \?) # Invalid option
    error "Error: Invalid option"
    setup_help
    exit
    ;;
  esac
done

# If no options set run setup_all
[ $OPTIND -eq 1 ] && setup_all
