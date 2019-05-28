# load all internal files
Get-ChildItem $PSScriptRoot/Internal -File -Recurse | ForEach-Object {
    . $_.FullName
}# load all script files
Get-ChildItem $PSScriptRoot/Functions -File -Recurse | ForEach-Object {
    . $_.FullName
}