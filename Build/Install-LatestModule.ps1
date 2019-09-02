param(
    [Parameter(Mandatory)]
    [string]
    $Name,
    [Parameter(Mandatory)]
    [string]
    $RepositorySourceUri
)
    
# You cannot register more than one PSRepository with the same SourceLocation. 
# Check one exists first and prefer to use that
# If a PSRepository with the same SourceLocation doesn't exist, then we add one with random name and remove afterwards
$removeRepo = $false
$repoName = Get-PSRepository | Where-Object {$_.SourceLocation -eq $RepositorySourceUri} | Select-Object -ExpandProperty Name

if($null -eq $repoName){
    $repoName = New-Guid  # Need a random name
    $removeRepo = $true   # Want to remove this random repoistory afterwards
    Write-Host "Registering PSRepository $repoName with SourceLocation $RepositorySourceUri"
    Register-Repository $repoName $RepositorySourceUri $RepositoryPublishUri
}

Write-Output "Installing latest version of $Name"

Write-Output "Finding latest module"
$latestModule = Find-Module $Name -AllVersions -Repository $repoName | Sort-Object Version -Descending | Select-Object -First 1
Write-Output "latestModule: $($latestModule.Version)"

Write-Output "Getting installed module"
$installedModule = Get-Module -ListAvailable $Name | Sort-Object Version -Descending | Select-Object -First 1
Write-Output "installedModule: $($installedModule.Version)"

# If not latest version, update module to use it.
If ($installedModule.Version -lt $latestModule.Version) {
    Write-Output "Installing $Name $($latestModule.Version)"
    Install-Module -Name $Name -Scope CurrentUser -Force -Repository $repoName -RequiredVersion $latestModule.Version
    Write-Output "Installed $Name $($latestModule.Version)"
}

Write-Output "Importing $Name"
Import-Module -Name $Name
Write-Output "Imported $Name"

# Only remove PSRepository if it was registered in this script
if($removeRepo){
    Write-Host "Unregister PSRepository $repoName"
    UnRegister-Repository $repoName
}