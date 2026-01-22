#!/bin/bash

# Function to print log messages
log() {
    echo "[LOG] $1"
}

# Check if dialog is installed and install it if necessary
if ! command -v dialog &> /dev/null; then
    log "dialog not found, installing it..."
    sudo pacman -S dialog --noconfirm
fi

# --- Installation Functions ---

update_system() {
    log "Updating the system..."
    sudo pacman -Syu --noconfirm
}

install_yay() {
    log "Installing yay..."
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
}

install_gnome() {
    log "Installing GNOME minimal and related packages..."
    sudo pacman -S gdm gnome-control-center gnome-session gnome-settings-daemon gnome-shell gnome-keyring nautilus gnome-characters gnome-color-manager gnome-disk-utility gnome-menus gnome-shell-extensions grilo-plugins gvfs gvfs-afc gvfs-dnssd gvfs-goa gvfs-google gvfs-gphoto2 gvfs-mtp gvfs-nfs gvfs-smb loupe sushi tracker3-miners xdg-desktop-portal-gnome xdg-user-dirs-gtk --noconfirm
}

install_alacritty() {
    log "Installing Alacritty..."
    sudo pacman -S alacritty --noconfirm
}

enable_services() {
    log "Enabling and starting services..."
    sudo systemctl enable bluetooth.service
    sudo systemctl start bluetooth.service
    sudo systemctl enable gdm.service
    sudo systemctl start gdm.service
}

configure_nvidia() {
    log "Configuring NVIDIA drivers..."
    sudo pacman -Syyuu --noconfirm
    sudo pacman -S xorg-server xorg-xinit xorg-apps --noconfirm
    sudo pacman -S nvidia nvidia-utils nvidia-settings --noconfirm
}

install_zsh() {
    log "Installing and configuring ZSH..."
    sudo pacman -S zsh zsh-completions --noconfirm
    chsh -s /bin/zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended
}

install_powerlevel10k() {
    log "Installing and configuring Powerlevel10k..."
    yay -S zsh-theme-powerlevel10k-git --noconfirm
    echo 'source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
}

install_fonts() {
    log "Installing fonts..."
    sudo pacman -S powerline-common awesome-terminal-fonts ttf-fira-code noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra --noconfirm
    yay -S ttf-meslo-nerd-font-powerlevel10k --noconfirm
}

install_gnome_tweaks() {
    log "Installing GNOME Tweaks and extensions..."
    sudo pacman -S gnome-tweaks gnome-shell-extensions gnome-browser-connector --noconfirm
}

install_nvm() {
    log "Installing NVM..."
    yay -S nvm --noconfirm
    echo 'source /usr/share/nvm/init-nvm.sh' >>~/.zshrc
}

install_gh() {
    log "Installing GH CLI..."
    sudo pacman -S github-cli --noconfirm
    gh
}

install_vscode() {
    log "Installing Visual Studio Code..."
    yay -S visual-studio-code-bin --noconfirm
}

install_chrome() {
    log "Installing Google Chrome..."
    yay -S google-chrome --noconfirm
}

install_firefox() {
    log "Installing Firefox..."
    sudo pacman -S firefox --noconfirm
}

install_brave() {
    log "Installing Brave Browser..."
    yay -S brave-bin --noconfirm
}

install_teams() {
    log "Installing Teams..."
    yay -S teams-for-linux-bin --noconfirm
}

install_skype() {
    log "Installing Skype..."
    yay -S skypeforlinux-bin --noconfirm
}

install_obsidian() {
    log "Installing Obsidian..."
    yay -S obsidian --noconfirm
}

install_discord() {
    log "Installing Discord..."
    sudo pacman -S discord --noconfirm
}

copy_dotfiles() {
    log "Copying .dotfiles..."
    shopt -s dotglob
    cp -r ~/dotfiles/dotfiles/* ~/
}

copy_wallpapers() {
    log "Copying wallpapers..."
    mkdir -p ~/Pictures
    cp -r ~/dotfiles/backgrounds/* ~/Pictures/
}

# --- Main Logic ---

HEIGHT=20
WIDTH=70
CHOICE_HEIGHT=18
BACKTITLE="Post-Installation Script"
TITLE="Application Selection"
MENU="Choose the applications you want to install:"

OPTIONS=(
    1 "Update the system" OFF
    2 "Install yay" OFF
    3 "Install GNOME minimal" OFF
    4 "Install Alacritty" OFF
    5 "Enable and start services" OFF
    6 "Configure NVIDIA drivers" OFF
    7 "Install and configure ZSH" OFF
    8 "Install and configure Powerlevel10k" OFF
    9 "Install fonts" OFF
    10 "Install GNOME Tweaks" OFF
    11 "Install NVM" OFF
    12 "Install GH CLI" OFF
    13 "Install Visual Studio Code" OFF
    14 "Install Google Chrome" OFF
    15 "Install Firefox" OFF
    16 "Install Brave Browser" OFF
    17 "Install Teams" OFF
    18 "Install Skype" OFF
    19 "Install Obsidian" OFF
    20 "Install Discord" OFF
    21 "Copy dotfiles" OFF
    22 "Copy wallpapers" OFF
)

CHOICES=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --checklist "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear

for CHOICE in $CHOICES
do
    case $CHOICE in
        1) update_system ;;
        2) install_yay ;;
        3) install_gnome ;;
        4) install_alacritty ;;
        5) enable_services ;;
        6) configure_nvidia ;;
        7) install_zsh ;;
        8) install_powerlevel10k ;;
        9) install_fonts ;;
        10) install_gnome_tweaks ;;
        11) install_nvm ;;
        12) install_gh ;;
        13) install_vscode ;;
        14) install_chrome ;;
        15) install_firefox ;;
        16) install_brave ;;
        17) install_teams ;;
        18) install_skype ;;
        19) install_obsidian ;;
        20) install_discord ;;
        21) copy_dotfiles ;;
        22) copy_wallpapers ;;
    esac
done

log ""
log "Remember to restart the system to apply all changes."
log ""
log "Log in to GitHub with the following command:"
log "gh auth login"
log ""
log "Install node.js with the following command:"
log "nvm install --lts"
log ""
log "Install https://extensions.gnome.org/extension/3733/tiling-assistant/"
log ""
log "Install https://extensions.gnome.org/extension/307/dash-to-dock/"
log ""
log "Installation and configuration complete!"
