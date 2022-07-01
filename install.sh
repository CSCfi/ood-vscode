#!/bin/bash

# This should be run where code-server is intended to be installed, not in the OOD app root
set -e
set +x

rm -rf bin extensions lib  temp_user_data  usr

CODE_VERSION="4.4.0"
curl -#fL -o code-server-${CODE_VERSION}-amd64.rpm -C - https://github.com/coder/code-server/releases/download/v${CODE_VERSION}/code-server-${CODE_VERSION}-amd64.rpm
rpm2cpio code-server-${CODE_VERSION}-amd64.rpm | cpio -idmv  --no-absolute-filenames

mv usr/* .
rm -r usr
echo '#!/usr/bin/env sh' > bin/code-server
echo 'DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"' >> bin/code-server
echo 'exec $DIR/../lib/code-server/bin/code-server "$@"' >> bin/code-server
rm code-server-${CODE_VERSION}-amd64.rpm

# Make VSCode accept any capitalization on upgrade header (required by Apache mod_proxy_wstunnel)
file_to_patch="lib/code-server/lib/vscode/out/vs/server/node/server.main.js"
sed -i 's#headers\.upgrade!=="websocket"#headers.upgrade.toLowerCase()!=="websocket"#g' "$file_to_patch"

