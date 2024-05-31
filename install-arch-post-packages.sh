
#! /usr/bin/env bash

# Actualizar la base de datos de paquetes
sudo pacman -Sy

# Instalar git y github-cli
sudo pacman -S --noconfirm git github-cli

gitversion=$(git --version)
ghversion=$(gh --version)

echo "Git y GitHub CLI se han instalado correctamente."

echo "Instalando paquetes..."
echo "Google Chrome"

# Instalar google-chrome
yay -S --noconfirm google-chrome

echo "Logueate en GitHub CLI"

# Autenticación en GitHub CLI
gh auth login

echo "Instalando paquetes..."
echo "Zsh"
# Instalar Zsh y sus completions
sudo pacman -S --noconfirm zsh zsh-completions
echo "Cambiar la shell por defecto a Zsh"
# Cambiar la shell por defecto a Zsh
sudo chsh -s /bin/zsh

echo "Oh My Zsh"
# Instalar Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

echo "Powerlevel10k"
# Instalar Powerlevel10k
yay -S --noconfirm zsh-theme-powerlevel10k-git

# Configurar Powerlevel10k en Zsh
echo 'source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc

# Instalar Powerline y fuentes adicionales
echo "Powerline y fuentes adicionales"
sudo pacman -S --noconfirm powerline-common awesome-terminal-fonts ttf-fira-code noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra
yay -S --noconfirm ttf-meslo-nerd-font-powerlevel10k

echo "Visual Studio Code"

yay -S --noconfirm visual-studio-code-bin

echo "nvm"

yay -S --noconfirm nvm

echo "Obsidian"

yay -S --noconfirm obsidian

# Copiar todos los archivos
cp -r ./install-arch-post-packages/.* ./install-arch-post-packages/* ~
cp -r ./backgrounds/* ~/Pictures

echo "Clonando vault"

git clone http://github.com/ansango/vault.base.git

cp -r ./vault.base ~/Vaults

# Recordatorio para reiniciar la terminal
echo "Instalación completa. Reinicia la terminal para aplicar los cambios."

