function __keybinds_init --on-event fzf_ready
    functions -e __keybinds_init

    bind \cf 'set file (fd | fzf); and nvim $file'
    bind \cg 'git status'
    bind \cp 'cd (fd -t d | fzf)'
    bind \ch 'history | fzf'
    bind \ck 'kill -9 (ps aux | fzf | awk "{print \$2}")'
end
