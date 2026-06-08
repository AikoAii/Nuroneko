#!/bin/bash

TMP="/tmp/ocr-shot.png"

notify() {
    notify-send -i edit-paste "OCR" "$1"
}

grim -g "$(slurp)" "$TMP" || exit 1

TEXT=$(tesseract "$TMP" stdout -l eng 2>/dev/null)

rm -f "$TMP"

if [[ -z "$TEXT" ]]; then
    notify "No text detected"
    exit 1
fi

echo "$TEXT" | wl-copy

notify "Text copied"
