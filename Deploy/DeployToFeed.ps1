param($RepositoryName, $RepositorySourceUri, $RepositoryPublishUri, $NugetAPIKey, $ModuleFolderPath)

if (((Get-PSRepository -Name $RepositoryName -ErrorAction Ignore) | Measure-Object).Count -eq 0) {
    Write-Output "Register $RepositoryName PSRepository"
    Register-PSRepository -Name $RepositoryName -SourceLocation $RepositorySourceUri -PublishLocation $RepositoryPublishUri -InstallationPolicy Trusted
    Write-Output "$RepositoryName PSRepository Registered"
} else {
    Set-PSRepository -Name $RepositoryName -PublishLocation $RepositoryPublishUri
}

Publish-ModuleToFeed $NugetAPIKey $RepositoryName $ModuleFolderPath

UnRegister-Repository $RepositoryName