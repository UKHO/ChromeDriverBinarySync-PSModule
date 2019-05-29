. $PSScriptRoot\Install-LatestModule.ps1 -Name PSScriptAnalyzer
. $PSScriptRoot\Install-LatestModule.ps1 -Name Pester

$parameters = @{
    OutputFile = "$PSScriptRoot\Test-PSScriptAnalyzer.XML";
    Tag        = 'PSScriptAnalyzer';
    Script     = "$PSScriptRoot\..\Tests";
    EnableExit = $true;
}

# PSScriptAnalyzer Tests
Invoke-Pester @parameters