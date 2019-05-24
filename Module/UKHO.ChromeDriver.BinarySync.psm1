# load all script files
Get-ChildItem $PSScriptRoot/Scripts -File -Recurse | ForEach-Object {
    . $_.FullName
}