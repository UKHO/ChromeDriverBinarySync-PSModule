function Get-CorrectChromeDriverVersion {
    [CmdletBinding()]
    param (
        # The version of chrome to match against
        [Parameter()]
        [System.Diagnostics.FileVersionInfo]
        $ChromeVersion,
        # The root uri of the chrome driver artifacts
        [Parameter(Mandatory)]
        [string]
        $ChromeDriverDownloads
    )

    begin {
        if(-not ($ChromeVersion)) {
            $ChromeVersion = Get-ChromeVersion
        }
    }

    process {
        @(
            "LATEST_RELEASE_$($ChromeVersion.FileMajorPart).$($ChromeVersion.FileMinorPart).$($ChromeVersion.FileBuildPart).$($ChromeVersion.FilePrivatePart)",
            "LATEST_RELEASE_$($ChromeVersion.FileMajorPart).$($ChromeVersion.FileMinorPart).$($ChromeVersion.FileBuildPart)",
            "LATEST_RELEASE_$($ChromeVersion.FileMajorPart).$($ChromeVersion.FileMinorPart)",
            "LATEST_RELEASE_$($ChromeVersion.FileMajorPart)",
            "LATEST_RELEASE"
        ) `
        | ForEach-Object { Join-Path $ChromeDriverDownloads $_ } `
        | Where-Object { Test-Path $_ } `
        | Select-Object -First 1 `
        | ForEach-Object { Get-Content $_ -ReadCount 1 }
    }

    end {
    }
}