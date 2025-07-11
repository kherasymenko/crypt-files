#!/bin/bash

# Проверка аргументов
if [ $# -ne 2 ]; then
    echo "Error: incorrect arguments." >&2
    echo "For encryption use: $0 e filename" >&2
    echo "For decryption use: $0 d filename.enc" >&2
    exit 1
fi

operation="$1"
inFile="$2"

# Проверка существования файла
if [ ! -f "$inFile" ]; then
    echo "Error: file '$inFile' not found." >&2
    exit 1
fi

case "$operation" in
    e)
        outFile="$inFile.enc"
        echo "Starting encryption..."
        openssl aes-256-cbc -a -salt -pbkdf2 -in "$inFile" -out "$outFile"
        ;;
    d)
        if [[ "$inFile" != *.enc ]]; then
            echo "Error: input file must have .enc extension for decryption." >&2
            exit 1
        fi
        outFile="${inFile%.enc}"
        echo "Starting decryption..."
        openssl aes-256-cbc -d -a -salt -pbkdf2 -in "$inFile" -out "$outFile"
        ;;
    *)
        echo "Error: invalid operation '$operation'. Use 'e' (encrypt) or 'd' (decrypt)." >&2
        exit 1
        ;;
esac

echo "Done."

