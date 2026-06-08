# wget (XDG safe)
function wget
    set -l hsts_dir "$XDG_DATA_HOME"
    set -l hsts_file "$hsts_dir/wget-hsts"

    if not test -d "$hsts_dir"
        mkdir -p "$hsts_dir"
    end

    command wget --hsts-file="$hsts_file" $argv
end
