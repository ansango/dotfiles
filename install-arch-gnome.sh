#! /usr/bin/env bash

# Actualizar la base de datos de paquetes
sudo pacman -Sy

# Instalar git
sudo pacman -S --noconfirm git

echo "Instalando Yay"

if [ -d "yay" ]; then
    sudo rm -rf yay
fi

# Clonar y construir yay desde AUR
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd ..
# Verificar que yay se haya instalado correctamente
versionyay=$(yay --version)

if [ -z "$versionyay" ]; then
    echo "Yay no se ha instalado correctamente."
    exit 1
fi

echo "Yay se ha instalado correctamente."

# Borrar el directorio yay
sudo rm -rf yay

echo ""
echo "Instalando Gnome..."
echo ""
echo "Gnome Minimal"
# Instalar Gnome minimal
sudo pacman -S --noconfirm gdm gnome-control-center gnome-session gnome-settings-daemon gnome-shell gnome-keyring nautilus gnome-characters gnome-color-manager gnome-disk-utility gnome-menus gnome-shell-extensions grilo-plugins gvfs gvfs-afc gvfs-dnssd gvfs-goa gvfs-google gvfs-gphoto2 gvfs-mtp gvfs-nfs gvfs-smb loupe sushi tracker3-miners xdg-desktop-portal-gnome xdg-user-dirs-gtk
echo ""
echo "Gnome Extensions"
sudo pacman -S --noconfirm gnome-tweaks
yay - S gnome-shell-extension-dash-to-dock

echo ""
echo "Instalando paquetes..."

echo "Alacritty"

sudo pacman -S --noconfirm alacritty

echo "Habilitando servicios..."

sudo systemctl start bluetooth.service
sudo systemctl enable bluetooth.service

sudo systemctl enable gdm.service
sudo systemctl start gdm.service
