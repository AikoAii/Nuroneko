function in
    if test (count $argv) -eq 0
        echo "Usage: in <package>"
        return 1
    end
    sudo pacman -S $argv
end
