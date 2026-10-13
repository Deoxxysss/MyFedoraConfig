# This includes my bashrc configuration
# Well i am using Fedora soo some commands or alias may differ from what you're using
# I use Gnome Terminal for this process
# open the Gnome Terminal 
# Write 'nano ~/.bashrc'
# Copy the following code and paste it
# Delete everthing that is already in that file 






# ============================================================
# ~/.bashrc
# Fedora / Bash configuration
# ============================================================

# ------------------------------------------------------------
# PS1 Prompt
# ------------------------------------------------------------
if [[ $- == *i* ]]; then
    PS1='\[\e[38;5;39m\]╭─[\[\e[38;5;141m\]\u\[\e[38;5;39m\]@\[\e[38;5;81m\]\h\[\e[38;5;39m\]]─[\[\e[38;5;215m\]\w\[\e[38;5;39m\]]\n\[\e[38;5;39m\]╰─➤ \[\e[38;5;255m\]'
fi


# ------------------------------------------------------------
# Environment
# ------------------------------------------------------------
export TERM=xterm-256color
export EDITOR=vim


# ------------------------------------------------------------
# History
# ------------------------------------------------------------

# Don't add duplicate lines or lines beginning with a space
# to the history
HISTCONTROL=ignoreboth

# Show timestamps in history
HISTTIMEFORMAT="%Y-%m-%d %T "


# ------------------------------------------------------------
# Bash options
# ------------------------------------------------------------

# Correct simple spelling mistakes when using cd
shopt -s cdspell


# ------------------------------------------------------------
# Add ~/bin to PATH
# ------------------------------------------------------------

if [ -d "$HOME/bin" ]; then
    case ":$PATH:" in
        *":$HOME/bin:"*) ;;
        *) PATH="$HOME/bin:$PATH" ;;
    esac
fi


# ------------------------------------------------------------
# tmux
# ------------------------------------------------------------

# Add tmuxifier to PATH if installed
if [ -d "$HOME/.tmux/tmuxifier/bin" ]; then
    case ":$PATH:" in
        *":$HOME/.tmux/tmuxifier/bin:"*) ;;
        *) PATH="$HOME/.tmux/tmuxifier/bin:$PATH" ;;
    esac
fi

# Enable tmux completion if installed
if [ -f "$HOME/.tmux/plugins/completion/tmux" ]; then
    source "$HOME/.tmux/plugins/completion/tmux"
fi

# Automatically start tmux
# Uncomment the following section if you want Bash
# to automatically enter tmux when opening a terminal.

# if command -v tmux >/dev/null 2>&1; then
#     if [[ $- == *i* ]] && [ -z "$TMUX" ]; then
#         tmux
#     fi
# fi


# ------------------------------------------------------------
# Command aliases
# ------------------------------------------------------------

# Navigation
alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias back='cd "$OLDPWD"'
alias cd..='cd ..'

# Basic commands
alias c='clear'
alias h='history'
alias j='jobs -l'

# File operations
alias cp='cp -iv'
alias mv='mv -iv'
alias ln='ln -i'
alias mkdir='mkdir -pv'

# Permissions
alias chmod='chmod --preserve-root'
alias chown='chown --preserve-root'
alias chgrp='chgrp --preserve-root'

# Disk usage
alias df='df -h --exclude=squashfs'

# Grep / diff
alias grep='grep --color=auto'

if command -v colordiff >/dev/null 2>&1; then
    alias diff='colordiff'
fi

# egrep is deprecated on many modern systems, so use grep -E
alias egrep='grep -E --color=auto'

# Vim
alias e='vim -O'
alias E='vim -o'
alias svim='sudo vim'

# ls
alias l.='ls -lhFa --time-style=long-iso --color=auto'
alias ll='ls -lah --time-style=long-iso --color=auto'
alias ls='ls -lhF --time-style=long-iso --color=auto'

# Mounts
alias lsmount='mount | column -t'

