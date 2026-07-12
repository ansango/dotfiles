#!/bin/bash
# Setup script for Debian 13 (Trixie) - actualizado para 13.6

if [ -z "$BASH_VERSION" ]; then
    exec bash "$0" "$@"
fi

# Function to print log messages
log() {
    echo "[LOG] $1"
}

# Function to print error messages
error() {
    echo "[ERROR] $1"
}

# Ask for the sudo password once, then keep the credential cache alive in the
# background for the rest of the script so it doesn't get asked again mid-run.
sudo -v
( while true; do sudo -n true; sleep 60; kill -0 "$$" 2>/dev/null || exit; done ) 2>/dev/null &
SUDO_KEEPALIVE_PID=$!
trap 'kill "$SUDO_KEEPALIVE_PID" 2>/dev/null' EXIT

# Check if dialog is installed and install it if necessary
if ! command -v dialog >/dev/null 2>&1; then
    log "dialog not found. Installing dialog..."
    sudo apt update && sudo apt install -y dialog
fi

CURRENT_USER=$(whoami)
log "Current user: $CURRENT_USER"

logging() {
    echo "[LOG] Current user inside function: $CURRENT_USER"
    su -c 'echo "[LOG] Current user inside su -c: $(whoami)"' "$CURRENT_USER"
}

# Function to create a sudo user
create_sudo_user() {
    log "Creating sudo user (placeholder)"

    # check if running as root
    if [ "$EUID" -ne 0 ]; then
        error "Please run as root to create a sudo user."
        return 1
    fi

    username=$(dialog --inputbox "Enter the new username:" 8 40 2>&1 >/dev/tty)
    clear
    echo "$username"
    if [ -z "$username" ]; then
        error "Username cannot be empty."
        return 1
    fi

    apt install -y sudo
    adduser "$username" sudo
    CURRENT_USER="$username"
    log "User $username created and added to sudo group."
}

update_and_upgrade(){
    log "Updating and upgrading with apt"
    sudo apt update -y
    sudo apt upgrade -y
}

# Function to update everything: apt packages + flatpak apps/runtimes
update_all() {
    logging
    update_and_upgrade

    if command -v flatpak >/dev/null 2>&1; then
        log "Updating flatpak apps and runtimes"
        flatpak update -y
        flatpak uninstall --unused -y
    else
        log "flatpak not installed, skipping flatpak update"
    fi

    log "Update all completed"
}

# Helper: ensure flatpak + flathub remote are set up (used by several apps)
ensure_flatpak() {
    if ! command -v flatpak >/dev/null 2>&1; then
        log "flatpak not found. Installing flatpak..."
        sudo apt install -y flatpak gnome-software-plugin-flatpak
        flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
        log "flatpak installed"
    fi
}

# Helper: ensure Microsoft VSCode apt repo is configured (used by vscode + vscode insiders)
ensure_vscode_repo() {
    if [ ! -f /etc/apt/sources.list.d/vscode.list ]; then
        log "Adding Microsoft VSCode repository"
        curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
        sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/keyrings/microsoft-archive-keyring.gpg
        sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
        rm -f microsoft.gpg
        sudo apt update -y
    fi
}

# Function to install Gnome Desktop - Core
install_gnome_core() {
    logging
    log "Installing Gnome Desktop - Core"
    sudo apt install gnome-core -y
    sudo apt purge ifupdown -y
    log "Configuring NetworkManager..."
    sudo bash -c 'cat > /etc/NetworkManager/NetworkManager.conf' << 'EOF'
[main]
plugins=ifupdown,keyfile

[ifupdown]
managed=true
EOF

    log "NetworkManager configuration updated."
}

# Function to install Gnome Tweaks
install_gnome_tweaks() {
    logging
    log "Installing Gnome Tweaks"
    sudo apt install gnome-tweaks -y
}

