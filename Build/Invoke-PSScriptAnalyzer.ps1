param(
    [Parameter(Mandatory)]
    [string]
    $RepositoryName,
    [Parameter(Mandatory)]
    [string]
    $RepositorySourceUri
)

. $PSScriptRoot\Install-LatestModule.ps1 -Name PSScriptAnalyzer -RepositoryName $RepositoryName -RepositorySourceUri $RepositorySourceUri
. $PSScriptRoot\Install-LatestModule.ps1 -Name Pester -RepositoryName $RepositoryName -RepositorySourceUri $RepositorySourceUri

$parameters = @{
    OutputFile = "$PSScriptRoot\Test-PSScriptAnalyzer.XML";
    Tag        = 'PSScriptAnalyzer';
    Script     = "$PSScriptRoot\..\Tests";
    EnableExit = $true;
}

# PSScriptAnalyzer Tests
Invoke-Pester @parameters