# Networking
alias extip='curl -s icanhazip.com'
alias ports='ss -tulnp'

# tmux
alias tn='tmux new -s'

# Miscellaneous
alias watch='watch -d'
alias weather='curl wttr.in'
alias wget='wget -c'

# Vagrant
alias vdestroy='vagrant destroy'
alias vssh='vagrant ssh'
alias vup='vagrant up'

# SSH agent
alias ssha='eval "$(ssh-agent -s)" && ssh-add'


# ------------------------------------------------------------
# Process monitoring
# ------------------------------------------------------------

# Top 5 / 10 processes by memory usage
alias mem5='ps auxf | sort -nr -k 4 | head -5'
alias mem10='ps auxf | sort -nr -k 4 | head -10'

# Top 5 / 10 processes by CPU usage
alias cpu5='ps auxf | sort -nr -k 3 | head -5'
alias cpu10='ps auxf | sort -nr -k 3 | head -10'


# ------------------------------------------------------------
# Largest directories
# ------------------------------------------------------------

alias dir5='du -cksh * 2>/dev/null | sort -hr | head -n 5'
alias dir10='du -cksh * 2>/dev/null | sort -hr | head -n 10'


# ------------------------------------------------------------
# Safety nets
# ------------------------------------------------------------

# Protect against accidentally deleting large numbers of files
# and protect the root directory.
alias rm='rm -I --preserve-root'


# ------------------------------------------------------------
# Reload bash configuration
# ------------------------------------------------------------

alias reload='source ~/.bashrc'


# ------------------------------------------------------------
# Fedora package management
# ------------------------------------------------------------

if command -v dnf >/dev/null 2>&1; then
    alias update='sudo dnf check-update'
    alias upgrade='sudo dnf upgrade'
    alias install='sudo dnf install'
    alias remove='sudo dnf remove'
fi


# ------------------------------------------------------------
# Functions
# ------------------------------------------------------------

# Make a directory and immediately enter it
md() {
    if [ -z "$1" ]; then
        echo "Usage: md <directory>"
        return 1
    fi

    mkdir -p "$1" && cd "$1"
}


# ------------------------------------------------------------
# Show PATH
# ------------------------------------------------------------

# Shows PATH one entry per line.
# If an argument is supplied, searches for it.
path() {
    if [ -n "$1" ]; then
        printf '%s\n' "$PATH" | tr ':' '\n' | grep -i -- "$1"
    else
        printf '%s\n' "$PATH" | tr ':' '\n'
    fi
}


# ------------------------------------------------------------
# Extract archives
# ------------------------------------------------------------

extract() {
    if [ -z "$1" ]; then
        echo "Usage: extract <file>"
        return 1
    fi

    if [ ! -f "$1" ]; then
        echo "'$1' is not a valid file"
        return 1
    fi

    case "$1" in
        *.tar.bz2) tar xjvf "$1" ;;
        *.tar.gz)  tar xzvf "$1" ;;
        *.tar.xz)  tar xJvf "$1" ;;
        *.tar.zst) tar --use-compress-program=unzstd -xvf "$1" ;;
        *.bz2)     bunzip2 "$1" ;;
        *.gz)      gunzip "$1" ;;
        *.tar)     tar xf "$1" ;;
        *.tbz2)    tar xjf "$1" ;;
        *.tgz)     tar xzf "$1" ;;
        *.zip)     unzip "$1" ;;
        *.Z)       uncompress "$1" ;;
        *.7z)      7z x "$1" ;;
        *.rar)     unrar x "$1" ;;
        *)
            echo "'$1' cannot be extracted via extract()"
            return 1
            ;;
    esac
}
export PATH="$HOME/.local/bin:$PATH"








# Now press Ctrl+O then Enter then Ctrl + X
# Now you will be in the terminal, now enter 'source ~/.bashrc' to reload the bash with new configuration
# The bash has a lot of good configurations, give it some time and read the code as it is made for efficiency more than anything
