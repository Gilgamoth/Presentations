Set-PSDebug -strict

$VarLogFolder = "\\WebServer\c$\inetpub\logs\LogFiles\W3SVC1"

$VarDeleteDate = (Get-Date).AddDays(-60)
$VarDeletedFileCount = 0
$VarDeletedFileSize = 0

$VarLogFiles = Get-ChildItem -LiteralPath $VarLogFolder | Sort Name
foreach($VarLogFile in $VarLogFiles){
    $VarFileDate = get-date($VarLogFile.CreationTime)
    If($VarDeleteDate -gt $VarFileDate) {
        Remove-Item $VarLogFolder\$VarLogFile
        Write-Host "Deleted File - $VarLogFolder\$VarLogFile"
        $VarDeletedFileCount += 1
        $VarDeletedFileSize += $VarLogFile.Length
    }
}

$VarDeletedFileSize = "{0:N0}" -f ($VarDeletedFileSize/1MB)
Write-Host "$VarDeletedFileCount Files deleted, saving $VarDeletedFileSize MB"

