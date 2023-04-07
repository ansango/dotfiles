# ARCH LINUX GNOME 43 - Tokyo Night Theme

## Install Arch Linux

In booted Arch Linux Live USB, open a terminal and run the following command to start the installation process:

```bash
archinstall
```

1. archinstall - English
2. kayboard layout - us
3. mirror region - 'spain' (or your country)
4. drive - your drive (sda, sdb, nvme0n1, etc)
5. disk layout - wipe all, default partition layout, ext4 and no /home partition
6. bootloader - grub-install
7. swap - true
8. hostname - ansango-desktop
9. root pass - \*\*\*
10. user account - none
11. profile - minimal
12. audio - pipewire
13. packages - nano
14. network config - networkmanager
15. timezone - utc
16. ntp - true
17. optional repos - multilib

After the installation check if efi boot is enabled

```bash
efibootmgr
```

If grub is not listed, run the following command

```bash
grub-install –target=x86_64-efi –efi-directory=/boot
```

Then reboot the system

```bash
exit
reboot
```

## Windows Bootloader

In Arch session logged run the following commands. These commands will install the necessary packages to read NTFS partitions and to detect other operating systems.

```bash
sudo pacman -S ntfs-3g os-prober
```

Edit the grub configuration file and uncomment the line that contains `GRUB_DISABLE_OS_PROBER=false`

```bash
sudo nano /etc/default/grub
```

Then run the following commands to update the grub configuration file and reboot the system.

```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
reboot
```

## Manage Users

### Add users

Here we will simply add a new user to our system and give them wheel access

- Add user

```sh
useradd -m -g wheel <your_user>
```

- Create password

```sh
passwd <your_user>
```

### Switch users

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

if you hate typing your password every time do this instead

```sh
%wheel ALL=(ALL) NOPASSWD: ALL
```

Login into newly created user

```bash
su - your_user_name
```

## Installing Git and AUR package manager

### Git

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

## NVIDIA config \*

### Find your video card

```bash
lspci | grep -e VGA -e 3D
```

- The first step is to disable Intel Integrated Graphics Controller

```bash
echo “install i915 /bin/false” | sudo tee --append /etc/modprobe.d/blacklist.conf
```

```bash
cat /etc/modprobe.d/blacklist.conf
```

- Update system

```bash
sudo pacman -Syyuu && yay -Syyuu
```

### Install Xorg and Nvidia drivers

- Install Xorg

```bash
sudo pacman -S xorg-server xorg-xinit xorg-apps --noconfirm
```

- Install Nvidia drivers

```bash
sudo pacman -S nvidia nvidia-utils nvidia-settings --noconfirm

```

Nvidia non open source drivers may conflict with nouveau OS drivers and in below case to make drivers work I needed to blacklist nouveau drivers

```bash
cat /usr/lib/modprobe.d/nvidia.conf
blacklist nouveau
```

## Installing Gnome

Run the following command to install Gnome, but select only the packages you want to install.

```bash
sudo pacman -S gnome
```

In my case I selected the following packages

```bash
gdm, gnome-characters, gnome-color-manager, gnome-control-center, gnome disk-utility, gnome-keyring, gnome-menus, gnome-session, gnome-settings-daemon, gnome-shell, gnome-shell-extensions, grilo-plugins, grilo-plugins, gvfs, gvfs-afc, gvfs-goa, gvfs-google, gvfs-gphoto2, gvfs-mtp, gvfs-nfs, gvfs-smb, nautilus, tracker3-miners,
```

More or less corresponding to the following number options

```bash
packages 7,11,13,16,17,19,,22,26,27,28,29,37,38,39,40,41,42,43,44,45,47,53
```

Because I don't want to install gnome-console, I will install Alacritty instead (choose whatever you want) and I will also install gnome-tweaks to setup font scaling and other things.

```bash
sudo pacman -S alacritty gnome-tweaks --noconfirm

```

### Starting and enabling Gnome

```bash
sudo systemctl start gdm.service
```

Open Alacritty and run the following command to enable Gnome

```bash
sudo systemctl enable gdm.service
```

### Enabling Bluetooth service

```bash
sudo systemctl start bluetooth.service
sudo systemctl enable bluetooth.service
```

## Zsh, Launcher, and Fonts

### Zsh

Install zsh and oh-my-zsh

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

After installation and configure log out and log in again

### Fonts

Fonts that I use you could use with gnome-tweaks

```bash
sudo pacman -S ttf-roboto ttf-fira-code
```

### Launcher

I choose Ulancher because has a tokyo night theme designed, for install

```bash
yay -S ulauncher
```

### Recommended packages

```bash
yay -S gnome-shell-extension-dash-to-dock
```

## Using dotfiles

### Clone dotfiles

```bash
git clone
```

### Install dotfiles

```bash
cd dotfiles
```

```bash
cp -r .config ~/
```

```bash
cp -r .themes ~/
```

```bash
cp -r Images ~/
```

```bash
cp .zshrc ~/
```

```bash

cp .p10k.zsh ~/
```

Then logout and login again and you should have a nice looking desktop with a Tokyo Night Theme
