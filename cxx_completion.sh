wget https://github.com/microsoft/vscode-cpptools/releases/download/1.3.1/cpptools-linux.vsix .
mv cpptools-linux.vsix  ms-vscode.cpptools-linux.vsix

/appl/opt/ood_util/vscode_server/bin/code-server --extensions-dir=/appl/opt/ood_util/vscode_server/extensions --verbose --install-extension  ms-vscode.cpptools-linux.vsix
# Remove ms-vscode.cpptools-1.3.1/install.lock 

# Check if this is needed
# launch vscode once with write access, and it will do something and then
# subsequent runs on read only will work
# bin/codeserver
# ~/.config/code-server/config.yaml contains the password when started with no arguments
# forward with ssh -L 8080:localhost:8080 puhti-login3.csc.fi

#Patch in 
#ms-vscode.cpptools-1.3.1/dist/main.js
# applyDefaultConfigurationValues
# if (isUnset(settings.defaultIncludePath))                                                                
#    configuration.includePath = ["${env:CPATH}","${env:_EXTRA_INCLUDES}"].concat(configuration.includePath);
#    configuration.compilerPath = "${env:_CXX_PATH}";                                                        
# }                                                                                                         

