param(
    [Parameter(Mandatory)]
    [string]
    $RepositorySourceUri
)

. $PSScriptRoot\Install-LatestModule.ps1 -Name PSScriptAnalyzer -RepositorySourceUri $RepositorySourceUri
. $PSScriptRoot\Install-LatestModule.ps1 -Name Pester -RepositorySourceUri $RepositorySourceUri

$parameters = @{
    OutputFile = "$PSScriptRoot\Test-PSScriptAnalyzer.XML";
    Tag        = 'PSScriptAnalyzer';
    Script     = "$PSScriptRoot\..\Tests";
    EnableExit = $true;
}

# PSScriptAnalyzer Tests
Invoke-Pester @parameters