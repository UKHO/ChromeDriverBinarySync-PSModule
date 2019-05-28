# load all internal files
Get-ChildItem $PSScriptRoot/Internal -File -Recurse | ForEach-Object {
    Import-Module $_.FullName
}# load all script files
Get-ChildItem $PSScriptRoot/Functions -File -Recurse | ForEach-Object {
    Import-Module $_.FullName
}