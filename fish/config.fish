# Common paths (Fish safely ignores non-existent paths)
fish_add_path ~/.cargo/bin ~/.local/bin

# OS-specific paths and tools
switch (uname)
    case Darwin
        # macOS (MacBook Air)
        fish_add_path /opt/homebrew/bin
        if test -x /opt/homebrew/bin/brew
            eval (/opt/homebrew/bin/brew shellenv)
        end
    case Linux
        # KDE SuiPlay0x1 (supports Linuxbrew if installed)
        if test -x /home/linuxbrew/.linuxbrew/bin/brew
            eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
        end

        # Linux compatibility wrappers for macOS pbcopy / pbpaste
        if not command -q pbcopy
            function pbcopy --description "Copy stdin to clipboard on Linux"
                if set -q WAYLAND_DISPLAY; and command -q wl-copy
                    wl-copy $argv
                else if command -q xclip
                    xclip -selection clipboard $argv
                else if command -q xsel
                    xsel --clipboard --input $argv
                end
            end
        end

        if not command -q pbpaste
            function pbpaste --description "Paste clipboard to stdout on Linux"
                if set -q WAYLAND_DISPLAY; and command -q wl-paste
                    wl-paste $argv
                else if command -q xclip
                    xclip -selection clipboard -o $argv
                else if command -q xsel
                    xsel --clipboard --output $argv
                end
            end
        end
end

# Environment variables
set -gx STARSHIP_CONFIG ~/.config/starship/starship.toml
set -gx OLLAMA_HOST "http://192.168.0.179:11434"

# Vi mode (use -g instead of -U in config.fish to prevent sync conflicts)
set -g fish_key_bindings fish_vi_key_bindings

# Interactive prompt & tools
if status is-interactive
    if command -q starship
        starship init fish | source
    end
    if command -q zoxide
        zoxide init fish | source
    end
end

# Disable welcome greeting
function fish_greeting
end

# eza aliases
if command -q eza
    alias ls 'eza -lh --group-directories-first --icons=auto'
    alias lsa 'ls -a'
    alias lt 'eza --tree --level=2 --long --icons --git'
    alias lta 'lt -a'
end

# Reload & sync config
function reload
    source ~/.config/fish/config.fish
    and echo "config reloaded"
end

function dotsync --description "Sync dotfiles with GitHub"
    set -l prev_dir (pwd)
    cd ~/dotfiles
    git pull --rebase
    if test -n "$(git status --porcelain)"
        git add .
        git commit -m "Sync from "(hostname)
        git push
    end
    cd $prev_dir
    source ~/.config/fish/config.fish
    echo "Dotfiles synced and reloaded!"
end

# Config shortcuts
function fcf
    nvim ~/.config/fish/config.fish
end

function kcf
    nvim ~/.config/kitty/kitty.conf
end

function scf
    nvim ~/.config/starship/starship.toml
end

function yzcf
    nvim ~/.config/yazi/yazi.toml
end

# Fastfetch & Yazi shortcuts
function fe
    fastfetch
end

function yz
    yazi
end

# macOS-only tools (AeroSpace & Mole)
if test (uname) = Darwin
    function acf
        nvim ~/.config/aerospace/aerospace.toml
    end

    function mostats --description "mo status" --wraps "mo status"
        mo status
    end

    function moclean --description "mo clean" --wraps "mo clean"
        mo clean
    end

    function mouni --description "mo uninstall" --wraps "mo uninstall"
        mo uninstall
    end
end

# Homebrew shortcuts (loads automatically if brew is installed on macOS or Linux)
if command -q brew
    function bi --description "brew install" --wraps "brew install"
        brew install $argv
    end

    function bs --description "brew search" --wraps "brew search"
        brew search $argv
    end

    function bu --description "brew update + upgrade" --wraps "brew upgrade"
        brew update
        brew upgrade $argv
    end

    function br --description "brew uninstall" --wraps "brew uninstall"
        brew uninstall $argv
    end

    function bl --description "brew list" --wraps "brew list"
        brew list $argv
    end

    function bc --description "brew cleanup" --wraps "brew cleanup"
        brew cleanup $argv
    end
end
