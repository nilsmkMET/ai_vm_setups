#!/bin/bash

PATH_TO_CONTENT="generate_blob"
if [ -d "$HOME/Desktop/Git/ai_vm_setups/setup_encrypted_blob" ]; then
    PATH_TO_BLOB="$HOME/Desktop/Git/ai_vm_setups/setup_encrypted_blob"
elif [ -d "$HOME/Desktop/Git/setups/setup_encrypted_blob" ]; then
    PATH_TO_BLOB="$HOME/Desktop/Git/setups/setup_encrypted_blob"
else
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    PATH_TO_BLOB="$SCRIPT_DIR/setup_encrypted_blob"
fi
BLOB_BASENAME="blob"

zip -r "${PATH_TO_BLOB}/${BLOB_BASENAME}.zip" "${PATH_TO_CONTENT}"
gpg --output "${PATH_TO_BLOB}/${BLOB_BASENAME}.zip.gpg" --symmetric "${PATH_TO_BLOB}/${BLOB_BASENAME}.zip"
rm "${PATH_TO_BLOB}/${BLOB_BASENAME}.zip"

