# BASIC
alias cls="clear"
alias cl="clear"
alias q="exit"
alias reload="exec fish"
alias ttl65="sudo sysctl -w net.ipv4.ip_default_ttl=65"

# NAVIGATION
alias c="cd"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias h="cd ~"
alias prev="cd -"

# EDITOR
alias n="nvim"
alias m="micro"

# FILE & VIEW (EZA CONVERTED)
alias py="python"
alias gpp="g++"
alias ls="eza --icons"
alias l="eza -lah --icons --git"
alias la="eza -a --icons"
alias ll="eza -lh --icons --git"
alias lt="eza --tree --level=2 --icons"
alias b="bat"
alias z="zoxide"
alias mk="mkdir -pv"
alias drag="ripdrag"

# SEARCH & FIND
alias rg="rg --smart-case"
alias rgi="rg -i"
alias fd="fd --hidden --follow"
alias fda="fd -a"
alias ff="fd | fzf"

# SYSTEM
alias df="df -h"
alias du="dust -d 2"
alias dua="dust"
alias top="btop"
alias free="free -h"
alias ip="ip -c"
alias ports="ss -tulnp"
alias ps="procs"
alias psg="procs --watch"
alias pw="loginctl poweroff"
alias rbt="loginctl reboot"

# NETWORK / SSH
alias ssh="kitty +kitten ssh"
alias pi="gping google.com 1.1.1.1"
alias curl="curlie"

# DEV TOOLS
alias fast="fastfetch"
alias serve="python -m http.server"

# PACMAN (ARCH)
alias p="pacman"
alias qi="pacman -Qi"
alias qs="pacman -Qs"
alias rm-pkg="sudo pacman -Rns"
alias cleanpkg="sudo pacman -Sc"

# GIT
alias g="git"
alias gs="git status"
alias ga="git add ."
alias gA="git add -A"
alias gc="git commit"
alias gcm="git commit -m"
alias gp="git push"
alias gl="git pull"
alias gd="git diff"
alias gb="git branch"
alias gco="git checkout"
alias gcl="git clone"
alias glog="git log --oneline --graph --decorate"
alias gundo="git reset --soft HEAD~1"
alias gclean="git clean -fd"


# QUICK ACCESS
alias envs="env | sort"
alias cf="cd ~/.config/fish/config.fish"
alias cfa="nvim ~/.config/fish/conf.d/alias.fish"
alias hlp="tldr"

# TYPO GUARD
alias sl="ls"
alias cim="nvim"
alias chmox="chmod"
alias grpe="grep"
