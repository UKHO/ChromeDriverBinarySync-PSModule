param(
    [Parameter(Mandatory)]
    [string]
    $Name
)
$latestModule = Find-Module $Name -AllVersions | Sort-Object Version -Descending | Select-Object -First 1
$installedModule = Get-Module -ListAvailable $Name | Sort-Object Version -Descending | Select-Object -First 1
If ($installedModule.Version -lt $latestModule.Version) {
    Write-Output "Installing $Name $($latestModule.Version)"
    Install-Module -Name $Name -Scope CurrentUser -Force -Repository $latestModule.Repository -RequiredVersion $latestModule.Version
}
Write-Output "Importing $Name"
Import-Module -Name $Name