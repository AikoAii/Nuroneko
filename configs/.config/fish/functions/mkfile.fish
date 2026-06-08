# create file + open
function mkfile
    if test (count $argv) -ne 1
        echo "Usage: mkfile <filename>"
        return 1
    end

    touch "$argv[1]"; and nvim "$argv[1]"
end
