function Update-ChromeDriver {
    [CmdletBinding()]
    param (
        # The root uri of the chrome driver artifacts
        [Parameter(Mandatory)]
        [string]
        $ChromeDriverDownloads,
        # The directory to place the downloaded files in
        [Parameter()]
        [string]
        $TargetDirectory = "C:\chromedriver"
    )

    begin {
        New-Item -ItemType Directory -Path $TargetDirectory -Force | Out-Null
        $chromeDriver = Join-Path $TargetDirectory "chromedriver.exe"
    }

    process {
        $updateChromeDriver = $true
        $chromeDriverVersion = Get-CorrectChromeDriverVersion -ChromeDriverDownloads $ChromeDriverDownloads
        if(Test-Path $chromeDriver) {
            $installedVersion = (& $chromeDriver -version).Split()[1]
            if($installedVersion -eq $chromeDriverVersion) {
                $updateChromeDriver = $false
            }
        }
        if($updateChromeDriver) {
            Get-ChildItem $TargetDirectory | Remove-Item -Force

            $chromeDriverLocation = Join-Path (Join-Path $ChromeDriverDownloads $chromeDriverVersion) "chromedriver_win32.zip" -Resolve

            Expand-Archive $chromeDriverLocation $TargetDirectory
        }
    }

    end {
    }
}