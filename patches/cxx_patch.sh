38260c38260,38261
<             configuration.includePath = [rootFolder].concat(this.vcpkgIncludes);
---
>             configuration.includePath = [rootFolder].concat(this.vcpkgIncludes);
>             configuration.includePath = ["${env:CPATH}","${env:_EXTRA_INCLUDES}"].concat(configuration.includePath);
38277c38278,38281
<         }
---
>         }
>         else{
>             configuration.compilerPath = "${env:_CXX_PATH}";
>         }
38693a38698
>                         configuration.browse.path.push("${env:CSC_VAR}");
