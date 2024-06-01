echo "Zsh"
# Instalar Zsh y sus completions
sudo pacman -S --noconfirm zsh zsh-completions
echo "Cambiar la shell por defecto a Zsh"
# Cambiar la shell por defecto a Zsh
chsh -s /bin/zsh

echo "Oh My Zsh"
# Instalar Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"