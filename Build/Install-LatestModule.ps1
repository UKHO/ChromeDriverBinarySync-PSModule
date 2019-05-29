param(
    [Parameter(Mandatory)]
    [string]
    $Name
)
$latestModule = Get-Module $Name | Sort-Object Version -Descending | Select-Object -First 1
If ((Get-Module $Name -ListAvailable | Sort-Object Version -Descending | Select-Object -First 1).Version -lt $latestModule.Version) {
    Install-Module -Name $Name -Scope CurrentUser -Force -Repository $latestModule.Repository
}
Import-Module -Name $Name