# Function to update repositories sources list
update_repos() {
    logging
    log "Updating Trixie repositories"
    sudo bash -c 'cat > /etc/apt/sources.list' << 'EOF'
# Debian 13 (Trixie) - Repositorios principales con todos los componentes
deb http://deb.debian.org/debian/ trixie main contrib non-free non-free-firmware
deb-src http://deb.debian.org/debian/ trixie main contrib non-free non-free-firmware

# Actualizaciones de seguridad
deb http://security.debian.org/debian-security trixie-security main contrib non-free non-free-firmware
deb-src http://security.debian.org/debian-security trixie-security main contrib non-free non-free-firmware

# Actualizaciones menores
deb http://deb.debian.org/debian/ trixie-updates main contrib non-free non-free-firmware
deb-src http://deb.debian.org/debian/ trixie-updates main contrib non-free non-free-firmware

# Backports
deb http://deb.debian.org/debian trixie-backports main contrib non-free non-free-firmware
deb-src http://deb.debian.org/debian trixie-backports main contrib non-free non-free-firmware
EOF

    update_and_upgrade

    log "Repositories sources list updated"
}

# Function to install Nvidia drivers
install_nvidia_drivers() {
    logging
    log "Installing Nvidia drivers"
    sudo apt install nvidia-detect -y
    sudo apt install linux-headers-amd64 -y
    sudo apt install nvidia-driver -y
}

# Function to install Curl
install_curl() {
    logging
    log "Installing curl"
    sudo apt install curl -y
}

# Function to install Wget
install_wget() {
    logging
    log "Installing wget"
    sudo apt install wget -y
}

# Function to install Git
install_git() {
    logging
    log "Installing git"
    sudo apt install git -y
}

# Function to install GH CLI
install_gh_cli() {
    logging
    log "Installing gh cli"
    sudo apt install gh -y
}

# Function to install Nerd Fonts
install_nerd_fonts() {
    logging
    log "Installing nerd fonts"
    sudo apt install fonts-noto fonts-firacode fonts-powerline -y
    sudo wget -P /usr/local/share/fonts https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
    sudo wget -P /usr/local/share/fonts https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
    sudo wget -P /usr/local/share/fonts https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
    sudo wget -P /usr/local/share/fonts https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
}

# Function zsh
install_zsh() {
    logging
    log "Installing Oh My Zsh"
    sudo apt install zsh -y
    # add passwordless sudo for current user
    sudo usermod -aG sudo "$CURRENT_USER"
    # change default shell to zsh for current user
    sudo chsh -s "$(which zsh)" "$CURRENT_USER"
    sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)" "" --unattended
    git clone https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    sed -i 's/ZSH_THEME=".*"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' "$HOME/.zshrc"
    log "Oh My Zsh installed"
}

# Function to install NVM
install_nvm() {
    logging
    log "Installing nvm"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    if command -v nvm >/dev/null 2>&1; then
        log "NVM installed. Version: $(nvm --version)"
    else
        log "NVM installed. Abre una nueva shell (o haz 'source ~/.bashrc'/'source ~/.zshrc') para usarlo."
    fi
}

# Function to install Node.js (LTS) - depende de NVM
install_nodejs() {
    logging
    log "Installing nodejs (LTS)"
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    if ! command -v nvm >/dev/null 2>&1; then
        error "nvm not found. Selecciona primero 'Install NVM'."
        return 1
    fi
    nvm install --lts
}

# Function to install Bun
install_bun() {
    logging
    log "Installing bun"
    curl -fsSL https://bun.sh/install | bash
    log "Bun instalado. Abre una nueva shell para usarlo."
}

# Function to install VSCode (stable)
install_vscode() {
    logging
    log "Installing vscode"
    ensure_vscode_repo
    sudo apt install -y code
}

# Function to install VSCode Insiders
install_vscode_insiders() {
    logging
    log "Installing vscode insiders"
    ensure_vscode_repo
    sudo apt install -y code-insiders
}

# Function to install Zed
install_zed() {
    logging
    log "Installing Zed"
    curl -f https://zed.dev/install.sh | sh
}

# Function to install Docker Engine + Compose plugin
install_docker() {
    logging
    log "Installing Docker"
    sudo apt install -y ca-certificates curl gnupg
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt update -y
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo usermod -aG docker "$CURRENT_USER"
    log "Docker instalado. Cierra sesión y vuelve a entrar para usar docker sin sudo."
}

