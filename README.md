[![Build status](https://ci.appveyor.com/api/projects/status/605r3ywpof2xa48c?svg=true)](https://ci.appveyor.com/project/teamtam/octopus-templates)

# octopus-templates

Source code for contributions to the [Octopus Deploy Library](https://library.octopus.com/listing).

## Set-AspNetCoreEnvVars.ps1

* [Step Template](https://library.octopus.com/step-templates/c7f96ab8-a0d3-4f01-928e-c8cb78ab108c/)

A PowerShell script to set an [ASP.NET Core runtime environment variable in a web.config file](https://docs.microsoft.com/en-us/aspnet/core/hosting/aspnet-core-module#setting-environment-variables).

The most likely use for this is to take advantage of the MVC [Environment tag helpers](https://docs.microsoft.com/en-us/aspnet/core/fundamentals/environments) now available in ASP.NET Core.

The benefit of setting an environment variable in web.config is that not only will the scope be restricted to the runtime of the app, but it will also take precedence over corresponding ones found in IIS, user environment variables or system environment variables. This means it is easier to independently configure apps deployed on the same machine.

In addition, web.config transforms are no longer an option in ASP.NET Core. If you use a token substitution method to manage environment variables in web.config, it will likely break your local configuration.

### Parameters
* `anc_WebConfigPath`: The path to the web.config file, typically derived from an [output variable](https://octopus.com/docs/deploying-applications/variables/output-variables) in a previous step
* `anc_EnvironmentVariableName`: Name of environment variable to set
* `anc_EnvironmentVariableValue`: Value of environment variable to set
