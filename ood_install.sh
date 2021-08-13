mkdir -p "/appl/opt/ood/$1/soft/vscode"      
cp install.sh "/appl/opt/ood/$1/soft/vscode/"
cd "/appl/opt/ood/$1/soft/vscode"            
bash install.sh
ln -fns ../../../deps/util/forms/form_validated.js form.js
