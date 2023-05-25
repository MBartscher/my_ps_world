Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
function Get-ScriptDirectory {
    $Invocation = (Get-Variable MyInvocation -Scope 1).Value
    Split-Path $Invocation.MyCommand.Path
}
$installpath = Get-ScriptDirectory
$preStartPath=Get-Item '.\'
cd $installpath
.\makeSureThatFolderExists.ps1 -strParentPath '.' -strName 'BackupConfig'

#cd $preStartPath