function Invoke-OctopusStep {
	param (
		[Parameter(Mandatory=$true)]
		[hashtable]$parameters,

		[Parameter(Mandatory=$true)]
		[string]$script
	)
	
	$OctopusParameters = @{}
	foreach ($item in $parameters.GetEnumerator()) {
		$OctopusParameters[$item.Name] = $item.Value;
	}

	& $script
}

Describe "Set-AspNetCoreEnvVars" {

    Context "Script Parameter Validation" {
        It "Should throw exception when missing parameter" {
            { .\Set-AspNetCoreEnvVars.ps1 "Hello" "World" } | Should Throw
        }
        It "Should throw exception when web.config can't be found" {
            { .\Set-AspNetCoreEnvVars.ps1 "web.config" "Hello" "World" } | Should Throw
        }
    }

    Context "Octopus Parameter validation" {
        It "Should throw exception when missing parameter" {
            { Invoke-OctopusStep @{ anc_WebConfigPath="web.config"; anc_EnvironmentVariableName="Hello" } .\Set-AspNetCoreEnvVars.ps1 } | Should Throw
        }
        It "Should throw exception when missing parameter" {
            { Invoke-OctopusStep @{ anc_WebConfigPath="web.config"; anc_EnvironmentVariableValue="World" } .\Set-AspNetCoreEnvVars.ps1 } | Should Throw
        }
        It "Should throw exception when missing parameter" {
            { Invoke-OctopusStep @{ anc_EnvironmentVariableName="Hello"; anc_EnvironmentVariableValue="World" } .\Set-AspNetCoreEnvVars.ps1 } | Should Throw
        }
        It "Should throw exception when web.config can't be found" {
            { Invoke-OctopusStep @{ anc_WebConfigPath="web.config"; anc_EnvironmentVariableName="Hello"; anc_EnvironmentVariableValue="World" } .\Set-AspNetCoreEnvVars.ps1 } | Should Throw
        }
    }    

    Context "Create <environmentVariable>" {
        BeforeEach {
            Copy-Item .\Sandbox\web.config $TestDrive
            $webConfig = Join-Path $TestDrive web.config
        }
        AfterEach {
            Remove-Item (Join-Path $TestDrive web.config)
        }
        It "Should execute successfully as a script" {
            .\Set-AspNetCoreEnvVars.ps1 $webConfig "Hello" "World" | Should BeNullOrEmpty
        }
        It "Should execute successfully in Octopus" {
            Invoke-OctopusStep @{ anc_WebConfigPath=$webConfig; anc_EnvironmentVariableName="Hello"; anc_EnvironmentVariableValue="World" } .\Set-AspNetCoreEnvVars.ps1 | Should BeNullOrEmpty
        }
    }

    Context "Update <environmentVariable>" {
        BeforeEach {
            Copy-Item .\Sandbox\web.config $TestDrive
            $webConfig = Join-Path $TestDrive web.config
        }
        AfterEach {
            Remove-Item (Join-Path $TestDrive web.config)
        }
        It "Should execute successfully as a script" {
            .\Set-AspNetCoreEnvVars.ps1 $webConfig "ASPNETCORE_ENVIRONMENT" "Hello" | Should BeNullOrEmpty
        }
        It "Should execute successfully in Octopus" {
            Invoke-OctopusStep @{ anc_WebConfigPath=$webConfig; anc_EnvironmentVariableName="ASPNETCORE_ENVIRONMENT"; anc_EnvironmentVariableValue="Hello" } .\Set-AspNetCoreEnvVars.ps1 | Should BeNullOrEmpty
        }
    }

    Context "Missing Parent <environmentsVariables>" {
        BeforeEach {
            Copy-Item .\Sandbox\web.NoEnvironmentVariables.config (Join-Path $TestDrive web.config)
            $webConfig = Join-Path $TestDrive web.config
        }
        AfterEach {
            Remove-Item (Join-Path $TestDrive web.config)
        }
        It "Should throw exception as a script" {
            { .\Set-AspNetCoreEnvVars.ps1 $webConfig "Hello" "World" } | Should Throw
        }
        It "Should throw exception in Octopus" {
            { Invoke-OctopusStep @{ anc_WebConfigPath=$webConfig; anc_EnvironmentVariableName="ASPNETCORE_ENVIRONMENT"; anc_EnvironmentVariableValue="Hello" } .\Set-AspNetCoreEnvVars.ps1 } | Should Throw
        }
    }
}