# Function to install Pi Coding Agent (pi.dev)
install_pi_agent() {
    logging
    log "Installing Pi Coding Agent"
    curl -fsSL https://pi.dev/install.sh | sh
}

# Function to install Claude Code
install_claude_code() {
    logging
    log "Installing Claude Code"
    curl -fsSL https://claude.ai/install.sh | bash
}

# Function to install GitHub Copilot CLI
install_copilot_cli() {
    logging
    log "Installing GitHub Copilot CLI"
    curl -fsSL https://gh.io/copilot-install | bash
}

# Function to install OpenCode
install_opencode() {
    logging
    log "Installing OpenCode"
    curl -fsSL https://opencode.ai/install | bash
}

# Function to install Ollama
install_ollama() {
    logging
    log "Installing Ollama"
    curl -fsSL https://ollama.com/install.sh | sh
}

# Function to install Firefox
install_firefox() {
    logging
    log "Installing firefox"
    sudo apt install firefox -y
}

# Function to install Brave Browser
install_brave() {
    logging
    log "Installing brave"
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    sudo curl -fsSLo /etc/apt/sources.list.d/brave-browser-release.sources https://brave-browser-apt-release.s3.brave.com/brave-browser.sources
    sudo apt update -y
    sudo apt install brave-browser -y
}

# Function to install Thunderbird
install_thunderbird() {
    logging
    log "Installing thunderbird"
    sudo apt install -y thunderbird
}

# Function to install Zen Browser
install_zen_browser() {
    logging
    log "Installing Zen Browser"
    ensure_flatpak
    flatpak install -y flathub app.zen_browser.zen
}

# Function to install Obsidian
install_obsidian() {
    logging
    log "Installing obsidian"
    ensure_flatpak
    flatpak install -y flathub md.obsidian.Obsidian
}

# Function to install OrcaSlicer
install_orcaslicer() {
    logging
    log "Installing OrcaSlicer"
    ensure_flatpak
    flatpak install -y flathub com.orcaslicer.OrcaSlicer
}

# Function to install Bambu Studio
install_bambu_studio() {
    logging
    log "Installing Bambu Studio"
    ensure_flatpak
    flatpak install -y flathub com.bambulab.BambuStudio
}

# Function to install Darktable
install_darktable() {
    logging
    log "Installing darktable"
    sudo apt install -y darktable
}

# Function to install Strawberry Music Player
install_strawberry() {
    logging
    log "Installing Strawberry Music Player"
    sudo apt install -y strawberry
}

# Function to install VLC Media Player
install_vlc() {
    logging
    log "Installing vlc"
    sudo apt install vlc -y
}

# Function to install yt-dlp
install_yt_dlp() {
    logging
    log "Installing yt-dlp"
    sudo apt install -y yt-dlp
    # ffmpeg/ffprobe: dependencia "strongly recommended" de yt-dlp, necesaria
    # para fusionar audio/vídeo y para el post-procesado (extraer audio,
    # convertir formato, incrustar carátulas, etc.)
    # https://github.com/yt-dlp/yt-dlp#strongly-recommended
    sudo apt install -y ffmpeg

    log "Adding yt-dlp album download aliases to .zshrc"
    ZSHRC="$HOME/.zshrc"
    touch "$ZSHRC"
    if ! grep -q "# >>> yt-dlp aliases >>>" "$ZSHRC" 2>/dev/null; then
        cat >> "$ZSHRC" << 'EOF'

# >>> yt-dlp aliases >>>
alias bcdl='yt-dlp -x --audio-format mp3 --audio-quality 0 --embed-thumbnail --add-metadata --write-thumbnail --convert-thumbnails jpg --replace-in-metadata "title" "^.* - " "" --ppa "ThumbnailsConvertor:-c:v mjpeg -vf \"crop='ih':'ih'\"" -o "thumbnail:%(uploader)s/%(album)s/cover.%(ext)s" -o "%(uploader)s/%(album)s/%(playlist_index)02d %(title)s.%(ext)s"'
alias ytdl='yt-dlp --cookies-from-browser firefox -x --audio-format mp3 --audio-quality 0 --embed-thumbnail --add-metadata --write-thumbnail --convert-thumbnails jpg --replace-in-metadata "title" "^.* - " "" --ppa "ThumbnailsConvertor:-c:v mjpeg -vf \"crop='ih':'ih'\"" --parse-metadata "%(playlist_index)s:%(track_number)s" --parse-metadata "%(release_year,upload_date>%Y)s:%(meta_date)s" -o "thumbnail:%(uploader)s/%(album)s/cover.%(ext)s" -o "%(uploader)s/%(album)s/%(playlist_index)02d %(title)s.%(ext)s"'
# <<< yt-dlp aliases <<<
EOF
        log "Aliases added. Ejecuta 'source ~/.zshrc' (o abre una nueva shell) para usarlos: bcdl, ytdl"
    else
        log "yt-dlp aliases already present in .zshrc, skipping"
    fi
}

