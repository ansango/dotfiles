# Instalar paquetes esenciales Nvidia
sudo pacman -S --noconfirm nvidia nvidia-utils nvidia-settings opencl-nvidia xorg-server-devel

echo "Reinicia el sistema para aplicar los cambios."
echo "Después setea el monitor primario y las configuraciones que estimes, rotación si tienes vertical, etc…"
echo "Desues copia el archivo de configuración de monitores a la carpeta de gdm:"
echo ""
echo "sudo cp ~/.config/monitors.xml ~gdm/.config/"
echo ""
echo "Reinicia el sistema para aplicar los cambios."
