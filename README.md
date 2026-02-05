# 🔧 Mis Dotfiles (Linux)

Configuración de entorno de desarrollo profesional ("Senior Dev Setup") para sistemas Linux (incluyendo WSL + Ubuntu 24.04).
Incluye configuración para **Zsh, Tmux, Neovim/Vim, Git**, **Node.js LTS**, **Docker** y el stack moderno de herramientas en Rust/Python.

---

## 🚀 Instalación Rápida

Si me mudo a un PC nuevo o formateo, solo necesito ejecutar esto:

```bash
# 1. Clonar el repositorio
git clone https://github.com/bayoneitor/dotfiles.git ~/dotfiles

# 2. Dar permisos y ejecutar el script maestro
chmod +x ~/dotfiles/install.sh
~/dotfiles/install.sh

# 3. Reiniciar terminal
source ~/.zshrc
```

El script se encargará de:
* Instalar todas las dependencias (zsh, tmux, uv, eza, xclip, etc.).
* Instalar Oh My Zsh, plugins y el tema Powerlevel10k.
* Crear los enlaces simbólicos usando `stow`.
* **Configurar Git:** Te preguntará tu nombre y email y los guardará en `~/.gitconfig.local` (protegiendo tu privacidad).
* **Extras:** Te dará opción a instalar Docker y Docker Compose.

> [!TIP]
> **Privacidad y Configuración Local:**
> El archivo `~/.gitconfig.local` se genera automáticamente y **no se sube al repositorio**. Úsalo para añadir configuraciones específicas de esta máquina (como claves GPG o alias extra) sin afectar tus dotfiles públicos.

## ⚡ El Arsenal (Tu Stack de Herramientas)

### 📂 Navegación y Archivos

*   **Eza** (Mejora moderna de `ls`)
    *   *Reemplaza a:* `ls` (listar archivos).
    *   *Alias incluido:* Si escribes `ls`, el sistema ejecutará `eza` automáticamente.
    *   *Ejemplo Básico:*
        ```bash
        eza -l --icons  # Lista con detalles e iconos
        ```
    *   *Ejemplo Avanzado:*
        ```bash
        eza --tree --level=2  # Ver estructura de árbol (como 'tree')
        ```

*   **Bat** (Mejora moderna de `cat`)
    *   *Reemplaza a:* `cat` (leer archivos).
    *   *Alias incluido:* Si escribes `cat`, el sistema ejecutará `bat` automáticamente.
    *   *Ejemplo Básico:*
        ```bash
        bat install.sh  # Lee archivo con colores y paginación
        ```

*   **Zoxide** (Mejora inteligente de `cd`)
    *   *Reemplaza a:* `cd` (cambiar directorio).
    *   *Comando:* Usa `z` para saltar entre carpetas.
    *   *Ejemplo Básico:*
        ```bash
        z pro  # Salta a la mejor coincidencia (ej. ~/proyectos)
        ```
    *   *Ejemplo Interactivo:*
        ```bash
        zi     # Abre un buscador para elegir dónde ir
        ```

*   **Ripgrep** (Mejora rápida de `grep`)
    *   *Reemplaza a:* `grep` (buscar texto).
    *   *Comando:* `rg`
    *   *Ejemplo Básico:*
        ```bash
        rg "TODO"  # Busca "TODO" en todos los archivos (ignora node_modules)
        ```

*   **FZF** (Fuzzy Finder)
    *   *Reemplaza a:* Buscar en el historial a ojo.
    *   *Uso:* Pulsa `Ctrl + R` en la terminal para buscar comandos pasados.
    *   *Comando avanzado:*
        ```bash
        fzf --preview 'bat {}'  # Buscador de archivos con vista previa
        ```

*   **NCDU** (Analizador de disco)
    *   *Reemplaza a:* `du -h` (ver tamaño de carpetas).
    *   *Comando:* `ncdu`
    *   *Ejemplo:*
        ```bash
        ncdu  # Navega por tus carpetas para ver qué ocupa espacio
        ```

### 💻 Desarrollo y Control de Versiones

*   **Lazygit** (Interfaz Git)
    *   *Reemplaza a:* Comandos git manuales complejos.
    *   *Comando:* `lazygit`
    *   *Uso:* Abre una interfaz visual para hacer stage, commit, push y resolver conflictos.

*   **UV** (Gestor de Python)
    *   *Reemplaza a:* `pip` y `virtualenv` (es mucho más rápido).
    *   *Comando:* `uv`
    *   *Ejemplo:*
        ```bash
        uv pip install requests  # Instala librería a la velocidad de la luz
        ```

*   **Node.js + NVM**
    *   *Gestión:* Usamos `nvm` para manejar versiones de Node.
    *   *Comando:* `nvm install --lts` (Instala la última versión estable).

*   **Docker** (Contenedores)
    *   *Uso estándar:*
        ```bash
        docker compose up -d  # Levanta tu entorno de desarrollo
        ```

