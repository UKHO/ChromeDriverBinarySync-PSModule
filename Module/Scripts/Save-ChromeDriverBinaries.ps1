function Save-ChromeDriverArtifact {
    [CmdletBinding()]
    param (
        # The directory to place the downloaded files in
        [Parameter(Mandatory)]
        [string]
        $TargetDirectory,

        # The root url of the chrome driver artifacts download server
        [Parameter()]
        [string]
        $DownloadRootUrl = "https://chromedriver.storage.googleapis.com/"
    )

    begin {
    }

    process {

        $chromeDriverFiles = (Invoke-RestMethod $DownloadRootUrl).ListBucketResult.Contents

        New-Item -ItemType Directory -Force -Path $TargetDirectory | Out-Null
        $latestReleases = $chromeDriverFiles | Where-Object { $_.Key -like "LATEST_RELEASE*" } | ForEach-Object {
            @{
                ChromeVersion       = $_.Key
                ChromeDriverVersion = Invoke-RestMethod "$DownloadRootUrl$($_.Key)"
            }
        }
        $latestReleases | ForEach-Object {
            Set-Content -Path (Join-Path $TargetDirectory $_.ChromeVersion) -Value $_.ChromeDriverVersion
            $ChromeDriverVersion = $_.ChromeDriverVersion
            $chromeDriverFiles | Where-Object { $_.Key -like "$ChromeDriverVersion*" } | ForEach-Object {
                $fileName = "$TargetDirectory\$($_.Key)"
                New-Item -ItemType Directory -Force -Path (Split-Path $fileName) | Out-Null
                Invoke-WebRequest -Uri "$DownloadRootUrl$($_.Key)" -OutFile $fileName
            }
        }

    }

    end {
    }
}