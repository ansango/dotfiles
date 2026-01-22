#!/bin/bash

if [ -z "$BASH_VERSION" ]; then
    exec bash "$0" "$@"
fi

# Function to print log messages
log() {
    echo "[LOG] $1"
}

# Function to print error messages
error() {
    echo "[ERROR] $1"
}

# Check if dialog is installed and install it if necessary
if ! command -v dialog >/dev/null 2>&1; then
    log "dialog not found. Installing dialog..."
    sudo apt update && sudo apt install -y dialog
fi

CURRENT_USER=$(whoami)
log "Current user: $CURRENT_USER"

apt install sudo

logging() {
    echo "[LOG] Current user inside function: $CURRENT_USER"
    su -c 'echo "[LOG] Current user inside su -c: $(whoami)"' $CURRENT_USER
}

# Function to create a sudo user
create_sudo_user() {
    log "Creating sudo user (placeholder)"

    # check if log is root
    if [ "$EUID" -ne 0 ]; then
        error "Please run as root to create a sudo user."
        return 1
    fi

    username=$(dialog --inputbox "Enter the new username:" 8 40 2>&1 >/dev/tty)
    clear
    echo $username
    if [ -z "$username" ]; then
        error "Username cannot be empty."
        return 1
    fi

    apt install -y sudo

    adduser $username sudo
    CURRENT_USER=$username
    log "User $username created and added to sudo group."
}

update_and_upgrade(){
    log "Updating and upgrading with apt"
    sudo apt update -y
    sudo apt upgrade -y
}

# Function to install Gnome Desktop - Core
install_gnome_core() {
    logging
    log "Installing Gnome Desktop - Core"
    sudo apt install gnome-core -y
    sudo apt purge ifupdown -y
    log "Configuring NetworkManager..."
    sudo bash -c 'cat > /etc/NetworkManager/NetworkManager.conf' << 'EOF'
[main]
plugins=ifupdown,keyfile

[ifupdown]
managed=true
EOF
    
    log "NetworkManager configuration updated."
}

# Function to install Gnome Tweaks
install_gnome_tweaks() {
    logging
    log "Installing Gnome Tweaks"
    update_and_upgrade
    sudo apt install gnome-tweaks -y
}

# Function to update repositories sources list
update_repos() {
    logging
    log "Updating Trixie repositories"
    sudo bash -c 'cat > /etc/apt/sources.list' << 'EOF'
# Debian 13 (Trixie) - Repositorios principales con todos los componentes
deb http://deb.debian.org/debian/ trixie main contrib non-free non-free-firmware
deb-src http://deb.debian.org/debian/ trixie main contrib non-free non-free-firmware

# Actualizaciones de seguridad
deb http://security.debian.org/debian-security trixie-security main contrib non-free non-free-firmware
deb-src http://security.debian.org/debian-security trixie-security main contrib non-free non-free-firmware

# Actualizaciones menores
deb http://deb.debian.org/debian/ trixie-updates main contrib non-free non-free-firmware
deb-src http://deb.debian.org/debian/ trixie-updates main contrib non-free non-free-firmware

# Backports
deb http://deb.debian.org/debian trixie-backports main contrib non-free non-free-firmware
deb-src http://deb.debian.org/debian trixie-backports main contrib non-free non-free-firmware
EOF

    update_and_upgrade

    log "Repositories sources list updated"
}

# Function to install Nvidia drivers
install_nvidia_drivers() {
    logging
    log "Installing Nvidia drivers"
    update_and_upgrade
    sudo apt install nvidia-detect -y
    sudo apt install linux-headers-amd64 -y
    sudo apt install nvidia-driver -y
}

# Function to install Curl
install_curl() {
    logging
    log "Installing curl"
    update_and_upgrade
    sudo apt install curl -y
}

# Function to install Wget
install_wget() {
    logging
    log "Installing wget"
    update_and_upgrade
    sudo apt install wget -y
}

# Function to install Git
install_git() {
    logging
    log "Installing git"
    update_and_upgrade
    sudo apt install git -y
}

# Function to install GH CLI
install_gh_cli() {
    logging
    log "Installing gh cli"
    update_and_upgrade
    sudo apt install gh -y
}

# Function to install Nerd Fonts
install_nerd_fonts() {
    logging
    log "Installing nerd fonts"
    update_and_upgrade
    sudo apt install fonts-noto fonts-firacode fonts-powerline -y
    sudo wget -P /usr/local/share/fonts https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
    sudo wget -P /usr/local/share/fonts https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
    sudo wget -P /usr/local/share/fonts https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
    sudo wget -P /usr/local/share/fonts https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
}

