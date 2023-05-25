[CmdletBinding(SupportsShouldProcess)]
param([Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()][string]$strPath)
begin{
 if(-not($strAliasMask)){C:\DASI\Skripte\Powershell\Working\MyAliases.ps1}
 [string[]]$strPathParts=$strPath.Split('\')
 [string]$strPartialPath=$strPathParts[0]
}
process{
 if(-not(Test-Path -Path $strPath)){
  for($i=1;$i-lt$strPathParts.Count;$i++){
   if($strPathParts[$i]){MakeSure-FolderExists -strParentPath $strPartialPath -strName $strPathParts[$i]}
   $strPartialPath=($strPartialPath,$strPathParts[$i])-join'\'
  }
 }
}
end{
 $strPathParts=$null
 $strPartialPath=$null
}