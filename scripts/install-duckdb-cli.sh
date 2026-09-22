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

DUCKDB_NODE_VERSION=$(
  awk '
    /^"@duckdb\/node-api@/ { found=1; next }
    found && /^  version / {
      gsub(/"/, "", $2)
      print $2
      exit
    }
  ' /cube/yarn.lock
)

# 1.5.5-r.5 -> 1.5.5
DUCKDB_VERSION="${DUCKDB_NODE_VERSION%%-r.*}"

if [ -z "$DUCKDB_VERSION" ]; then
  echo "ERROR: impossible de déterminer la version de DuckDB depuis yarn.lock" >&2
  exit 1
fi

echo "DuckDB Node version: $DUCKDB_NODE_VERSION"
echo "DuckDB version:      $DUCKDB_VERSION"

FILENAME="duckdb_cli-linux-amd64.zip"

echo "Downloading $FILENAME..."
wget -O "$FILENAME" \
  "https://github.com/duckdb/duckdb/releases/download/v${DUCKDB_VERSION}/${FILENAME}"


echo "Trying to unzip..."
unzip -l "$FILENAME" || { echo "Unzip failed. File might be corrupted or invalid."; cat "$FILENAME"; exit 1; }

unzip "$FILENAME" -d /usr/local/bin/

# Optional: Make sure it's executable

rm "$FILENAME"

