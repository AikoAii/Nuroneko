function netcheck
    ping -c 1 8.8.8.8 >/dev/null && echo Online || echo Offline
end
