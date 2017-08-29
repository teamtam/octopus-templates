Param(
    [string]$WebConfigPath,
    [string]$WebConfigEnvironmentVariableName,
    [string]$WebConfigEnvironmentVariableValue
)

# TODO: validate path of web.config
# [ValidateScript({Test-Path $_ -PathType Leaf})]
# [ValidatePattern("(?i)(web\.config)$")]

function Get-Parameter($Name, [switch]$Required, $Default) {

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
        } else {
            $result = $Default
        }
    }

    return $result
}

& {
    Param(
        [string]$WebConfigPath,
        [string]$WebConfigEnvironmentVariableName,
        [string]$WebConfigEnvironmentVariableValue
    )

    $xml = (Get-Content $WebConfig) -as [Xml]
    $environmentVariables = $xml.configuration.'system.webServer'.aspNetCore.environmentVariables
    $environmentVariable = $environmentVariables.environmentVariable | Where-Object {$_.name -eq $ParameterName}

    if ($environmentVariable) {
        $environmentVariable.value = $ParameterValue
    }
    elseif ($environmentVariables) {
        $environmentVariable = $xml.CreateElement("environmentVariable");
        $environmentVariable.SetAttribute("Name", $ParameterName);
        $environmentVariable.SetAttribute("Value", $ParameterValue);
        $x = $environmentVariables.AppendChild($environmentVariable)
    }
    else {
        Write-Error "Could not find 'configuration/system.webServer/aspNetCore/environmentVariables' element in web.config"
        Exit 1
    }

    try {
        $xml.Save((Resolve-Path $WebConfig))
    }
    catch {
        Write-Error "Could not save web.config because: $_.Exception.Message"
        Exit 1
    }
} (Get-Parameter 'WebConfigPath' -Required) (Get-Parameter 'WebConfigEnvironmentVariableName' -Required) (Get-Parameter 'WebConfigEnvironmentVariableValue' -Required)
