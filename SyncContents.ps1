$chromeDriverRootUrl = "https://chromedriver.storage.googleapis.com/"
$chromeDriverFiles = (Invoke-RestMethod $chromeDriverRootUrl).ListBucketResult.Contents
$baseDirectory = "C:\temp\chromedriver"
New-Item -ItemType Directory -Force -Path $baseDirectory | Out-Null
$latestReleases = $chromeDriverFiles | Where-Object { $_.Key -like "LATEST_RELEASE*"  } | ForEach-Object {
    @{
        ChromeVersion = $_.Key
        ChromeDriverVersion = Invoke-RestMethod "$chromeDriverRootUrl$($_.Key)"
    }
}
$latestReleases | ForEach-Object {
    Set-Content -Path (Join-Path $baseDirectory $_.ChromeVersion) -Value $_.ChromeDriverVersion
    $ChromeDriverVersion = $_.ChromeDriverVersion
    $chromeDriverFiles | Where-Object {$_.Key -like "$ChromeDriverVersion*"} | ForEach-Object {
        $fileName = "$baseDirectory\$($_.Key)"
        New-Item -ItemType Directory -Force -Path (Split-Path $fileName) | Out-Null
        Invoke-WebRequest -Uri "$chromeDriverRootUrl$($_.Key)" -OutFile $fileName
    }
}