### 🌐 Redes y Datos

*   **Xh** (Mejora amigable de `curl`)
    *   *Reemplaza a:* `curl` (peticiones HTTP).
    *   *Comando:* `xh`
    *   *Ejemplo GET:*
        ```bash
        xh httpbin.org/get  # Petición simple con colores
        ```
    *   *Ejemplo POST:*
        ```bash
        xh POST httpbin.org/post nombre=juan activo:=true
        ```

*   **JQ** (Procesador JSON)
    *   *Uso:* Formatear y filtrar salidas JSON.
    *   *Ejemplo:*
        ```bash
        cat data.json | jq  # Hace legible un JSON minificado
        ```

### 🛠️ Sistema

*   **Btop** (Mejora visual de `top`)
    *   *Reemplaza a:* `top` o `htop` (monitor de recursos).
    *   *Comando:* `btop`
    *   *Uso:* Interfaz gráfico para ver CPU, RAM y matar procesos con el ratón.

*   **Tldr** (Mejora simplificada de `man`)
    *   *Reemplaza a:* `man` (manuales largos y confusos).
    *   *Comando:* `tldr`
    *   *Ejemplo:*
        ```bash
        tldr tar  # Te muestra ejemplos prácticos de cómo usar tar
        ```

## 🎨 Fuentes Incluidas

Se han incluido dos tipografías esenciales para una experiencia de terminal moderna:

*   **MesloLGS NF**: La fuente recomendada para el tema Powerlevel10k de Zsh (incluye todos los iconos).
*   **Cascadia Code**: La fuente moderna de Microsoft compatible con ligaduras.

*Estas fuentes se instalan automáticamente en `~/.local/share/fonts` al ejecutar el script.*

## 🐙 Tmux Cheat Sheet

Gestor de ventanas y sesiones. Permite que los procesos sigan vivos aunque cierre la terminal.

**Prefijo Global:** `Ctrl + a` (Cambiado, el original era `Ctrl+b`)

### 🔌 Mantenimiento de Plugins (¡Importante!)

Tmux usa TPM (Tmux Plugin Manager). Así es como gestiono los plugins (temas, etc.):

| Acción | Atajo | Explicación |
| :--- | :--- | :--- |
| **Instalar Plugins** | `Prefix + I` (Shift + i) | Usar la primera vez o al añadir líneas a `.tmux.conf`. |
| **Actualizar Plugins** | `Prefix + U` (Shift + u) | Usar si quiero actualizar el tema o plugins existentes. |
| **Recargar Config** | `Prefix + r` | Usar si cambio colores o atajos simples. |

### 🪟 Control de Ventanas

| Acción | Atajo |
| :--- | :--- |
| **Dividir Vertical** | `Prefix + |` |
| **Dividir Horizontal** | `Prefix + -` |
| **Zoom Panel** | `Prefix + z` (Maximiza panel actual, repetir para volver) |
| **Cerrar Panel** | `Prefix + x` |
| **Moverse (Mouse)** | Click en el panel deseado |
| **Nueva Pestaña** | `Prefix + c` |
| **Siguiente/Anterior** | `Prefix + n / p` |
| **Listar Ventanas** | `Prefix + w` (Visual) |
| **Salir (Detach)** | `Prefix + d` (Deja todo corriendo en segundo plano) |

**Recuperar sesión cerrada:**
```bash
tmux a
```

## 📝 Vim Configuración

Se incluye una configuración simple pero efectiva en `~/.vimrc`:
*   **Números de línea** y coloreado de sintaxis activados.
*   **Soporte de Ratón:** Puedes hacer clic para mover el cursor y usar la rueda para scroll.
*   **Portapapeles Compartido:** Gracias a `set clipboard=unnamedplus`, lo que copies en Vim se puede pegar en Windows/Linux.

## 🐚 Trucos Extra de Zsh

Aquí tienes funcionalidades mágicas que no son comandos per se:

### Sudo Mágico:
* Si escribo un comando y falla por permisos, pulso `Esc` dos veces. Se añade `sudo` al principio automáticamente.

### Web Search:
* `google error python wsl` -> Abre el navegador en Windows con la búsqueda.

### ⚡ Resumen de Atajos Rápidos
* `ls` -> `eza --icons`
* `ll` -> `eza -l --icons --git`
* `cat` -> `bat`
* `update` -> `sudo apt update && sudo apt upgrade`
* `cfile` -> `xclip -selection clipboard <` (Copiar archivo al portapapeles)
* `vfile` -> `xclip -selection clipboard -o >` (Pegar portapapeles a archivo)
* `copy` -> `xclip -selection clipboard` (Ej: `ls -la | copy` - Copia salida de comando)
* `path` -> Ver `$PATH` uno por línea
* `ports` -> Ver puertos escuchando (`sudo`)
* `myip` -> Ver IP pública
* `..`, `...`, `....` -> Navegación rápida de directorios

