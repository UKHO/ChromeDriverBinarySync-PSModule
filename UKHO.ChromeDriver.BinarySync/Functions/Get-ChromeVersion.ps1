function Get-ChromeVersion {
    [CmdletBinding()]
    [OutputType([System.Diagnostics.FileVersionInfo])]
    param (
        [Parameter()]
        [switch]
        $IncludeBeta
    )

    begin {
        $chromePaths = @(
            "C:\Program Files\Google\Chrome\Application\chrome.exe",
            "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
        )
        if ($IncludeBeta) {
            $chromePaths = @(
                "C:\Program Files\Google\Chrome Beta\Application\chrome.exe"
                "C:\Program Files (x86)\Google\Chrome Beta\Application\chrome.exe"
            ) + $chromePaths
        }
    }

    process {
        $chromePath = $chromePaths | Where-Object {
            Test-Path $_
        } | Select-Object -First 1

        [System.Diagnostics.FileVersionInfo]::GetVersionInfo($chromePath)
    }

    end {
    }
}