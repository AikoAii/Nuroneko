# CORE
set fish_greeting

# MISE 

set -gx PATH (string split " " $PATH | uniq)

set -x TLDR_COLOR_NAME magenta
set -x TLDR_COLOR_DESCRIPTION white
set -x TLDR_COLOR_EXAMPLE cyan
set -x TLDR_COLOR_COMMAND red

if status is-interactive
    ulimit -c 0
end

fish_add_path -m ~/.local/bin
