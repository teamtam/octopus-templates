$webConfig = Resolve-Path 'web.config'
if (!(Test-Path $webConfig)) {
    Write-Host "Could not find $webConfig"
    Exit 1
}
$doc = (Get-Content $webConfig) -as [Xml]
$obj = $doc.configuration.'system.webServer'.aspNetCore.environmentVariables.environmentVariable | Where-Object {$_.name -eq 'ASPNETCORE_ENVIRONMENT'}
try {
    $obj.value = 'Development'
    $doc.Save($webConfig)    
}
catch {
    Write-Host "Could not find ASPNETCORE_ENVIRONMENT element in web.config"
    Exit 1
}
