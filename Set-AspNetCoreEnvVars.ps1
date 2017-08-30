Param(
    [string]$WebConfigPath,
    [string]$EnvironmentVariableName,
    [string]$EnvironmentVariableValue
)

function Get-Parameter($Name, [switch]$Required, [switch]$TestPath) {

    $result = $null

    if ($OctopusParameters -ne $null) {
        $result = $OctopusParameters[$Name]
    }

    if ($result -eq $null) {
        $variable = Get-Variable $Name
        if ($variable -ne $null) {
            $result = $variable.Value
        }
    }

    if ($result -eq $null -or $result -eq "") {
        if ($Required) {
            throw "Missing parameter value $Name"
        }
    }

    if ($TestPath) {
        if (!(Test-Path $result -PathType Leaf)) {
            throw "Could not find $result"
        }
    }

    return $result
}

& {
    Param(
        [string]$WebConfigPath,
        [string]$EnvironmentVariableName,
        [string]$EnvironmentVariableValue
    )

    $xml = (Get-Content $WebConfigPath) -as [Xml]
    $environmentVariables = $xml.configuration.'system.webServer'.aspNetCore.environmentVariables
    $environmentVariable = $environmentVariables.environmentVariable | Where-Object {$_.name -eq $EnvironmentVariableName}

    if ($environmentVariable) {
        $environmentVariable.value = $EnvironmentVariableValue
    }
    elseif ($environmentVariables) {
        $environmentVariable = $xml.CreateElement("environmentVariable");
        $environmentVariable.SetAttribute("Name", $EnvironmentVariableName);
        $environmentVariable.SetAttribute("Value", $EnvironmentVariableValue);
        $x = $environmentVariables.AppendChild($environmentVariable)
    }
    else {
        throw "Could not find 'configuration/system.webServer/aspNetCore/environmentVariables' element in web.config"
    }

    try {
        $xml.Save((Resolve-Path $WebConfigPath))
    }
    catch {
        throw "Could not save web.config because: $_.Exception.Message"
    }
} (Get-Parameter 'WebConfigPath' -Required -TestPath) (Get-Parameter 'EnvironmentVariableName' -Required) (Get-Parameter 'EnvironmentVariableValue' -Required)
