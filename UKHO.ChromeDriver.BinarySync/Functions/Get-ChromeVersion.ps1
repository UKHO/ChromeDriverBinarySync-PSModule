function Get-ChromeVersion {
    [CmdletBinding()]
    [OutputType([System.Diagnostics.FileVersionInfo])]
    param (
    )

    begin {
    }

    process {
        $chromePath = @(
            "C:\Program Files\Google\Chrome\Application\chrome.exe",
            "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
        ) | Where-Object {
            Test-Path $_
        } | Select-Object -First 1

        [System.Diagnostics.FileVersionInfo]::GetVersionInfo($chromePath)
    }

    end {
    }
}