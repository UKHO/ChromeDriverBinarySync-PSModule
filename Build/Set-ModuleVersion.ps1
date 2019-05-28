param(
    [Parameter(Mandatory)]
    [String]
    $ManifestFilePath,

    [Parameter(Mandatory)]
    [String]
    $BuildNumber
)

$buildNumberRegex = "(.+)_([1-9][0-9]*).([0-9]*).([0-9]{3,5}).([0-9]{1,2})"
$validBuildNumber = $buildNumber -match $buildNumberRegex

if ($validBuildNumber -eq $false) {
    Write-Error "Build number passed in must be in the following format: (BuildDefinitionName)_(ProjectVersion).(date:yy)(DayOfYear)(rev:.r)"
    return
}

$buildNumberSplit = $buildNumber.Split('_')
$buildRevisionNumber = $buildNumberSplit[1] -replace ".DRAFT", ""
$versionToApply = "$buildRevisionNumber"

Write-Host "Updating Version to $versionToApply"
Update-ModuleManifest -Path $ManifestFilePath -ModuleVersion $versionToApply -Verbose