# --- MAIN LOGIC ---

HEIGHT=20
WIDTH=76
CHOICE_HEIGHT=12
BACKTITLE="Setup Script - Debian Trixie 13.6"

SELECTED_ACTIONS=()

# dialog no soporta secciones dentro de un mismo --checklist, así que se
# encadenan varios checklists (uno por categoría) y se van acumulando
# las acciones elegidas en SELECTED_ACTIONS.
run_section() {
    local title="$1"
    local menu="$2"
    shift 2
    dialog --clear \
        --backtitle "$BACKTITLE" \
        --title "$title" \
        --checklist "$menu" \
        "$HEIGHT" "$WIDTH" "$CHOICE_HEIGHT" \
        "$@" \
        2>&1 >/dev/tty
}

# --- Sección: Sistema ---
SISTEMA_OPTIONS=(
    1 "Create a sudo user" OFF
    2 "Install Gnome Desktop - Core" OFF
    3 "Install Gnome Tweaks" OFF
    4 "Update Repositories Sources List" OFF
    5 "Install Nvidia Drivers" OFF
    6 "Update everything (apt + flatpak)" OFF
)
CHOICES=$(run_section "Sistema" "Elige opciones de sistema:" "${SISTEMA_OPTIONS[@]}")
clear
for CHOICE in $CHOICES; do
    case $CHOICE in
        1) SELECTED_ACTIONS+=(create_sudo_user) ;;
        2) SELECTED_ACTIONS+=(install_gnome_core) ;;
        3) SELECTED_ACTIONS+=(install_gnome_tweaks) ;;
        4) SELECTED_ACTIONS+=(update_repos) ;;
        5) SELECTED_ACTIONS+=(install_nvidia_drivers) ;;
        6) SELECTED_ACTIONS+=(update_all) ;;
    esac
done

# --- Sección: Herramientas base ---
BASE_OPTIONS=(
    1 "Install Curl" OFF
    2 "Install Wget" OFF
    3 "Install Git" OFF
    4 "Install GH CLI" OFF
    5 "Install Nerd Fonts" OFF
    6 "Install Zsh and Oh My Zsh" OFF
)
CHOICES=$(run_section "Herramientas base" "Elige herramientas base:" "${BASE_OPTIONS[@]}")
clear
for CHOICE in $CHOICES; do
    case $CHOICE in
        1) SELECTED_ACTIONS+=(install_curl) ;;
        2) SELECTED_ACTIONS+=(install_wget) ;;
        3) SELECTED_ACTIONS+=(install_git) ;;
        4) SELECTED_ACTIONS+=(install_gh_cli) ;;
        5) SELECTED_ACTIONS+=(install_nerd_fonts) ;;
        6) SELECTED_ACTIONS+=(install_zsh) ;;
    esac
done

