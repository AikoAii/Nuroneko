if status --is-interactive
    function __pokemon_once --on-event fish_prompt
        functions -e __pokemon_once
        if type -q pokemon-colorscripts
            pokemon-colorscripts --no-title -s -r 1,3,6
        end
    end
end
