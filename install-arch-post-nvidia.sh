
echo “install i915 /bin/false” | sudo tee --append /etc/modprobe.d/blacklist.conf
cat /etc/modprobe.d/blacklist.conf
sudo pacman -Syyuu
sudo pacman -S xorg-server xorg-xinit xorg-apps --noconfirm
sudo pacman -S nvidia nvidia-utils nvidia-settings --noconfirm
cat /usr/lib/modprobe.d/nvidia-utils.conf

