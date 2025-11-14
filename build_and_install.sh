#!/usr/bin/env bash

set -euo pipefail

# Run from script location (project root)
cd "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

TARGET="./installation/bin/kitty"

if [ -f "$TARGET" ]; then
  # Use file modification time of the binary for the timestamp
  TS=$(date -r "$TARGET" +%Y-%m-%d-%H-%M-%S)
  BACKUP_DIR="./installation_${TS}"

  # If backup dir already exists, avoid clobbering by appending an index
  if [ -e "$BACKUP_DIR" ]; then
    i=1
    while [ -e "${BACKUP_DIR}_$i" ]; do
      i=$((i + 1))
    done
    BACKUP_DIR="${BACKUP_DIR}_$i"
  fi

  echo "Backing up ./installation -> $BACKUP_DIR"
  cp -a ./installation "$BACKUP_DIR"
  echo "Backup complete."
else
  echo "No existing $TARGET found. Skipping backup."
fi

echo "Running build/install:"
echo "env -u PYTHONMULTIPROCESSING_SPAWN python3 setup.py linux-package --prefix=./installation"
env -u PYTHONMULTIPROCESSING_SPAWN python3 setup.py linux-package --prefix=./installation
