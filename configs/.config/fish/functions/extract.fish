function extract
    if test (count $argv) -ne 1
        echo "Usage: extract <file>"
        return 1
    end

    set file $argv[1]

    if not test -f "$file"
        echo "File tidak ditemukan"
        return 1
    end

    switch $file
        case "*.tar.gz" "*.tgz"
            tar -xzf "$file"
        case "*.tar.bz2"
            tar -xjf "$file"
        case "*.tar.xz"
            tar -xJf "$file"
        case "*.zip"
            unzip "$file"
        case "*.rar"
            unrar x "$file"
        case "*"
            echo "Format tidak didukung"
    end
end