# --- Sección: Desarrollo ---
DEV_OPTIONS=(
    1 "Install NVM" OFF
    2 "Install Node.js (LTS) [requiere NVM]" OFF
    3 "Install Bun" OFF
    4 "Install VSCode" OFF
    5 "Install VSCode Insiders" OFF
    6 "Install Zed" OFF
    7 "Install Docker" OFF
)
CHOICES=$(run_section "Desarrollo" "Elige herramientas de desarrollo:" "${DEV_OPTIONS[@]}")
clear
for CHOICE in $CHOICES; do
    case $CHOICE in
        1) SELECTED_ACTIONS+=(install_nvm) ;;
        2) SELECTED_ACTIONS+=(install_nodejs) ;;
        3) SELECTED_ACTIONS+=(install_bun) ;;
        4) SELECTED_ACTIONS+=(install_vscode) ;;
        5) SELECTED_ACTIONS+=(install_vscode_insiders) ;;
        6) SELECTED_ACTIONS+=(install_zed) ;;
        7) SELECTED_ACTIONS+=(install_docker) ;;
    esac
done

# --- Sección: Agentes IA / CLI ---
AI_OPTIONS=(
    1 "Install Pi Coding Agent" OFF
    2 "Install Claude Code" OFF
    3 "Install GitHub Copilot CLI" OFF
    4 "Install OpenCode" OFF
    5 "Install Ollama" OFF
)
CHOICES=$(run_section "Agentes IA / CLI" "Elige agentes/CLIs de IA:" "${AI_OPTIONS[@]}")
clear
for CHOICE in $CHOICES; do
    case $CHOICE in
        1) SELECTED_ACTIONS+=(install_pi_agent) ;;
        2) SELECTED_ACTIONS+=(install_claude_code) ;;
        3) SELECTED_ACTIONS+=(install_copilot_cli) ;;
        4) SELECTED_ACTIONS+=(install_opencode) ;;
        5) SELECTED_ACTIONS+=(install_ollama) ;;
    esac
done

# --- Sección: Navegadores y comunicación ---
NET_OPTIONS=(
    1 "Install Brave Browser" OFF
    2 "Install Firefox" OFF
    3 "Install Thunderbird" OFF
    4 "Install Zen Browser" OFF
)
CHOICES=$(run_section "Navegadores y comunicación" "Elige navegadores/comunicación:" "${NET_OPTIONS[@]}")
clear
for CHOICE in $CHOICES; do
    case $CHOICE in
        1) SELECTED_ACTIONS+=(install_brave) ;;
        2) SELECTED_ACTIONS+=(install_firefox) ;;
        3) SELECTED_ACTIONS+=(install_thunderbird) ;;
        4) SELECTED_ACTIONS+=(install_zen_browser) ;;
    esac
done

# --- Sección: Notas ---
NOTES_OPTIONS=(
    1 "Install Obsidian" OFF
)
CHOICES=$(run_section "Notas" "Elige apps de notas:" "${NOTES_OPTIONS[@]}")
clear
for CHOICE in $CHOICES; do
    case $CHOICE in
        1) SELECTED_ACTIONS+=(install_obsidian) ;;
    esac
done

# --- Sección: Multimedia e impresión 3D ---
MEDIA_OPTIONS=(
    1 "Install OrcaSlicer" OFF
    2 "Install Bambu Studio" OFF
    3 "Install Darktable" OFF
    4 "Install Strawberry Music Player" OFF
    5 "Install VLC Media Player" OFF
    6 "Install yt-dlp" OFF
)
CHOICES=$(run_section "Multimedia e impresión 3D" "Elige apps de multimedia/impresión 3D:" "${MEDIA_OPTIONS[@]}")
clear
for CHOICE in $CHOICES; do
    case $CHOICE in
        1) SELECTED_ACTIONS+=(install_orcaslicer) ;;
        2) SELECTED_ACTIONS+=(install_bambu_studio) ;;
        3) SELECTED_ACTIONS+=(install_darktable) ;;
        4) SELECTED_ACTIONS+=(install_strawberry) ;;
        5) SELECTED_ACTIONS+=(install_vlc) ;;
        6) SELECTED_ACTIONS+=(install_yt_dlp) ;;
    esac
done

if [ ${#SELECTED_ACTIONS[@]} -eq 0 ]; then
    log "No options selected. Exiting."
    exit 1
fi

# Un único update/upgrade para todas las acciones seleccionadas
update_and_upgrade

for ACTION in "${SELECTED_ACTIONS[@]}"; do
    "$ACTION"
done

log ""
log "Setup completed!"
log "Executed: ${SELECTED_ACTIONS[*]}"