# Function zsh
install_zsh() {
    logging
    log "Installing Oh My Zsh"
    update_and_upgrade
    sudo apt install zsh -y
    # add passwordless sudo for current user
    sudo usermod -aG sudo $CURRENT_USER
    # change default shell to zsh for current user
    sudo chsh -s $(which zsh) $CURRENT_USER
    sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)" "" --unattended
    git clone https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    sed -i 's/ZSH_THEME=".*"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' $HOME/.zshrc
    log "Oh My Zsh installed"

}

# Function to install NVM
install_nvm() {
    logging
    log "Installing nvm"
    update_and_upgrade
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    log "NVM installed"
    exec zsh
    nvm --version
}

# Function to install Node.js (LTS)
install_nodejs() {
    logging
    log "Installing nodejs (LTS)"
    update_and_upgrade
    nvm install --lts
}

# Function to install VSCode
install_vscode() {
    logging
    log "Installing vscode"
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
    sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/keyrings/microsoft-archive-keyring.gpg
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    update_and_upgrade
    sudo apt install code-insiders -y
}

# Function to install Firefox
install_firefox() {
    logging
    log "Installing firefox"
    update_and_upgrade
    sudo apt install firefox -y
}

# Function to install Brave Browser
install_brave() {
    logging
    log "Installing brave"
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    sudo curl -fsSLo /etc/apt/sources.list.d/brave-browser-release.sources https://brave-browser-apt-release.s3.brave.com/brave-browser.sources
    update_and_upgrade
    sudo apt install brave-browser -y
}

# Function to install VLC Media Player
install_vlc() {
    logging
    log "Installing vlc"
    update_and_upgrade
    sudo apt install vlc -y
}

# Function to install Obsidian
install_obsidian() {
    log "Installing obsidian"
    update_and_upgrade
    # install flatpak if not installed
    if ! command -v flatpak >/dev/null 2>&1; then
        log "flatpak not found. Installing flatpak..."
        sudo apt install flatpak -y
        sudo apt install gnome-software-plugin-flatpak -y
        flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
        log "flatpak installed"
        exec zsh
        flatpak install flathub md.obsidian.Obsidian -y
    fi
    flatpak install flathub md.obsidian.Obsidian -y
}

# --- MAIN LOGIC ---

HEIGHT=20
WIDTH=70
CHOICE_HEIGHT=10
BACKTITLE="Setup Script"
TITLE="Setup Options"
MENU="Choose what to setup:"

OPTIONS=(
    1 "Create a sudo user" OFF
    2 "Install Gnome Desktop - Core" OFF
    3 "Install Gnome Tweaks" OFF
    4 "Update Repositories Sources List" OFF
    5 "Install Nvidia Drivers" OFF
    6 "Install Curl" OFF
    7 "Install Wget" OFF
    8 "Install Git" OFF
    9 "Install GH CLI" OFF
    10 "Install Nerd Fonts" OFF
    11 "Install Zsh and Oh My Zsh" OFF
    12 "Install NVM" OFF
    13 "Install Node.js (LTS)" OFF
    14 "Install VSCode" OFF
    15 "Install Firefox" OFF
    16 "Install Brave Browser" OFF
    17 "Install VLC Media Player" OFF
    18 "Install Obsidian" OFF
)

CHOICES=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --checklist "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear

if [ $? -ne 0 ]; then
    log "No options selected. Exiting."
    exit 1
fi

for CHOICE in $CHOICES;
do
    case $CHOICE in
        1)
            create_sudo_user
            ;;
        2)
            install_gnome_core
            ;;
        3)
            install_gnome_tweaks
            ;;
        4)
            update_repos
            ;;
        5)
            install_nvidia_drivers
            ;;
        6)
            install_curl
            ;;
        7)
            install_wget
            ;;
        8)
            install_git
            ;;
        9)
            install_gh_cli
            ;;
        10)
            install_nerd_fonts
            ;;
        11)
            install_zsh
            ;;
        12)
            install_nvm
            ;;
        13)
            install_nodejs
            ;;
        14)
            install_vscode
            ;;
        15)
            install_firefox
            ;;
        16)
            install_brave
            ;;
        17)
            install_vlc
            ;;
        18)
            install_obsidian
            ;;
    esac
done

log ""
log "Setup completed!"
log $CHOICES
