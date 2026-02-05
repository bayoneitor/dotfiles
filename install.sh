#!/bin/bash

# Detener el script si hay errores críticos (opcional, pero recomendado)
# set -e 

# Función para imprimir mensajes bonitos
print_msg() {
    echo -e "\n\033[1;34m===> $1 \033[0m"
}

# Verificación de seguridad: No ejecutar como root
if [ "$EUID" -eq 0 ]; then
  echo "Por favor, no ejecutes este script como root (sudo). El script pedirá contraseña cuando sea necesario."
  exit
fi

print_msg "Iniciando instalación del entorno de desarrollo..."

# 1. Actualizar repositorios e instalar dependencias base
print_msg "Actualizando sistema e instalando herramientas base..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y \
    zsh \
    xclip \
    git \
    stow \
    curl \
    wget \
    bat \
    btop \
    tmux \
    nano \
    vim \
    gnupg \
    zoxide 

# 2. Instalar EZA (Reemplazo moderno de ls)
if ! command -v eza &> /dev/null; then
    print_msg "Instalando Eza..."
    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
    sudo apt update
    sudo apt install -y eza
else
    print_msg "Eza ya está instalado."
fi

# 3. Instalar UV (Gestor de Python)
if ! command -v uv &> /dev/null; then
    print_msg "Instalando uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    
    # IMPORTANTE: Añadir uv al PATH temporalmente para esta sesión
    export PATH="$HOME/.local/bin:$PATH"
else
    print_msg "uv ya está instalado."
fi

# 3.0 Instalar NVM y Node.js LTS (CORREGIDO)
export NVM_DIR="$HOME/.nvm"
if [ ! -d "$NVM_DIR" ]; then
    print_msg "Instalando NVM y Node.js LTS..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    
    # Cargamos nvm temporalmente (SINTAXIS CORREGIDA AQUÍ)
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    
    # Instalar la versión LTS
    nvm install --lts
    nvm use --lts
else
    print_msg "NVM ya está instalado."
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
fi

# 3.1 Instalar TLDR usando uv
if ! command -v tldr &> /dev/null; then
    print_msg "Instalando tldr via uv..."
    $HOME/.local/bin/uv tool install tldr
else
    print_msg "tldr ya está instalado."
fi

# 3.2 Instalar Herramientas de "Poder"
print_msg "Instalando Ripgrep, JQ y NCDU..."
sudo apt install -y ripgrep jq ncdu

# 3.3 Instalar Lazygit
if ! command -v lazygit &> /dev/null; then
    print_msg "Instalando Lazygit..."
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit /usr/local/bin
    rm lazygit lazygit.tar.gz
else
    print_msg "Lazygit ya está instalado."
fi

# 3.4 Instalar xh
if ! command -v xh &> /dev/null; then
    print_msg "Instalando xh..."
    curl -sfL https://raw.githubusercontent.com/ducaale/xh/master/install.sh | sh
    [ -f ./xh ] && mv ./xh ~/.local/bin/
else
    print_msg "xh ya está instalado."
fi

# 4. Configurar Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    print_msg "Instalando Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    print_msg "Oh My Zsh ya estaba instalado."
fi

# 5. Instalar Plugins Zsh y P10k
print_msg "Descargando plugins y tema Powerlevel10k..."
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions 2>/dev/null || echo "Autosuggestions ok"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting 2>/dev/null || echo "Syntax highlighting ok"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM}/themes/powerlevel10k 2>/dev/null || echo "Powerlevel10k ok"

# 6. Instalar FZF
if [ ! -d "$HOME/.fzf" ]; then
    print_msg "Instalando FZF..."
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all
fi

# 7. Instalar Tmux Plugin Manager
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    print_msg "Instalando Tmux Plugin Manager..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# --- CAPTURAR CONFIGURACIÓN GIT EXISTENTE ---
# Hacemos esto antes de que stow (paso 8) borre el .gitconfig original
CURRENT_GIT_NAME=""
CURRENT_GIT_EMAIL=""

if command -v git &> /dev/null; then
    CURRENT_GIT_NAME=$(git config --global user.name)
    CURRENT_GIT_EMAIL=$(git config --global user.email)
    
    if [ -n "$CURRENT_GIT_NAME" ]; then
        print_msg "ℹ️  Detectada identidad Git existente: $CURRENT_GIT_NAME ($CURRENT_GIT_EMAIL)"
    fi
fi

# 8. Enlazar Dotfiles con Stow
print_msg "Aplicando configuración con Stow..."
# Asegurar que la carpeta existe
if [ -d "$HOME/dotfiles" ]; then
    cd "$HOME/dotfiles"
    
    # Borrar archivos por defecto conflictivos
    rm -f ~/.zshrc ~/.p10k.zsh ~/.gitconfig ~/.bashrc
    
    # Stow
    stow zsh
    stow git
    stow tmux
    stow nano
    stow vim
