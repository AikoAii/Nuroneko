function mkcd
    if test (count $argv) -eq 0
        echo "Usage: mkcd <folder>"
        return 1
    end
    mkdir -p $argv[1]
    and cd $argv[1]
end
