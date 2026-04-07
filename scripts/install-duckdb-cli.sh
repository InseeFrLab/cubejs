#!/bin/bash
set -e

ARCH=$(uname -m)

case $ARCH in
    "x86_64")
        FILENAME="duckdb_cli-linux-amd64.zip"
        ;;
    "aarch64")
        FILENAME="duckdb_cli-linux-aarch64.zip"
        ;;
    *)
        echo "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

echo "Downloading $FILENAME..."
wget -O "$FILENAME" "https://github.com/duckdb/duckdb/releases/download/v1.4.4/$FILENAME"


echo "Trying to unzip..."
unzip -l "$FILENAME" || { echo "Unzip failed. File might be corrupted or invalid."; cat "$FILENAME"; exit 1; }

unzip "$FILENAME" -d /usr/local/bin/

# Optional: Make sure it's executable

rm "$FILENAME"

