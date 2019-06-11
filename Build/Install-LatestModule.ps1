param(
    [Parameter(Mandatory)]
    [string]
    $Name,
    [Parameter(Mandatory)]
    [string]
    $RepositoryName,
    [Parameter(Mandatory)]
    [string]
    $RepositorySourceUri
)
Write-Output "Installing latest version of $Name"
if (((Get-PSRepository -Name $RepositoryName -ErrorAction Ignore) | Measure-Object).Count -eq 0) {
    Write-Output "Register $RepositoryName PSRepository"
    Register-PSRepository -Name $RepositoryName -SourceLocation $RepositorySourceUri -InstallationPolicy Trusted
    Write-Output "$RepositoryName PSRepository Registered"
}
Write-Output "Finding latest module"
$latestModule = Find-Module $Name -AllVersions -Repository $RepositoryName | Sort-Object Version -Descending | Select-Object -First 1
Write-Output "latestModule: $($latestModule.Version)"
Write-Output "Getting installed module"
$installedModule = Get-Module -ListAvailable $Name | Sort-Object Version -Descending | Select-Object -First 1
Write-Output "installedModule: $($installedModule.Version)"
If ($installedModule.Version -lt $latestModule.Version) {
    Write-Output "Installing $Name $($latestModule.Version)"
    Install-Module -Name $Name -Scope CurrentUser -Force -Repository $latestModule.Repository -RequiredVersion $latestModule.Version
    Write-Output "Installed $Name $($latestModule.Version)"
}
Write-Output "Importing $Name"
Import-Module -Name $Name
Write-Output "Imported $Name"
