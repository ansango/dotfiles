#!/bin/bash

# Función para imprimir mensajes de log
log() {
    echo "[LOG] $1"
}

# Actualizar el sistema
read -p "¿Quieres actualizar el sistema? (y/N) " update_system
if [[ $update_system =~ ^[Yy]$ ]]; then
    log "Actualizando el sistema..."
    sudo pacman -Syu --noconfirm
fi

# Instalar yay
read -p "¿Quieres instalar yay? (y/N) " install_yay
if [[ $install_yay =~ ^[Yy]$ ]]; then
    log "Instalando yay..."
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
fi

# Instalar GNOME minimal y paquetes relacionados
read -p "¿Quieres instalar GNOME minimal y paquetes relacionados? (y/N) " install_gnome
if [[ $install_gnome =~ ^[Yy]$ ]]; then
    log "Instalando GNOME minimal y paquetes relacionados..."
    sudo pacman -S gdm gnome-control-center gnome-session gnome-settings-daemon gnome-shell gnome-keyring nautilus gnome-characters gnome-color-manager gnome-disk-utility gnome-menus gnome-shell-extensions grilo-plugins gvfs gvfs-afc gvfs-dnssd gvfs-goa gvfs-google gvfs-gphoto2 gvfs-mtp gvfs-nfs gvfs-smb loupe sushi tracker3-miners xdg-desktop-portal-gnome xdg-user-dirs-gtk --noconfirm
fi

# Instalar Alacritty
read -p "¿Quieres instalar Alacritty? (y/N) " install_alacritty
if [[ $install_alacritty =~ ^[Yy]$ ]]; then
    log "Instalando Alacritty..."
    sudo pacman -S alacritty --noconfirm
fi

# Habilitar y activar servicios
read -p "¿Quieres habilitar y activar servicios Bluetooth y GDM? (y/N) " enable_services
if [[ $enable_services =~ ^[Yy]$ ]]; then
    log "Habilitando y activando servicios..."
    sudo systemctl enable bluetooth.service
    sudo systemctl start bluetooth.service
    sudo systemctl enable gdm.service
    sudo systemctl start gdm.service
fi

# Configurar drivers NVIDIA
read -p "¿Quieres configurar drivers NVIDIA? (y/N) " configure_nvidia
if [[ $configure_nvidia =~ ^[Yy]$ ]]; then
    log "Configurando drivers NVIDIA..."
    echo "install i915 /bin/false" | sudo tee --append /etc/modprobe.d/blacklist.conf
    cat /etc/modprobe.d/blacklist.conf
    sudo pacman -Syyuu --noconfirm
    sudo pacman -S xorg-server xorg-xinit xorg-apps --noconfirm
    sudo pacman -S nvidia nvidia-utils nvidia-settings --noconfirm
    cat /usr/lib/modprobe.d/nvidia-utils.conf
fi

# Instalar y configurar ZSH
read -p "¿Quieres instalar y configurar ZSH? (y/N) " install_zsh
if [[ $install_zsh =~ ^[Yy]$ ]]; then
    log "Instalando y configurando ZSH..."
    sudo pacman -S zsh zsh-completions --noconfirm
    chsh -s /bin/zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended
fi

# Instalar y configurar Powerlevel10k
read -p "¿Quieres instalar y configurar Powerlevel10k? (y/N) " install_powerlevel10k
if [[ $install_powerlevel10k =~ ^[Yy]$ ]]; then
    log "Instalando y configurando Powerlevel10k..."
    yay -S zsh-theme-powerlevel10k-git --noconfirm
    echo 'source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
fi

# Instalar fuentes
read -p "¿Quieres instalar fuentes? (y/N) " install_fonts
if [[ $install_fonts =~ ^[Yy]$ ]]; then
    log "Instalando fuentes..."
    sudo pacman -S powerline-common awesome-terminal-fonts ttf-fira-code noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra --noconfirm
    yay -S ttf-meslo-nerd-font-powerlevel10k --noconfirm
fi

# Instalar GNOME Tweaks y extensiones
read -p "¿Quieres instalar GNOME Tweaks y extensiones? (y/N) " install_gnome_tweaks
if [[ $install_gnome_tweaks =~ ^[Yy]$ ]]; then
    log "Instalando GNOME Tweaks y extensiones..."
    sudo pacman -S gnome-tweaks gnome-shell-extensions --noconfirm
fi

# Preguntar sobre la instalación de NVM
read -p "¿Quieres instalar NVM? (y/N) " install_nvm
if [[ $install_nvm =~ ^[Yy]$ ]]; then
    log "Instalando NVM..."
    yay -S nvm --noconfirm
    echo 'source /usr/share/nvm/init-nvm.sh' >>~/.zshrc
fi

# Preguntar sobre la instalación de GH CLI
read -p "¿Quieres instalar GH CLI? (y/N) " install_gh
if [[ $install_gh =~ ^[Yy]$ ]]; then
    log "Instalando GH CLI..."
    sudo pacman -S github-cli --noconfirm
fi

# Preguntar sobre la instalación de Visual Studio Code
read -p "¿Quieres instalar Visual Studio Code? (y/N) " install_vscode
if [[ $install_vscode =~ ^[Yy]$ ]]; then
    log "Instalando Visual Studio Code..."
    yay -S visual-studio-code-bin --noconfirm
fi

# Preguntar sobre la instalación de Google Chrome
read -p "¿Quieres instalar Google Chrome? (y/N) " install_chrome
if [[ $install_chrome =~ ^[Yy]$ ]]; then
    log "Instalando Google Chrome..."
    yay -S google-chrome --noconfirm
fi

# Preguntar sobre la instalación de Firefox
read -p "¿Quieres instalar Firefox? (y/N) " install_firefox
if [[ $install_firefox =~ ^[Yy]$ ]]; then
    log "Instalando Firefox..."
    sudo pacman -S firefox --noconfirm
fi

# Preguntar sobre la instalación de Teams
read -p "¿Quieres instalar Teams? (y/N) " install_teams
if [[ $install_teams =~ ^[Yy]$ ]]; then
    log "Instalando Teams..."
    yay -S teams-for-linux-bin --noconfirm
fi

# Preguntar sobre la instalación de Skype
read -p "¿Quieres instalar Skype? (y/N) " install_skype
if [[ $install_skype =~ ^[Yy]$ ]]; then
    log "Instalando Skype..."
    yay -S skypeforlinux-bin --noconfirm
fi

# Preguntar sobre la instalación de Obsidian
read -p "¿Quieres instalar Obsidian? (y/N) " install_obsidian
if [[ $install_obsidian =~ ^[Yy]$ ]]; then
    log "Instalando Obsidian..."
    yay -S obsidian --noconfirm
fi

# Preguntar sobre la instalación de Discord
read -p "¿Quieres instalar Discord? (y/N) " install_discord
if [[ $install_discord =~ ^[Yy]$ ]]; then
    log "Instalando Discord..."
    sudo pacman -S discord --noconfirm
fi

# Copiar archivos de .dotfiles
log "Copiando archivos de .dotfiles..."
cp -r ~/.dotfiles/. ~/

# Copiar fondos de pantalla
log "Copiando fondos de pantalla..."
mkdir -p ~/Pictures
cp -r ~/backgrounds/. ~/Pictures/

log "Recuerda reiniciar el sistema para aplicar todos los cambios."
log ""
log "Inicia sesión en GitHub con el siguiente comando:"
log "gh auth login"
log ""
log "Instala node.js con el siguiente comando:"
log "nvm install --lts"
log ""
log "¡Instalación y configuración completada!"
