[CmdletBinding(SupportsShouldProcess)]
param([Parameter(Mandatory=$true)][ValidateNotNullOrEmpty][ValidateScript({$_-is[string]})][string]$strSnippetCreatingText)
begin{
 if(-not($strAliasMask)){C:\DASI\Skripte\Powershell\Working\MyAliases.ps1}
}
process{
 New-IseSnippet -Title 'Create-Snippet' -Description 'For fast creating an ISE-Snippet.' -Text $strSnippetCreatingText -Author 'MB (Idea found at:"https://www.pdq.com/blog/creating-powershell-ise-snippets/")' -CaretOffset 8 -Force
}
end{
 $VarName='strSnippetCreatingText';if(Test-Path (-join('variable:',$VarName))){Remove-Variable -Name $VarName -Force}
 $VarName='VarName';if(Test-Path (-join('variable:',$VarName))){Remove-Variable -Name $VarName -Force}
}