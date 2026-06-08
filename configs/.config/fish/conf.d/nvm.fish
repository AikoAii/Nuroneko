function nvm --description "Node version manager (clean full)"

    # handle silent flag
    for silent in --silent -s
        if set --local index (contains --index -- $silent $argv)
            set --erase argv[$index]
            set silent 1
            break
        end
    end

    set --local cmd $argv[1]
    set --local ver $argv[2]

    # validasi awal (fix syntax fish)
    if set --query silent; and not set --query cmd[1]
        echo "nvm: Version number not specified (see nvm -h)" >&2
        return 1
    end

    # 🔥 FIX: hanya baca .nvmrc saat explicit "nvm use"
    if test "$cmd" = "use"; and not set --query ver[1]
        for file in .nvmrc .node-version
            set file (_nvm_find_up $PWD $file)
            if test -n "$file"
                read ver < $file
                break
            end
        end

        if not set --query ver[1]
            echo "nvm: Invalid version or missing .nvmrc" >&2
            return 1
        end
    end

    set --local their_version $ver

    switch "$cmd"

        case -v --version
            echo "nvm, version 2.2.18 (clean)"

        case "" -h --help
            echo "Usage: nvm install <version>"
            echo "       nvm use <version>"
            echo "       nvm use              (read .nvmrc)"
            echo "       nvm list"
            echo "       nvm uninstall <version>"

        case install
            _nvm_index_update

            string match --entire --regex -- (_nvm_version_match $ver) <$nvm_data/.index | read ver alias

            if not set --query ver[1]
                echo "nvm: Invalid version \"$their_version\"" >&2
                return 1
            end

            if test not -e $nvm_data/$ver
                set --local os (uname -s | string lower)
                set --local arch (uname -m)

                set --local dir "node-$ver-$os-$arch"
                set --local url "$nvm_mirror/$ver/$dir.tar.gz"

                mkdir -p $nvm_data/$ver

                if not set --query silent
                    echo "Installing Node $ver"
                    echo "Fetching $url"
                end

                if not curl -q $silent --location $url | tar -xz -C $nvm_data/$ver 2>/dev/null
                    rm -rf $nvm_data/$ver
                    echo "nvm: download failed: $url" >&2
                    return 1
                end

                mv $nvm_data/$ver/$dir/* $nvm_data/$ver 2>/dev/null
                rm -rf $nvm_data/$ver/$dir
            end

            if test "$ver" != "$nvm_current_version"
                set --query nvm_current_version; and _nvm_version_deactivate $nvm_current_version
                _nvm_version_activate $ver
            end

            echo "Now using Node $ver"

        case use
            if test "$ver" = "default"
                set ver $nvm_default_version
            end

            _nvm_list | string match --entire --regex -- (_nvm_version_match $ver) | read ver __

            if not set --query ver[1]
                echo "nvm: Can't use Node \"$their_version\", version must be installed first" >&2
                return 1
            end

            if test "$ver" != "$nvm_current_version"
                set --query nvm_current_version; and _nvm_version_deactivate $nvm_current_version
                test "$ver" != system; and _nvm_version_activate $ver
            end

            echo "Now using Node $ver"

        case uninstall
            if test -z "$ver"
                echo "nvm: Not enough arguments" >&2
                return 1
            end

            _nvm_version_deactivate $ver
            rm -rf $nvm_data/$ver

            echo "Uninstalled Node $ver"

        case current
            _nvm_current

        case ls list
            _nvm_list | _nvm_list_format (_nvm_current) $argv[2]

        case lsr {ls,list}-remote
            _nvm_index_update || return
            _nvm_list | command awk '
                FILENAME == "-" && (is_local[$1] = FNR == NR) { next }
                { print $0 (is_local[$1] ? " ✓" : "") }
            ' - $nvm_data/.index | _nvm_list_format (_nvm_current) $argv[2]

        case '*'
            echo "nvm: Unknown command \"$cmd\"" >&2
            return 1
    end
end
