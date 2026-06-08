function timer
    if test (count $argv) -ne 1
        echo "Usage: timer <seconds>"
        return 1
    end

    sleep $argv[1]
    echo "⏰ Time's up!"
end
