# OOD VSCode

Launches VSCode as an interactive app. Uses [code-server](https://github.com/cdr/code-server).

## Installation
The app uses a shared code-server located in `/appl/opt/ood/$SLURM_OOD_ENV/soft/vscode`.
To (re)install the code-server copy `install.sh` to `/appl/opt/ood/$SLURM_OOD_ENV/soft/vscode` and run it.

Check `install.sh` for installing new system extensions.  
As extensions in VSCode sometimes finish their installation when the extension is launched the first time, which would require write-mount, the final installation part may need to be done manually. See the `cpptools` part of `install.sh` for example of automating the final part.
Alternatively, a code-server could be launched write-mounted manually and then connected to once to finish extension installations.  

