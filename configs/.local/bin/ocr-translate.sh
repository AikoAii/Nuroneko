#!/bin/bash

TMP="/tmp/ocr-translate.png"

notify() {
    notify-send -i edit-paste "OCR Translate" "$1"
}

# Select area screenshot
grim -g "$(slurp)" "$TMP" || exit 1

# OCR
TEXT=$(tesseract "$TMP" stdout -l eng 2>/dev/null)

rm -f "$TMP"

# Empty check
if [[ -z "$TEXT" ]]; then
    notify "No text detected"
    exit 1
fi

# Translate to Indonesian
RESULT=$(trans -brief :id "$TEXT" 2>/dev/null)

# Copy result
echo "$RESULT" | wl-copy

notify "Translated text copied"
