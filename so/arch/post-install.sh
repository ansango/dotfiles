#!/bin/bash

# Function to print log messages
log() {
    echo "[LOG] $1"
}

# Update the system
read -p "Do you want to update the system? (y/N) " update_system
if [[ $update_system =~ ^[Yy]$ ]]; then
    log "Updating the system..."
    sudo pacman -Syu --noconfirm
fi

# Install yay
read -p "Do you want to install yay? (y/N) " install_yay
if [[ $install_yay =~ ^[Yy]$ ]]; then
    log "Installing yay..."
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
fi

# Install GNOME minimal and related packages
read -p "Do you want to install GNOME minimal and related packages? (y/N) " install_gnome
if [[ $install_gnome =~ ^[Yy]$ ]]; then
    log "Installing GNOME minimal and related packages..."
    sudo pacman -S gdm gnome-control-center gnome-session gnome-settings-daemon gnome-shell gnome-keyring nautilus gnome-characters gnome-color-manager gnome-disk-utility gnome-menus gnome-shell-extensions grilo-plugins gvfs gvfs-afc gvfs-dnssd gvfs-goa gvfs-google gvfs-gphoto2 gvfs-mtp gvfs-nfs gvfs-smb loupe sushi tracker3-miners xdg-desktop-portal-gnome xdg-user-dirs-gtk --noconfirm
fi

# Install Alacritty
read -p "Do you want to install Alacritty? (y/N) " install_alacritty
if [[ $install_alacritty =~ ^[Yy]$ ]]; then
    log "Installing Alacritty..."
    sudo pacman -S alacritty --noconfirm
fi

# Enable and start services
read -p "Do you want to enable and start Bluetooth and GDM services? (y/N) " enable_services
if [[ $enable_services =~ ^[Yy]$ ]]; then
    log "Enabling and starting services..."
    sudo systemctl enable bluetooth.service
    sudo systemctl start bluetooth.service
    sudo systemctl enable gdm.service
    sudo systemctl start gdm.service
fi

# Configure NVIDIA drivers
read -p "Do you want to configure NVIDIA drivers? (y/N) " configure_nvidia
if [[ $configure_nvidia =~ ^[Yy]$ ]]; then
    log "Configuring NVIDIA drivers..."
    #echo "install i915 /bin/false" | sudo tee --append /etc/modprobe.d/blacklist.conf
    #cat /etc/modprobe.d/blacklist.conf
    sudo pacman -Syyuu --noconfirm
    sudo pacman -S xorg-server xorg-xinit xorg-apps --noconfirm
    sudo pacman -S nvidia nvidia-utils nvidia-settings --noconfirm
    #cat /usr/lib/modprobe.d/nvidia-utils.conf
fi

# Install and configure ZSH
read -p "Do you want to install and configure ZSH? (y/N) " install_zsh
if [[ $install_zsh =~ ^[Yy]$ ]]; then
    log "Installing and configuring ZSH..."
    sudo pacman -S zsh zsh-completions --noconfirm
    chsh -s /bin/zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended
fi

# Install and configure Powerlevel10k
read -p "Do you want to install and configure Powerlevel10k? (y/N) " install_powerlevel10k
if [[ $install_powerlevel10k =~ ^[Yy]$ ]]; then
    log "Installing and configuring Powerlevel10k..."
    yay -S zsh-theme-powerlevel10k-git --noconfirm
    echo 'source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
fi

# Install fonts
read -p "Do you want to install fonts? (y/N) " install_fonts
if [[ $install_fonts =~ ^[Yy]$ ]]; then
    log "Installing fonts..."
    sudo pacman -S powerline-common awesome-terminal-fonts ttf-fira-code noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra --noconfirm
    yay -S ttf-meslo-nerd-font-powerlevel10k --noconfirm
fi

# Install GNOME Tweaks and extensions
read -p "Do you want to install GNOME Tweaks and extensions? (y/N) " install_gnome_tweaks
if [[ $install_gnome_tweaks =~ ^[Yy]$ ]]; then
    log "Installing GNOME Tweaks and extensions..."
    sudo pacman -S gnome-tweaks gnome-shell-extensions gnome-browser-connector --noconfirm
fi

# Ask about installing NVM
read -p "Do you want to install NVM? (y/N) " install_nvm
if [[ $install_nvm =~ ^[Yy]$ ]]; then
    log "Installing NVM..."
    yay -S nvm --noconfirm
    echo 'source /usr/share/nvm/init-nvm.sh' >>~/.zshrc
fi

# Ask about installing GH CLI
read -p "Do you want to install GH CLI? (y/N) " install_gh
if [[ $install_gh =~ ^[Yy]$ ]]; then
    log "Installing GH CLI..."
    sudo pacman -S github-cli --noconfirm
fi

# Ask about installing Visual Studio Code
read -p "Do you want to install Visual Studio Code? (y/N) " install_vscode
if [[ $install_vscode =~ ^[Yy]$ ]]; then
    log "Installing Visual Studio Code..."
    yay -S visual-studio-code-bin --noconfirm
fi

# Ask about installing Google Chrome
read -p "Do you want to install Google Chrome? (y/N) " install_chrome
if [[ $install_chrome =~ ^[Yy]$ ]]; then
    log "Installing Google Chrome..."
    yay -S google-chrome --noconfirm
fi

# Ask about installing Firefox
read -p "Do you want to install Firefox? (y/N) " install_firefox
if [[ $install_firefox =~ ^[Yy]$ ]]; then
    log "Installing Firefox..."
    sudo pacman -S firefox --noconfirm
fi

# Ask about installing Brave Browser
read -p "Do you want to install Brave Browser? (y/N) " install_brave
if [[ $install_brave =~ ^[Yy]$ ]]; then
    log "Installing Brave Browser..."
    yay -S brave-bin --noconfirm
fi

# Ask about installing Teams
read -p "Do you want to install Teams? (y/N) " install_teams
if [[ $install_teams =~ ^[Yy]$ ]]; then
    log "Installing Teams..."
    yay -S teams-for-linux-bin --noconfirm
fi

# Ask about installing Skype
read -p "Do you want to install Skype? (y/N) " install_skype
if [[ $install_skype =~ ^[Yy]$ ]]; then
    log "Installing Skype..."
    yay -S skypeforlinux-bin --noconfirm
fi

# Ask about installing Obsidian
read -p "Do you want to install Obsidian? (y/N) " install_obsidian
if [[ $install_obsidian =~ ^[Yy]$ ]]; then
    log "Installing Obsidian..."
    yay -S obsidian --noconfirm
fi

# Ask about installing Discord
read -p "Do you want to install Discord? (y/N) " install_discord
if [[ $install_discord =~ ^[Yy]$ ]]; then
    log "Installing Discord..."
    sudo pacman -S discord --noconfirm
fi

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
