#!/bin/bash

# This should be run where code-server is intended to be installed, not in the OOD app root
set -e
set +x

rm -rf bin extensions lib  temp_user_data  usr

CODE_VERSION="3.12.0"
curl -#fL -o code-server-${CODE_VERSION}-amd64.rpm -C - https://github.com/coder/code-server/releases/download/v${CODE_VERSION}/code-server-${CODE_VERSION}-amd64.rpm
rpm2cpio code-server-${CODE_VERSION}-amd64.rpm | cpio -idmv  --no-absolute-filenames

mv usr/* .
rm -r usr
echo '#!/usr/bin/env sh' > bin/code-server
echo 'DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"' >> bin/code-server
echo 'exec $DIR/../lib/code-server/bin/code-server "$@"' >> bin/code-server
rm code-server-${CODE_VERSION}-amd64.rpm

export SERVICE_URL=https://open-vsx.org/vscode/gallery
export ITEM_URL=https://open-vsx.org/vscode/item

# Fetch Jupyter and Python extensions from the store
./bin/code-server --extensions-dir="$PWD/extensions" --user-data-dir="$PWD/temp_user_data" --verbose --install-extension ms-toolsai.jupyter
./bin/code-server --extensions-dir="$PWD/extensions" --user-data-dir="$PWD/temp_user_data" --verbose --install-extension ms-python.python
./bin/code-server --extensions-dir="$PWD/extensions" --user-data-dir="$PWD/temp_user_data" --verbose --list-extensions

curl -#fL -o cpptools-linux.vsix -C - https://github.com/microsoft/vscode-cpptools/releases/download/1.5.1/cpptools-linux.vsix
./bin/code-server --extensions-dir="$PWD/extensions" --user-data-dir="$PWD/temp_user_data" --verbose --install-extension cpptools-linux.vsix
rm cpptools-linux.vsix

rm -r temp_user_data

# cpptools assumes write mounted FS for first launch
# deps should be installed already, just need to chmod and add to package.json activationEvents
# see https://github.com/microsoft/vscode-cpptools/blob/ef52c25aa6b12f2aa810388ba45177b75468443b/Extension/src/main.ts#L206
chmod +x extensions/ms-vscode.cpptools-1.5.1/debugAdapters/OpenDebugAD7
chmod +x extensions/ms-vscode.cpptools-1.5.1/debugAdapters/mono.linux-x86_64
chmod +x extensions/ms-vscode.cpptools-1.5.1/bin/cpptools
chmod +x extensions/ms-vscode.cpptools-1.5.1/bin/cpptools-srv

# Update package.json, https://github.com/microsoft/vscode-cpptools/blob/ef52c25aa6b12f2aa810388ba45177b75468443b/Extension/src/main.ts#L462
content='"onLanguage:c","onLanguage:cpp","onLanguage:cuda-cpp","onCommand:extension.pickNativeProcess","onCommand:extension.pickRemoteNativeProcess","onCommand:C_Cpp.BuildAndDebugActiveFile","onCommand:C_Cpp.ConfigurationEditJSON","onCommand:C_Cpp.ConfigurationEditUI","onCommand:C_Cpp.ConfigurationSelect","onCommand:C_Cpp.ConfigurationProviderSelect","onCommand:C_Cpp.SwitchHeaderSource","onCommand:C_Cpp.EnableErrorSquiggles","onCommand:C_Cpp.DisableErrorSquiggles","onCommand:C_Cpp.ToggleIncludeFallback","onCommand:C_Cpp.ToggleDimInactiveRegions","onCommand:C_Cpp.ResetDatabase","onCommand:C_Cpp.TakeSurvey","onCommand:C_Cpp.LogDiagnostics","onCommand:C_Cpp.RescanWorkspace","onCommand:C_Cpp.VcpkgClipboardInstallSuggested","onCommand:C_Cpp.VcpkgOnlineHelpSuggested","onCommand:C_Cpp.GenerateEditorConfig","onCommand:C_Cpp.GoToNextDirectiveInGroup","onCommand:C_Cpp.GoToPrevDirectiveInGroup","onCommand:C_Cpp.CheckForCompiler","onDebugInitialConfigurations","onDebugResolve:cppdbg","onDebugResolve:cppvsdbg","workspaceContains:/.vscode/c_cpp_properties.json","onFileSystem:cpptools-schema"'

sed -i -z "s|activationEvents\": \[\s\+\"\*\"|activationEvents\": \[$content|" extensions/ms-vscode.cpptools-1.5.1/package.json

