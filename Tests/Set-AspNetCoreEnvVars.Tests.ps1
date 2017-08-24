Describe "Set-AspNetCoreEnvVars" {

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
        It "Should write to the error stream" {
            (.\Set-AspNetCoreEnvVars.ps1 $webConfig "Hello" "World" 2>&1 | Measure-Object -Line).Lines | Should BeGreaterThan 0
        }
    }    
}
