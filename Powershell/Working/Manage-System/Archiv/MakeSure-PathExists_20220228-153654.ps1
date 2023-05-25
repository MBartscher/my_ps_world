[CmdletBinding(SupportsShouldProcess)]
param([Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()][string]$strPath)
[string[]]$strPathParts=$strPath.Split('\')
[string]$strPartialPath=$strPathParts[0]
for($i=1;$i-lt$strPathParts.Count;$i++){
 C:\DASI\Skripte\Powershell\Working\Manage-Files\MakeSure-FolderExists_20220228-150007.ps1 -strParentPath $strPartialPath -strName $strPathParts[$i]
 $strPartialPath=($strPartialPath,$strPathParts[$i])-join'\'
}
$strPathParts=$null
$strPartialPath=$null