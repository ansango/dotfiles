#! /usr/bin/env bash

# Actualizar la base de datos de paquetes
sudo pacman -Sy

# Instalar git
sudo pacman -S --noconfirm git

echo "Instalando Gnome..."

# Instalar Gnome minimal
sudo pacman -S --noconfirm gdm gnome-control-center gnome-session gnome-settings-daemon gnome-shell gnome-keyring nautilus
sudo pacman -S --noconfirm gnome-characters gnome-color-manager gnome-disk-utility gnome-menus gnome-shell-extensions grilo-plugins gvfs gvfs-afc gvfs dnssd gvfs-goa gvfs-google gvfs-gphoto2 gvfs-mtp gvfs-nfs gvfs-smb loupe sushi tracker3-miners xdg-desktop-portal-gnome xdg-user-dirs-gtk
echo "Instalando paquetes..."

echo "Alacritty"

sudo pacman -S --noconfirm alacritty

echo "Gnome Tweaks"

sudo pacman -S --noconfirm gnome-tweaks

echo "Gnome Dash to Dock"

yay -S --noconfirm gnome-shell-extension-dash-to-dock

echo "Habilitando servicios..."

sudo systemctl start bluetooth.service
sudo systemctl enable bluetooth.service

sudo systemctl enable gdm.service
sudo systemctl start gdm.service
