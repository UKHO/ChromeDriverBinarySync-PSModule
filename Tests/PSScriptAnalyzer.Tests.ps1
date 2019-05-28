Describe 'PSScriptAnalyzer' -Tag 'PSScriptAnalyzer' {
    $analysis = Invoke-ScriptAnalyzer -Path $PSScriptRoot/.. -IncludeDefaultRules -Recurse
    $scriptAnalyzerRules = Get-ScriptAnalyzerRule

    forEach ($rule in $scriptAnalyzerRules) {
        Context $rule {
            $analysis |
            Where-Object RuleName -EQ $rule -OutVariable failures |
            ForEach-Object {
                It "$(Join-Path $_.ScriptPath $_.ScriptName) Line $($_.Column) Column $($_.Column)" {
                    throw $_.Message
                }
            }
        }
    }
}