# Dotfiles

This is a collection of my dotfiles.

To my future self: remember to be simple and minimalistic. We only want to keep the essentials.

## Dotfile Apps

- [alacritty]
- [bash]
- [zsh]
- [p10k]

## Installation

```bash
sudo pacman -S git
```

```bash
sudo pacman -S github-cli
```

```bash
gh auth login
```

```bash
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```
### Alacritty

```bash
sudo pacman -S alacritty
```
### Zsh

```bash
sudo pacman -S zsh zsh-completions
```

```bash
chsh -s /bin/zsh
```

### Oh My Zsh

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussel/oh-my-zsh/master/tools/install.sh)"
```

### Powerlevel10k

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
git clone https://github.com/ansango/dotfiles.git
cp -r dotfiles/. ~
```