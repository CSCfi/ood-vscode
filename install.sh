set -e
set +x

rm -rf bin extensions lib  temp_user_data  usr
mkdir temp_user_data

CODE_VERSION="4.16.1"
curl -#fL -o code-server-${CODE_VERSION}-amd64.rpm -C - https://github.com/coder/code-server/releases/download/v${CODE_VERSION}/code-server-${CODE_VERSION}-amd64.rpm
rpm2cpio code-server-${CODE_VERSION}-amd64.rpm | cpio -idmv  --no-absolute-filenames

mv usr/* .
rm -r usr
echo '#!/usr/bin/env sh' > bin/code-server
echo 'DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"' >> bin/code-server
echo 'exec $DIR/../lib/code-server/bin/code-server "$@"' >> bin/code-server
rm code-server-${CODE_VERSION}-amd64.rpm


JULIA_EXT_VER=1.38.2
PYTHON_EXT_VER=2023.4.1
JUPYTER_EXT_VER=2023.3.100

EXT_DIR="$PWD/lib/code-server/lib/vscode/extensions"
./bin/code-server --extensions-dir="$EXT_DIR" --user-data-dir="$PWD/temp_user_data" --verbose --install-extension ms-toolsai.jupyter@$JUPYTER_EXT_VER
./bin/code-server --extensions-dir="$EXT_DIR" --user-data-dir="$PWD/temp_user_data" --verbose --install-extension ms-python.python@$PYTHON_EXT_VER
./bin/code-server --extensions-dir="$EXT_DIR" --user-data-dir="$PWD/temp_user_data" --verbose --install-extension julialang.language-julia@$JULIA_EXT_VER

CPPTOOLS_VERSION="1.14.5"
curl -#fL -o cpptools-linux.vsix -C - https://github.com/microsoft/vscode-cpptools/releases/download/v${CPPTOOLS_VERSION}/cpptools-linux.vsix
./bin/code-server --extensions-dir="$EXT_DIR" --user-data-dir="$PWD/temp_user_data" --verbose --install-extension cpptools-linux.vsix


rm -r temp_user_data
rm -f cpptools-linux.vsix

chmod +x "$EXT_DIR/ms-vscode.cpptools-${CPPTOOLS_VERSION}/debugAdapters/bin/OpenDebugAD7"
chmod +x "$EXT_DIR/ms-vscode.cpptools-${CPPTOOLS_VERSION}/bin/cpptools"
chmod +x "$EXT_DIR/ms-vscode.cpptools-${CPPTOOLS_VERSION}/bin/cpptools-srv"
chmod +x "$EXT_DIR/ms-vscode.cpptools-${CPPTOOLS_VERSION}/bin/cpptools-wordexp"
chmod +x "$EXT_DIR/ms-vscode.cpptools-${CPPTOOLS_VERSION}/LLVM/bin/clang-format"
chmod +x "$EXT_DIR/ms-vscode.cpptools-${CPPTOOLS_VERSION}/LLVM/bin/clang-tidy"

# Default timeout is very short, increase to allow launching VSCode also when Lustre is slow
sed -i -e 's/const timeoutInterval = 10000/const timeoutInterval = 120000/' "$PWD/lib/code-server/out/node/wrapper.js"

# Jupyter extension assumes writeable installation directory for Jupyter kernel temporary files
sed -i 's/this.context.extensionUri,"temp"/this.platformService.homeDir,".cache","temp"/' "$PWD/lib/code-server/lib/vscode/extensions/ms-toolsai.jupyter-$JUPYTER_EXT_VER-universal/out/extension.node.js"
