if type -q starship
    function __starship_init --on-event fish_prompt
        functions -e __starship_init

        starship init fish | source
        # zoxide init fish | source
        # atuin init fish | source

        emit starship_ready
    end
end
