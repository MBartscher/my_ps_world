[CmdletBinding(SupportsShouldProcess)]
param([Parameter(Mandatory=$true)][ValidateNotNull()][ValidateScript({$_-is[string]})][string]$strInput)
[string]$strOutput=$strInput
if($strOutput.Contains("\")){$strOutput=$strOutput.Replace("\","Backslash")}
if($strOutput.Contains("/")){$strOutput=$strOutput.Replace("/","Slash")}
if($strOutput.Contains(":")){$strOutput=$strOutput.Replace(":","Colon")}
if($strOutput.Contains("*")){$strOutput=$strOutput.Replace("*","Asterisk")}
if($strOutput.Contains("?")){$strOutput=$strOutput.Replace("?","QuestionMark")}
if($strOutput.Contains("`"")){$strOutput=$strOutput.Replace("`"","Quotes")}
if($strOutput.Contains("<")){$strOutput=$strOutput.Replace("<","LowerThen")}
if($strOutput.Contains(">")){$strOutput=$strOutput.Replace(">","GreaterThen")}
if($strOutput.Contains("|")){$strOutput=$strOutput.Replace("|","Pipeline")}
return $strOutput