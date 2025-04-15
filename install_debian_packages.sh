#!/bin/bash

set -e

if [ $# -lt 1 ]; then
  echo "Usage: $0 path/to/package-list.txt"
  exit 1
fi

FILE="$1"

if [[ ! -f "$FILE" ]]; then
  echo "Error: File '$FILE' not found."
  exit 1
fi

echo "Using package list file: $FILE"
echo "Updating package list..."
apt-get update -y

packages=()
while IFS= read -r line; do
  line=$(echo "$line" | xargs)
  if [[ -n "$line" && ! "$line" =~ ^# ]]; then
    packages+=("$line")
  fi
done < "$FILE"

if [ ${#packages[@]} -eq 0 ]; then
  echo "No packages to install."
else
  echo "Installing packages: ${packages[*]}"
  apt-get install -y "${packages[@]}"
fi

rm -rf /var/lib/apt/lists/*