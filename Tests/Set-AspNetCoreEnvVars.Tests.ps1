Describe "Set-AspNetCoreEnvVars" {

    Context "Parameter validation" {
        It "Should throw exception when missing parameter" {
            { .\Set-AspNetCoreEnvVars.ps1 "Hello" "World" } | Should Throw
        }
        It "Should throw exception when web.config can't be found" {
            { .\Set-AspNetCoreEnvVars.ps1 "web.config" "Hello" "World" } | Should Throw
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
        It "Should execute successfully" {
            .\Set-AspNetCoreEnvVars.ps1 $webConfig "Hello" "World" | Should BeNullOrEmpty
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
        It "Should execute successfully" {
            .\Set-AspNetCoreEnvVars.ps1 $webConfig "ASPNETCORE_ENVIRONMENT" "Hello" | Should BeNullOrEmpty
        }
    }

    Context "Missing parent <environmentsVariables>" {
        BeforeEach {
            Copy-Item .\Sandbox\web.NoEnvironmentVariables.config (Join-Path $TestDrive web.config)
            $webConfig = Join-Path $TestDrive web.config
        }
        AfterEach {
            Remove-Item (Join-Path $TestDrive web.config)
        }
        It "Should throw exception" {
            { .\Set-AspNetCoreEnvVars.ps1 $webConfig "Hello" "World" } | Should Throw
        }
    }
}
