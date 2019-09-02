function Update-ChromeDriver {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        # The root uri of the chrome driver artifacts
        [Parameter(Mandatory)]
        [string]
        $ChromeDriverDownloads,
        # The directory to place the downloaded files in
        [Parameter()]
        [string]
        $TargetDirectory = "C:\chromedriver",
        [Parameter()]
        [switch]
        $IncludeBeta
    )

    begin {
        if (-not (Test-Path $TargetDirectory) -and $PSCmdlet.ShouldProcess("Create $TargetDirectory Directory")) {
            New-Item -ItemType Directory -Path $TargetDirectory | Out-Null
        }
        $chromeDriver = Join-Path $TargetDirectory "chromedriver.exe"
    }

    process {
        $updateChromeDriver = $true

        if($IncludeBeta) {
            $chromeDriverVersion = Get-CorrectChromeDriverVersion -ChromeDriverDownloads $ChromeDriverDownloads -IncludeBeta
        } else {
            $chromeDriverVersion = Get-CorrectChromeDriverVersion -ChromeDriverDownloads $ChromeDriverDownloads
        }
        if (Test-Path $chromeDriver) {
            $installedVersion = (& $chromeDriver -version).Split()[1]
            if ($installedVersion -eq $chromeDriverVersion) {
                $updateChromeDriver = $false
            }
        }

        if ($updateChromeDriver) {
            # Kill any chromedriver.exe that are running as they lock the test files
            Get-Process -Name "chromedriver" -ErrorAction SilentlyContinue | Stop-Process -Force
            if ($PSCmdlet.ShouldProcess("Remove all items from $TargetDirectory") ) {
                Get-ChildItem $TargetDirectory | Remove-Item -Force
            }
            if ($PSCmdlet.ShouldProcess("Deploy ChromeDriver $chromeDriverVersion to $TargetDirectory")) {
                $chromeDriverLocation = Join-Path (Join-Path $ChromeDriverDownloads $chromeDriverVersion) "chromedriver_win32.zip" -Resolve

                Expand-Archive $chromeDriverLocation $TargetDirectory
            }
        }
    }

    end {
    }
}
