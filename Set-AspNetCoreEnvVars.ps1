Param(
    [Parameter(Mandatory=$True, Position=1)]
    [ValidateScript({Test-Path $_ -PathType Leaf})]
    [ValidatePattern("(?i)(web\.config)$")]
    [string]$WebConfig,

    [Parameter(Mandatory=$True, Position=2)]
    [string]$ParameterName,

    [Parameter(Mandatory=$True, Position=3)]
    [string]$ParameterValue
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
    $environmentVariables.AppendChild($environmentVariable) 1>$null
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