else
    print_msg "⚠️  ALERTA: No se encontró la carpeta ~/dotfiles. Saltando Stow."
fi

# 9. Docker (Opcional)
print_msg "Configuración de Docker..."
read -p "¿Deseas instalar Docker y Docker Compose? (s/n): " confirm
if [[ $confirm == [sS] || $confirm == [sS][iI] ]]; then
    if ! command -v docker &> /dev/null; then
        print_msg "Instalando Docker..."
        sudo install -m 0755 -d /etc/apt/keyrings
        sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
        sudo chmod a+r /etc/apt/keyrings/docker.asc
        
        # Corrección: Asegurar que sourceamos os-release para obtener VERSION_CODENAME
        echo \
          "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
          $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
          sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        
        sudo apt update
        sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        sudo usermod -aG docker $USER
        print_msg "Docker instalado. Recuerda reiniciar sesión."
    else
        print_msg "Docker ya está instalado."
    fi
fi

# 10. Instalar Fuentes
print_msg "Instalando fuentes..."
mkdir -p ~/.local/share/fonts
# Verificar si existen las fuentes antes de copiar
if [ -d "$HOME/dotfiles/fonts" ]; then
    cp -r ~/dotfiles/fonts/* ~/.local/share/fonts/
    fc-cache -fv
    print_msg "Fuentes instaladas en Linux (Recuerda instalarlas en Windows también)."
fi

# 11. Configurar Git
print_msg "Configuración de Git..."
GIT_LOCAL_CONFIG="$HOME/.gitconfig.local"

# Lógica para determinar si configuramos o no
CONFIGURE_GIT=true

if [ -f "$GIT_LOCAL_CONFIG" ]; then
    read -p "⚠️  Ya existe una configuración local en $GIT_LOCAL_CONFIG. ¿Quieres sobreescribirla? (s/N): " overwrite_git
    if [[ $overwrite_git != [sS] && $overwrite_git != [sS][iI] ]]; then
        CONFIGURE_GIT=false
        print_msg "Se mantuvo la configuración existente en $GIT_LOCAL_CONFIG"
    fi
fi

if [ "$CONFIGURE_GIT" = true ]; then
    GIT_NAME=""
    GIT_EMAIL=""

    # Si teníamos datos capturados, ofrecemos migrarlos
    if [ -n "$CURRENT_GIT_NAME" ]; then
        echo "Se encontraron datos de usuario previos:"
        echo "  Nombre: $CURRENT_GIT_NAME"
        echo "  Email:  $CURRENT_GIT_EMAIL"
        read -p "¿Quieres usar estos datos para la nueva configuración local? (S/n): " use_existing
        
        if [[ -z "$use_existing" || $use_existing == [sS] || $use_existing == [sS][iI] ]]; then
            GIT_NAME="$CURRENT_GIT_NAME"
            GIT_EMAIL="$CURRENT_GIT_EMAIL"
        fi
    fi

    # Si no tenemos datos (o decidió no usar los existentes), preguntamos
    if [ -z "$GIT_NAME" ]; then
        read -p "Introduce tu nombre para Git: " GIT_NAME
        read -p "Introduce tu email para Git: " GIT_EMAIL
    fi
    
    # Escribimos el archivo local
    echo "[user]" > "$GIT_LOCAL_CONFIG"
    echo "	name = $GIT_NAME" >> "$GIT_LOCAL_CONFIG"
    echo "	email = $GIT_EMAIL" >> "$GIT_LOCAL_CONFIG"
    
    print_msg "Configuración guardada en $GIT_LOCAL_CONFIG (No se subirá a Git)"
fi

# 12. Arreglos finales y Enlaces Simbólicos
print_msg "Aplicando parches finales..."

# Actualizar tldr
$HOME/.local/bin/tldr --update

# Alias para bat
mkdir -p ~/.local/bin
ln -sf /usr/bin/batcat ~/.local/bin/bat

# FIX CRÍTICO PARA ANTIGRAVITY / VSCODE
# Aseguramos que NVM está cargado para encontrar la ruta real de node
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

if command -v node &> /dev/null; then
    print_msg "Creando enlaces simbólicos para Node y NPM..."
    ln -sf $(which node) ~/.local/bin/node
    ln -sf $(which npx) ~/.local/bin/npx
    ln -sf $(which npm) ~/.local/bin/npm
else
    print_msg "⚠️  No se pudo encontrar Node para crear los enlaces."
fi

print_msg "¡Instalación COMPLETADA! 🎉"
print_msg "Por favor, cierra esta terminal y ábrela de nuevo."