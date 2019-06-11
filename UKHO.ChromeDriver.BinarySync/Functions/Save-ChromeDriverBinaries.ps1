function Save-ChromeDriverBinaries {
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '')]
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

        $latestReleases = $chromeDriverFiles | Where-Object { $_.Key -like "LATEST_RELEASE*" } | ForEach-Object {
            @{
                ChromeVersion       = $_.Key
                ChromeDriverVersion = Invoke-RestMethod "$DownloadRootUrl$($_.Key)"
            }
        }

        $latestReleases | ForEach-Object {
            $fileName = Join-Path $TargetDirectory $_.ChromeVersion
            Write-Output "Downloading: $fileName"
            # We need to create the file before we write to it else it doesn't work with PSDrives
            if (-not (Test-Path -Path $fileName -PathType Leaf)) {
                New-Item -Path $fileName -ItemType File -Force | Out-Null
            }
            Set-Content -Path $fileName -Value $_.ChromeDriverVersion
            $ChromeDriverVersion = $_.ChromeDriverVersion
            $chromeDriverFiles | Where-Object { $_.Key -like "$ChromeDriverVersion*" } | ForEach-Object {
                $fileName = Join-Path $TargetDirectory $_.Key
                if (-not (Test-Path -Path $fileName -PathType Leaf)) {
                    Write-Output "Downloading: $fileName"
                    # We need to create the file before we write to it else it doesn't work with PSDrives
                    New-Item -Path $fileName -ItemType File -Force | Out-Null
                    Invoke-WebRequest -Uri "$DownloadRootUrl$($_.Key)" -OutFile $fileName
                }
            }
        }
    }

    end {
    }
}
