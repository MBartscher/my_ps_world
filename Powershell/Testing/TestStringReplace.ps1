[string]$String='Das Ding, die Dinge. Irgendwie moechte ich das Dingfest machen. Dann sehen die Dinge gleich besser aus. RegEx sind schon recht komplexe Dinger. Wie echt ist die Welt?'
$SuchString=Read-Host
$outString=$String-replace(-join($SuchString,'[\W]'),-join('',$String.Substring($String.IndexOf($SuchString)+$SuchString.Length,1)))
Write-Host $outString