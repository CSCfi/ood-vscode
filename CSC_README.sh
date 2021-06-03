#!/bin/bash
# This can also be installed inside a container, but then we need to jump trough some extra hoops 
# to make sure that the compiling environment is correctly setup
set -e
set +x

curl -#fL -o code-server-3.9.3-amd64.rpm -C - https://github.com/cdr/code-server/releases/download/v3.9.3/code-server-3.9.3-amd64.rpm
rpm2cpio code-server-3.9.3-amd64.rpm | cpio -idmv  --no-absolute-filenames

mv usr/* .
rm -r usr
echo '#!/usr/bin/env sh' > bin/code-server
echo 'DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"' >> bin/code-server
echo 'exec $DIR/../lib/code-server/bin/code-server "$@"' >> bin/code-server
rm code-server-3.9.3-amd64.rpm

## Note! 
# lib/code-server/out/node/http.js
#  needs to be patched to work with ood
# Change one relative redirect (around line 97) 
#    if (redirectPath == "./") {
#        redirectPath = "/"
#    }
