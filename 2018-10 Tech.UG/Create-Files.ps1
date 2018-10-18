Set-PSDebug -strict

$Days=90

For($i=0; $i -lt $Days; $i++){
    $FileDate = (Get-Date).AddDays($i*-1)
    $FileName = $FileDate.ToString("yyyy-MM-dd") + ".txt"
    New-Item -Name $FileName
    $File = Get-Item $FileName
    $File.CreationTime = $FileDate
    $File.LastAccessTime = $FileDate
    $File.LastWriteTime = $FileDate
}