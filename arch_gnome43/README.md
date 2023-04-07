# Instalar Arch

## Instalacion

ejecuta en la terminal

```bash
archinstall
```

1. archinstall - English
2. kayboard layout - us
3. mirror region - 'spain'
4. drive - el disco
5. disk layout - wipe all, elegimos default partition layout, ext4 y sin /home partition
6. bootloader - grub-install
7. swap - true
8. hostname - ansango-desktop
9. root pass - \*\*\*
10. user account - none
11. profile - minimal
12. audio - pipewire
13. packages - nano
14. network config - networkmanager
15. timezone - utx
16. ntp - true
17. optional repos - multilib

despues de instalar ejecuta:

```bash
grub-install –target=x86_64-efi –efi-directory=/boot
```

despues ejecutamos

```bash
exit
reboot
```

## Windows bootloader

```bash
sudo pacman -S ntfs-3g os-prober
```

```bash
sudo nano /etc/default/grub
```

Y descomentamos la linea que contenga `GRUB_DISABLE_OS_PROBER=false`

```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
reboot
```

## Post intstalacion

Here we will simply add a new user to our system and give them wheel access

## Add a user

- Add user

```sh
useradd -m -g wheel <your_user>
```

- Create password

```sh
passwd <your_user>
```

## Switch users

To switch to your user run:

```sh
su - <your_user>
```

### Giving your user access to sudo

in root user

```sh
EDITOR=nano visudo
```

and uncomment this line so it looks like this

```sh
%wheel ALL=(ALL) ALL
```

if you hate typing your password everytime like me do this instead

```sh
%wheel ALL=(ALL) NOPASSWD: ALL
```

Login into newly created user

```bash
su - your_user_name
```

```bash
sudo pacman -S git
```

### Install AUR package manager

#### Installing YAY

```bash
mkdir sources && cd sources && git clone https://aur.archlinux.org/yay.git && cd yay
```

```bash
makepkg -si --needed --noconfirm
```

### NVIDIA config \*

#### Find your video card

```bash
lspci | grep -e VGA -e 3D
```

The first step is to disable Intel Integrated Graphics Controller

```bash
echo “install i915 /bin/false” | sudo tee --append /etc/modprobe.d/blacklist.conf
```

```bash
cat /etc/modprobe.d/blacklist.conf
```

update system

```bash
sudo pacman -Syyuu && yay -Syyuu
```

install xorg and nvidia drivers

```bash
sudo pacman -S xorg-server xorg-xinit xorg-apps
```

```bash
sudo pacman -S nvidia nvidia-utils nvidia-settings
```

Nvidia non open source drivers may conflict with nouveau OS drivers and in below case to make drivers work I needed to blacklist nouveau drivers

```bash
cat /usr/lib/modprobe.d/nvidia.conf
blacklist nouveau
```

## Instalando gnome

```bash
sudo pacman -S gnome
```

Instalar solo:

```bash
gdm, gnome-characters, gnome-color-manager, gnome-control-center, gnome disk-utility, gnome-keyring, gnome-menus, gnome-session, gnome-settings-daemon, gnome-shell, gnome-shell-extensions, grilo-plugins, grilo-plugins, gvfs, gvfs-afc, gvfs-goa, gvfs-google, gvfs-gphoto2, gvfs-mtp, gvfs-nfs, gvfs-smb, nautilus, tracker3-miners,
```

```bash
opciones 7,11,13,16,17,19,,22,26,27,28,29,37,38,39,40,41,42,43,44,45,47,53
```

```bash
sudo pacman -S gnome-tweaks alacritty
```

iniciamos gnome

```bash
sudo systemctl start gdm.service
```

abrimos alacritty

```bash
sudo systemctl enable gdm.service
```

```bash
sudo systemctl start bluetooth.service
sudo systemctl enable bluetooth.service
```

## apps

```bash
sudo pacman -S neofetch htop
```

```bash
yay -S google-chrome visual-studio-code-bin youtube-music-bin gnome-shell-extension-dash-to-dock
```

### zsh

```bash
sudo pacman -S zsh zsh-completions
```

```bash
chsh -s /bin/zsh
```

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussel/oh-my-zsh/master/tools/install.sh)"
```

```bash
yay -S --noconfirm zsh-theme-powerlevel10k-git
```

```bash
echo 'source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
```

```bash
sudo pacman -S powerline-common awesome-terminal-fonts
yay -S --noconfirm ttf-meslo-nerd-font-powerlevel10k
```

```bash
p10k configure
```

```bash
sudo pacman -S ttf-roboto ttf-fira-code
```

```bash
yay -S ulauncher
```

discord node, yarn pnpm ... nvm
