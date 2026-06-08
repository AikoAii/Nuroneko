function note
    set file ~/notes.txt

    if test (count $argv) -gt 0
        echo (date "+%F %T")" | $argv" >>$file
    end

    nvim $file
end
