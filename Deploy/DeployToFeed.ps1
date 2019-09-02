param($RepositorySourceUri, $RepositoryPublishUri, $NugetAPIKey, $ModuleFolderPath)

# You cannot register more than one PSRepository with the same SourceLocation.
# Check one exists first and prefer to use that
# If a PSRepository with the same SourceLocation doesn't exist, then we add one with random name and remove afterwards
$removeRepo = $false
$repoName = Get-PSRepository | Where-Object {$_.SourceLocation -eq $RepositorySourceUri} | Select-Object -ExpandProperty Name

if($null -eq $repoName){
    $repoName = New-Guid  # Need a random name
    $removeRepo = $true   # Want to remove this random repoistory afterwards
    Write-Output "Registering PSRepository $repoName with SourceLocation $RepositorySourceUri"
    Register-Repository $repoName $RepositorySourceUri $RepositoryPublishUri
}

Write-Output "Using PSRepository $repoName with SourceLocation $RepositorySourceUri to publish module"

Publish-ModuleToFeed -NugetAPIKey $NugetAPIKey -RepositoryName $repoName -ModuleFolderPath $ModuleFolderPath

# Only remove PSRepository if it was registered in this script
if($removeRepo){
    Write-Output "Unregister PSRepository $repoName"
    UnRegister-Repository $repoName
}