#!/bin/bash

mode="$1"

get_cpu() {
    read -r _ u n s i w irq sirq st _ < /proc/stat
    local t1=$((u+n+s+i+w+irq+sirq+st))
    local i1=$((i+w))

    sleep 0.2

    read -r _ u n s i w irq sirq st _ < /proc/stat
    local t2=$((u+n+s+i+w+irq+sirq+st))
    local i2=$((i+w))

    local dt=$((t2 - t1))
    local di=$((i2 - i1))

    if [ "$dt" -le 0 ]; then
        echo "0"
    else
        echo $((100 * (dt - di) / dt))
    fi
}

get_ram() {
    local t=0 a=0
    while read -r k v _; do
        case $k in
            MemTotal:) t=$v ;;
            MemAvailable:) a=$v; break ;;
        esac
    done < /proc/meminfo

    local used=$((t - a))
    awk 'BEGIN {printf "%.1f", '$used'/1024/1024}'
}

get_temp() {
    for hw in /sys/class/hwmon/hwmon*; do
        [ -f "$hw/name" ] || continue
        local name
        name=$(cat "$hw/name" 2>/dev/null)
        case "$name" in
            coretemp|k10temp|zenpower|cpu*)
                for t in "$hw"/temp*_input; do
                    [ -f "$t" ] || continue
                    echo $(( $(cat "$t") / 1000 ))
                    return 0
                done
                ;;
        esac
    done
    echo "N/A"
}

case "$mode" in
    cpu)
        cpu=$(get_cpu)
        printf '{"text":" %d%%","tooltip":"CPU Usage: %d%%"}\n' "$cpu" "$cpu"
        ;;
    ram)
        ram=$(get_ram)
        printf '{"text":"  %s GB","tooltip":"RAM Used: %s GB"}\n' "$ram" "$ram"
        ;;
    temp)
        temp=$(get_temp)
        printf '{"text":" %s°C","tooltip":"Core Temperature: %s°C"}\n' "$temp" "$temp"
        ;;
    *)
        cpu=$(get_cpu)
        ram=$(get_ram)
        temp=$(get_temp)
        printf '{"text":" %d%%    %s GB   %s°C"}\n' "$cpu" "$ram" "$temp"
        ;;
esac
