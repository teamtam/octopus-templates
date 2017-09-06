[![Build status](https://ci.appveyor.com/api/projects/status/605r3ywpof2xa48c?svg=true)](https://ci.appveyor.com/project/teamtam/octopus-templates)

# octopus-templates

Step template(s) for the Octopus Deploy Library.

## Set-AspNetCoreEnvVars.ps1

[Octopus Deploy Library](https://library.octopus.com/step-templates/c7f96ab8-a0d3-4f01-928e-c8cb78ab108c/)

A PowerShell script to set an [ASP.NET Core runtime environment variable in a web.config file](https://docs.microsoft.com/en-us/aspnet/core/hosting/aspnet-core-module#setting-environment-variables). This can also be run standalone.

### Parameters
* `anc_WebConfigPath`: The path to the web.config, typically an output variable from a previous step when run in Octopus
* `anc_EnvironmentVariableName`: Name of environment variable to set
* `anc_EnvironmentVariableValue`: Value of environment variable to set
