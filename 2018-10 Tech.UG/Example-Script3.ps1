# CODE START
Set-PSDebug -strict

$VarLogFolder = "\\WebServer\c$\inetpub\logs\LogFiles\W3SVC1"
$VarArchiveFile = "LogArchive.zip"

$VarSMTPServer= "mailserver"
$VarSMTPUser = ""
$VarSMTPPassword = ""
$VarEMailFrom = "Report@Domain.Local"
$VarEMailTo = "steve.lunn@Domain.Local"
$VarEMailSubject = "File Removal Report"
$VarEMailBody = ""

$VarDeleteDate = (Get-Date).AddDays(-60)
$VarDeletedFileCount = 0
$VarDeletedFileSize = 0

$VarLogFiles = Get-ChildItem -LiteralPath $VarLogFolder | Sort Name
foreach($VarLogFile in $VarLogFiles){
    $VarFileDate = get-date($VarLogFile.CreationTime)
    If($VarDeleteDate -gt $VarFileDate) {
        Compress-Archive -DestinationPath $VarLogFolder\$VarArchiveFile -Path $VarLogFolder\$VarLogFile -Update
        Remove-Item $VarLogFolder\$VarLogFile
        Write-Host "Deleted File - $VarLogFolder\$VarLogFile"
        #Var$EMailBody += "Deleted File - $VarLogFolder\$VarLogFile <BR>"
        $VarDeletedFileCount += 1
        $VarDeletedFileSize += $VarLogFile.Length
    }
}

$VarDeletedFileSize = "{0:N0}" -f ($VarDeletedFileSize/1MB)

Write-Host "$VarDeletedFileCount Files deleted, saving $VarDeletedFileSize MB"
$VarEMailBody += "$VarDeletedFileCount Files deleted, saving $VarDeletedFileSize MB"

$VarSMTP = New-Object System.Net.Mail.SmtpClient -argumentList $VarSMTPServer
If($VarSMTPUser -ne "") {
    $VarSMTP.Credentials = New-Object System.Net.NetworkCredential -argumentList $VarSMTPUser,$VarSMTPPassword
}

$VarSMTPMessage = New-Object System.Net.Mail.MailMessage
$VarSMTPMessage.From = New-Object System.Net.Mail.MailAddress($VarEMailFrom)
$VarSMTPMessage.To.Add($VarEMailTo)
#$VarSMTPMessage.CC.Add("a.n.other@bcd.com")
#$VarSMTPMessage.BCC.Add("yet.another@cde.com")
$VarSMTPMessage.Subject = $VarEMailSubject
$VarSMTPMessage.Body = $VarEMailBody
$VarSMTP.Send($VarSMTPMessage)