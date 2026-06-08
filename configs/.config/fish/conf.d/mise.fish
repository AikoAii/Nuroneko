#####################################
# MISE AUTO (FORCE CHECK)
#####################################

function __mise_auto
    if type -q mise
        if test -f .mise.toml -o -f .tool-versions
            if not set -q __mise_initialized
                set -g __mise_initialized 1
                mise activate fish | source
            end
        end
    end
end

# override cd 
function cd
    builtin cd $argv
    __mise_auto
end

# trigger awal
__mise_auto
