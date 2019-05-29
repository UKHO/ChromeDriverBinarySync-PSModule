param(
    [Parameter(Mandatory)]
    [String]
    $ManifestFilePath,

    [Parameter(Mandatory)]
    [String]
    $BuildNumber
)

$buildNumberRegex = "(.+)_([0-9]*)\.([0-9]*)\.([0-9]*)"
$validBuildNumber = $buildNumber -match $buildNumberRegex

if ($validBuildNumber -eq $false) {
    Write-Error "Build number passed in must be in the following format: (.+)_([0-9]*)\.([0-9]*)\.([0-9]*)"
    return
}

$buildNumberSplit = $buildNumber.Split('_')
$buildRevisionNumber = $buildNumberSplit[1] -replace ".DRAFT", ""
$versionToApply = "$buildRevisionNumber"

Write-Output "Updating Version to $versionToApply"
Update-ModuleManifest -Path $ManifestFilePath -ModuleVersion $versionToApply