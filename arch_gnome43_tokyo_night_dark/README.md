# ARCH LINUX GNOME 43 - Tokyo Night Theme

## Introduction

This is a guide to install Arch Linux with Gnome 43 and Tokyo Night Theme, this guide is based on my Arch Linux installation guide, so if you want to know more about Arch Linux installation you can check it out [here](../docs/InstallArch.md).

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
git clone https://github.com/ansango/dotfiles.git
```

### Install dotfiles

```bash
cd dotfiles/arch_gnome43_tokyo_night_dark
```

```bash
cp -r .config ~/ && cp -r .themes ~/ && cp -r Images ~/ && cp .zshrc ~/ && cp .p10k.zsh ~/
```

Then logout and login again and you should have a nice looking desktop with a Tokyo Night Theme
