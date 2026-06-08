function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")

    yazi $argv --cwd-file="$tmp"

    if read -z cwd <"$tmp"; and test -n "$cwd"; and test "$cwd" != "$PWD"
        cd "$cwd"
    end

    rm -f "$tmp"
end
