param(
    [Parameter(Mandatory)]
    [String]
    $PreReleaseTag,

    [Parameter(Mandatory)]
    [String]
    $ManifestFilePath,

    [Parameter(Mandatory)]
    [String]
    $Branch,

    [String]
    $ReleaseBranch = "Master")

if($Branch -eq $ReleaseBranch){
    Write-Output "Branch $Branch for build is the same as the ReleaseBranch $ReleaseBranch. Module NOT marked as PreRelease"
}
else{
    $tag = $PreReleaseTag.Trim("-")
    Update-ModuleManifest -Path $ManifestFilePath -PreRelease $tag -Verbose
    Write-Output "Branch $Branch for build is different to ReleaseBranch $ReleaseBranch. Module marked as PreRelease with $tag"
}