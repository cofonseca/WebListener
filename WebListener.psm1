(Get-ChildItem '*.ps1') | ForEach-Object {
    . $_.FullName
    Export-ModuleMember -Function $_.BaseName
}