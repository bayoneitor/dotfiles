# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# --- PATH CONFIGURATION ---
# Añadimos .local/bin al principio para que nuestras herramientas modernas tengan prioridad
export PATH="$HOME/.local/bin:$PATH"

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load
ZSH_THEME="powerlevel10k/powerlevel10k"

# --- PLUGINS ---
# IMPORTANTE: He quitado el plugin 'z' para que no choque con zoxide.
# He movido syntax-highlighting al final (recomendado).
plugins=(
    git 
    common-aliases 
    aliases 
    alias-finder 
    sudo 
    docker 
    docker-compose 
    web-search
    zsh-autosuggestions 
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# --- USER CONFIGURATION ---
export LANG=C.UTF-8

# --- NVM (Node Version Manager) ---
# Esto es vital para que Node y NPM funcionen en cada sesión
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

# --- PYTHON UV ---
. "$HOME/.local/bin/env"

# --- ZOXIDE (Better CD) ---
# Borramos cualquier alias 'z' previo para evitar errores
unalias z 2>/dev/null

# --cmd cd define 'cd' como FUNCIÓN (no como alias): si el argumento es un directorio
# real hace un cd normal, y si no, salta por frecuencia. Deja intactos 'cd -', 'cd ..'
# y las rutas relativas, así que no rompe scripts.
#
# NO usar 'alias cd="z"' (que es lo que había): con la zoxide de apt (v0.4.3, de 2020)
# el helper interno se llama '_z_cd', con UN solo guion bajo. En zsh todo lo que empieza
# por '_' cae en el namespace del autocompletado, que se autocarga desde fpath, y en
# shells NO interactivas ese helper no llega a definirse aunque 'z' sí -> el alias
# rompía TODOS los cd con "z:14: command not found: _z_cd".
# La zoxide moderna usa '__zoxide_*' (doble guion) y no colisiona. Requiere >= 0.5;
# ver install.sh, que la baja de GitHub porque la de apt está fosilizada.
eval "$(zoxide init --cmd cd zsh)"

# --- MODERN ALIASES ---
alias cat='bat'
alias ls='eza --icons'
alias ll='eza -l --icons --git'   # Lista detallada
alias la='eza -la --icons --git'  # Lista con ocultos
alias tree='eza --tree --icons'   # Árbol
alias update='sudo apt update && sudo apt upgrade'
alias ip='ip -c a'
alias cfile='xclip -selection clipboard <'
alias vfile='xclip -selection clipboard -o >'
alias copy='xclip -selection clipboard'
alias path='echo $PATH | tr ":" "\n"'
alias ports='sudo ss -tulanp'
alias myip='curl -s ifconfig.me && echo'

# --- NAVIGATION ---
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Alias finder configuration
ZSH_ALIAS_FINDER_AUTOMATIC=true

# --- POWERLEVEL10K CONFIG ---
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# --- FZF ---
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# bun completions
[ -s "/home/dbayona/.bun/_bun" ] && source "/home/dbayona/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
