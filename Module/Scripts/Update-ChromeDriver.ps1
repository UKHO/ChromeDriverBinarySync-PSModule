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
        $TargetDirectory = "C:\chromedriver"
    )

    begin {
        if (-not (Test-Path $TargetDirectory) -and $PSCmdlet.ShouldProcess("Create $TargetDirectory Directory")) {
            New-Item -ItemType Directory -Path $TargetDirectory | Out-Null
        }
        $chromeDriver = Join-Path $TargetDirectory "chromedriver.exe"
    }

    process {
        $updateChromeDriver = $true
        $chromeDriverVersion = Get-CorrectChromeDriverVersion -ChromeDriverDownloads $ChromeDriverDownloads
        if (Test-Path $chromeDriver) {
            $installedVersion = (& $chromeDriver -version).Split()[1]
            if ($installedVersion -eq $chromeDriverVersion) {
                $updateChromeDriver = $false
            }
        }
        if ($updateChromeDriver) {
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