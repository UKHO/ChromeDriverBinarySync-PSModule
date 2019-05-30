param(
    [Parameter(Mandatory)]
    [string]
    $Name
)
if (((Get-PSRepository -Name ukho.psgallery -ErrorAction Ignore) | Measure-Object).Count -eq 0) {
    Write-Output "Register ukho.psgallery PSRepository"
    Register-PSRepository -Name ukho.psgallery -SourceLocation "https://proget.ukho.gov.uk/nuget/ukho.psgallery/" -InstallationPolicy Trusted
    Write-Output "ukho.psgallery PSRepository Registered"
}
Write-Output "Finding latest module"
$latestModule = Find-Module $Name -AllVersions | Sort-Object Version -Descending | Select-Object -First 1
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
