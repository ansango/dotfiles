#! /usr/bin/env bash

# Actualizar la base de datos de paquetes
sudo pacman -Sy

# Instalar git
sudo pacman -S --noconfirm git

echo ""
echo "Instalando Gnome..."
echo ""
echo "Gnome Minimal"
# Instalar Gnome minimal
sudo pacman -S --noconfirm gdm gnome-control-center gnome-session gnome-settings-daemon gnome-shell gnome-keyring nautilus
echo ""
echo "Gnome Utils"
sudo pacman -S --noconfirm gnome-characters gnome-color-manager gnome-disk-utility gnome-menus gnome-shell-extensions grilo-plugins gvfs gvfs-afc gvfs dnssd gvfs-goa gvfs-google gvfs-gphoto2 gvfs-mtp gvfs-nfs gvfs-smb loupe sushi tracker3-miners xdg-desktop-portal-gnome xdg-user-dirs-gtk
echo ""
echo "Gnome Extensions"
sudo pacman -S --noconfirm gnome-tweaks gnome-shell-extension-dash-to-dock

echo ""
echo "Instalando paquetes..."

echo "Alacritty"

sudo pacman -S --noconfirm alacritty

echo "Habilitando servicios..."

# Copiar la imagen de fondo a la ubicación de GDM
sudo cp ./backgrounds/aurora.jpg /usr/share/backgrounds/

# Configurar GDM para usar la nueva imagen de fondo
sudo bash -c "cat > /etc/dconf/db/gdm.d/01-background <<EOF
[org/gnome/desktop/background]
picture-uri='file:///usr/share/backgrounds/aurora.jpg'
EOF"

# Actualizar la configuración de GDM
sudo dconf update

sudo systemctl start bluetooth.service
sudo systemctl enable bluetooth.service

sudo systemctl enable gdm.service
sudo systemctl start gdm.service
