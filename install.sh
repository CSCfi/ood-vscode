#!/bin/bash

# This should be run where code-server is intended to be installed, not in the OOD app root
set -e
set +x

rm -rf bin extensions lib  temp_user_data  usr

CODE_VERSION="4.6.1"
curl -#fL -o code-server-${CODE_VERSION}-amd64.rpm -C - https://github.com/coder/code-server/releases/download/v${CODE_VERSION}/code-server-${CODE_VERSION}-amd64.rpm
rpm2cpio code-server-${CODE_VERSION}-amd64.rpm | cpio -idmv  --no-absolute-filenames

mv usr/* .
rm -r usr
echo '#!/usr/bin/env sh' > bin/code-server
echo 'DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"' >> bin/code-server
echo 'exec $DIR/../lib/code-server/bin/code-server "$@"' >> bin/code-server
rm code-server-${CODE_VERSION}-amd64.rpm

EXT_DIR="$PWD/lib/code-server/lib/vscode/extensions"

# Fetch Jupyter and Python extensions from the store
./bin/code-server --extensions-dir="$EXT_DIR" --user-data-dir="$PWD/temp_user_data" --verbose --install-extension ms-toolsai.jupyter
./bin/code-server --extensions-dir="$EXT_DIR" --user-data-dir="$PWD/temp_user_data" --verbose --install-extension ms-python.python

CPPTOOLS_VERSION="1.12.4"
curl -#fL -o cpptools-linux.vsix -C - https://github.com/microsoft/vscode-cpptools/releases/download/v${CPPTOOLS_VERSION}/cpptools-linux.vsix
./bin/code-server --extensions-dir="$EXT_DIR" --user-data-dir="$PWD/temp_user_data" --verbose --install-extension cpptools-linux.vsix
rm cpptools-linux.vsix

rm -r temp_user_data

# cpptools assumes write mounted FS for first launch
# deps should be installed already, just need to chmod and add to package.json activationEvents
# see https://github.com/microsoft/vscode-cpptools/blob/ef52c25aa6b12f2aa810388ba45177b75468443b/Extension/src/main.ts#L206
chmod +x "$EXT_DIR/ms-vscode.cpptools-${CPPTOOLS_VERSION}/debugAdapters/bin/OpenDebugAD7"
chmod +x "$EXT_DIR/ms-vscode.cpptools-${CPPTOOLS_VERSION}/bin/cpptools"
chmod +x "$EXT_DIR/ms-vscode.cpptools-${CPPTOOLS_VERSION}/bin/cpptools-srv"
chmod +x "$EXT_DIR/ms-vscode.cpptools-${CPPTOOLS_VERSION}/bin/cpptools-wordexp"
chmod +x "$EXT_DIR/ms-vscode.cpptools-${CPPTOOLS_VERSION}/LLVM/bin/clang-format"
chmod +x "$EXT_DIR/ms-vscode.cpptools-${CPPTOOLS_VERSION}/LLVM/bin/clang-tidy"
