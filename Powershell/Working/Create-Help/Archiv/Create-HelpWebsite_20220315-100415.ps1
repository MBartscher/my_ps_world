[CmdletBinding(SupportsShouldProcess)]
#--------------------------------------------------------------------------------------------------------------------------------#
#--------Parameters--------------------------------------------------------------------------------------------------------------#
#--------------------------------------------------------------------------------------------------------------------------------#
param(
 [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()][string]$strFolderPath,
 [Parameter()][switch]$createNewTxtFiles,
 [Parameter()][switch]$updateHelp,
 [Parameter()][switch]$continue
)
begin{
 if(-not($strAliasMask)){C:\DASI\Skripte\Powershell\Working\MyAliases.ps1}
 #--------------------------------------------------------------------------------------------------------------------------------#
 #--------Fuctions----------------------------------------------------------------------------------------------------------------#
 #--------------------------------------------------------------------------------------------------------------------------------#
 function Create-HTMLFile{
  param(
   [Parameter(Mandatory=$true)][string]$strPath,
   [Parameter(Mandatory=$true)][string]$strName,
   [Parameter(Mandatory=$true)][string]$strTitle,
   [Parameter(Mandatory=$true)][AllowEmptyString()][string]$strBody
  )
  if(Test-Path(-join($strPath,'\',$strName,'.htm'))){Remove-Item -Path (-join($strPath,'\',$strName,'.htm')) -Force}
  if($strBody){New-Item -Path $strPath -Force -ItemType File -Name (-join($strName,'.htm')) -Value ([string](ConvertTo-Html -Title $strTitle -Body $strBody))}
  $strPath=$null
  $strName=$null
  $strTitle=$null
  $strBody=$null
 }
 function Create-ContentFromTxtFile{
  param(
   [Parameter(Mandatory=$true)][string]$strTxtPath,
   [Parameter(Mandatory=$true)][string]$strName,
   [Parameter(Mandatory=$true)][string[]]$astrAll,
   [Parameter(Mandatory=$true)][string]$strContentStart
  )
  [string[]]$astrContentRaw=Get-Content -Path (-join($strTxtPath,'\',$strName,'.txt')) -Force
  if($astrContentRaw){
   [string]$strContentFinal=$strContentStart
   if($astrContentRaw[0]-ne''){$strContentFinal+=-join('<br>',"`n")}
   [int]$iRem=0
   Write-Host $astrContentRaw.Count -NoNewline
   [string]$strCurrentLine=''
   [string]$strNBSP='&nbsp;'
   [string]$strTab=$strNBSP*8
   for($i=0;$i-lt$astrContentRaw.Count;$i++){
    $iRem=Show-PercentPoints -intCount $i -intMax $astrContentRaw.Count -intOld $iRem
    $strCurrentLine=$astrContentRaw[$i]
    if($strCurrentLine-ne''){
     if($strCurrentLine-match' '){$strCurrentLine=$strCurrentLine-replace(' ',$strNBSP)}
     if($strCurrentLine-match'\t'){$strCurrentLine=$strCurrentLine-replace('\t',$strTab)}
     for($k=0;$k-lt$astrAll.Count;$k++){if($astrAll[$k]-ne$strName-and$strCurrentLine-match(-join('\b',$astrAll[$k],'\b'))){$strCurrentLine=$strCurrentLine-Replace((-join('\b',$astrAll[$k],'\b')),(-join(Create-Link -strInput $astrAll[$k] -NoNewLine)))}}
    }
    $strContentFinal+=-join($strCurrentLine,'<br>',"`n")
   }
   Write-Host
   $strContentFinal+='</font>'
  }
  else{[string]$strContentFinal=''}
  $strTxtPath=$null
  $strName=$null
  $astrAll=$null
  $strContentStart=$null
  $astrContentRaw=$null
  $iRem=$null
  $strCurrentLine=$null
  $strNBSP=$null
  $strTab=$null
  $i=$null
  $k=$null
  return $strContentFinal
 }
 function Create-ContentTableFromList{
  param(
   [Parameter()][string[]]$astr1D,
   [Parameter()][string[][]]$astr2D,
   [Parameter(Mandatory=$true)][string]$strContentStart,
   [Parameter()][switch]$ReplaceWordsWithSigns
  )
  if($ReplaceWordsWithSigns.IsPresent){$strContentStart=Replace-WordWithSign -strInput $strContentStart}
  [string]$strContentTable=$strContentStart
  if($astr1D){[string[]]$astr=$astr1d}
  elseif($astr2D){
   $astr=[string[]]::new($astr2D.Count)
   for($i=0;$i-lt$astr2D.Count;$i++){$astr[$i]=$astr2D[$i][0]}
  }
  [string]$strEntry=''
  [string]$strFilename=''
  for($i=0;$i-lt$astr.Count;$i++){
   if($astr1D){$strFilename=$strEntry=$astr[$i]}
   elseif($astr2D){
    $strEntry=$astr[$i]
    $strFilename=-join('content_',$strEntry)
   }
   if($ReplaceWordsWithSigns.IsPresent){$strEntry=Replace-WordWithSign -strInput $strEntry}
   $strContentTable=-join($strContentTable,'<a href=".\',$strFilename,'.htm">',$strEntry,'</a><br>',"`n")
  }
  $strContentTable+='</font>'
  $astr1D=$null
  $astr2D=$null
  $strContentStart=$null
  $astr=$null
  $i=$null
  $strEntry=$null
  $strFilename=$null
  return $strContentTable
 }
 function Replace-WordWithSign{
  param([Parameter(Mandatory=$true)][string]$strInput)
  [string]$strOutput=$strInput
  if($strOutput.Contains('Backslash')){$strOutput=$strOutput.Replace('Backslash','\')}
  if($strOutput.Contains('Slash')){$strOutput=$strOutput.Replace('Slash','/')}
  if($strOutput.Contains('Colon')){$strOutput=$strOutput.Replace('Colon',':')}
  if($strOutput.Contains('Asterisk')){$strOutput=$strOutput.Replace('Asterisk','*')}
  if($strOutput.Contains('QuestionMark')){$strOutput=$strOutput.Replace('QuestionMark','?')}
  if($strOutput.Contains('Quotes')){$strOutput=$strOutput.Replace('Quotes','"')}
  if($strOutput.Contains('LowerThen')){$strOutput=$strOutput.Replace('LowerThen','<')}
  if($strOutput.Contains('GreaterThen')){$strOutput=$strOutput.Replace('GreaterThen','>')}
  if($strOutput.Contains('Pipeline')){$strOutput=$strOutput.Replace('Pipeline','|')}
  $strInput=$null
  return $strOutput
 }
 function Create-Headline{
  param([parameter(Mandatory=$true)][string]$strInput)
  [string]$strOutput=-join('<strong>',$strInput,'</strong><br>',"`n",'<br>',"`n")
  $strInput=$null
  return $strOutput
 }
 function Create-Link{
  param(
   [parameter(Mandatory=$true)][string]$strInput,
   [parameter()][string]$strFilename,
   [parameter()][switch]$NoNewLine
  )
  [string]$strOutput=''
  if(-not$strFilename){$strFilename=$strInput}
  [string]$strOutput=-join('<a href=".\',$strFilename,'.htm">',$strInput,'</a>')
  if(-not$NoNewLine.IsPresent){$strOutput+=-join('<br>',"`n")}
  $strInput=$null
  $strFilename=$null
  return $strOutput
 }
}
process{
 #--------------------------------------------------------------------------------------------------------------------------------#
 #--------Script------------------------------------------------------------------------------------------------------------------#
 #--------------------------------------------------------------------------------------------------------------------------------#
 Clear-Host
 MakeSure-PathExists -strPath $strFolderPath
 #--------CreateHelpTxtFiles--------#
 #CreateHelpTxtFiles
 [bool]$bTxtFilesMissing=$false
 if(-not(Test-Path(-join($strFolderPath,'\txt')))){$bTxtFilesMissing=$true}
 if($createNewTxtFiles.IsPresent-or$bTxtFilesMissing){
  Write-Host '#=> CreateHelpTxtFiles'
  MakeSure-FolderExists -strParentPath $strFolderPath -strName 'txt'
  if($updateHelp.IsPresent){Create-HelpTxtsComplet -strFolderPath (($strFolderPath,'txt')-join'\') -updateHelp}
  else{Create-HelpTxtsComplet -strFolderPath (($strFolderPath,'txt')-join'\')}
 }
 #--------CreateSortedLists&SitesFromSortedLists--------#
 Write-Host '#=> create `$astrAll'
 [string[]]$astrAll=$null
 [int]$iRem=0
 [System.IO.FileInfo[]]$aflinfTxtFiles=Get-ChildItem(($strFolderPath,'txt')-join'\')|Sort-Object -Property Name
 for([int]$i=0;$i-lt$aflinfTxtFiles.Count;$i++){
  $iRem=Show-PercentPoints -intCount $i -intMax $aflinfTxtFiles.Count -intOld $iRem
  if(Get-Content -Path $aflinfTxtFiles[$i].FullName -Force){$astrAll+=$aflinfTxtFiles[$i].Name.replace('.txt','')}
 }
 Write-Host "#=> create other `$astr's & sort"
 [string[]]$astrAbout=$null
 [string[][]]$astrVerbs=$null
 [string[][]]$astrNouns=$null
 [string[]]$astrOthers=$null
 [bool]$bAllreadyIncluded=$false
 [string[]]$astrSplitted=$null
 [string]$strTitleTemplate='Powershell Help '
 [string]$strLinkAbout=Create-Link -strInput 'about' -strFilename 'content_about'
 [string]$strLinkVerbs=Create-Link -strInput 'allverbs' -strFilename 'content_allverbs'
 [string]$strLinkNouns=Create-Link -strInput 'allnouns' -strFilename 'content_allnouns'
 [string]$strLinkOthers=Create-Link -strInput 'others' -strFilename 'content_others'
 [string]$strLinkAll=Create-Link -strInput 'all' -strFilename 'content_all'
 [string]$strLinkMain=-join('<br>',"`n",(Create-Link -strInput 'main'))
 [string]$strStartContent=-join('<font face = "Courier New">',$strLinkMain)
 [bool]$bHtmlExists=$false
 for($i=0;$i-lt$astrAll.Count;$i++){
  Write-Host(-join('(',($i+1),'/',$astrAll.Count,')'))
  if($continue.IsPresent){if((Test-Path -Path(-join($strFolderPath,'\',$astrAll[$i],'.htm')))){$bHtmlExists=$true}}
  if(-not$continue.IsPresent-or-not$bHtmlExists){$strStartContent=-join('<font face = "Courier New">',$strLinkMain)}
  if($astrAll[$i].contains('about')){
   $astrAbout+=$astrAll[$i]
   Write-Host ' ' $astrAll[$i]
   if(-not$continue.IsPresent-or-not$bHtmlExists){$strStartContent+=$strLinkAbout}
  }
  elseif($astrAll[$i].contains('-')){
   $astrSplitted=$astrAll[$i].split('-')
   if(-not$continue.IsPresent-or-not$bHtmlExists){$strStartContent+=-join('Command<br>',"`n",(Create-Headline -strInput (-join((Create-Link -strInput $astrSplitted[0] -strFilename (-join('content_',$astrSplitted[0])) -NoNewLine),'-',(Create-Link -strInput $astrSplitted[1] -strFilename (-join('content_',$astrSplitted[1])) -NoNewLine)))))}
   Write-Host ' ' $astrVerbs.Count
   if($astrVerbs-ne$null){
    if($astrSplitted[0]-eq$astrVerbs[$astrVerbs.Count-1][0]){$bAllreadyIncluded=$true}
    if(-not$bAllreadyIncluded){
     $astrVerbs+=@($astrSplitted[0])
     $astrVerbs[$astrVerbs.Count-1]+=$astrAll[$i]
     Write-Host ' ' $astrSplitted[0]
    }
    else{$astrVerbs[$astrVerbs.Count-1]+=$astrAll[$i]}
   }
   else{
    $astrVerbs+=@($astrSplitted[0])
    $astrVerbs[$astrVerbs.Count-1]+=$astrAll[$i]
    Write-Host ' ' $astrSplitted[0]
   }
   $bAllreadyIncluded=$false
   $iRem=0
   if($astrNouns-ne$null){
    Write-Host ' ' $astrNouns.Count ' ' -NoNewline
    for($k=0;$k-lt$astrNouns.Count;$k++){
     $iRem=Show-PercentPoints -intCount $k -intMax $astrNouns.Count -intOld $iRem
     $bAllreadyIncluded=$astrNouns[$k][0]-eq($astrSplitted[1])
     if($bAllreadyIncluded){
      Write-Host ($k+1)
      break
     }
    }
    if(-not$bAllreadyIncluded){
     $astrNouns+=@($astrSplitted[1])
     $astrNouns[$k]+=$astrAll[$i]
     Write-Host $astrSplitted[1]
    }
    else{$astrNouns[$k]+=$astrAll[$i]}
   }
   else{
    $astrNouns+=@($astrSplitted[1])
    $astrNouns[0]+=$astrAll[$i]
    Write-Host ' ' $astrSplitted[1]
   }
  }
  else{
   $astrOthers+=$astrAll[$i]
   Write-Host ' ' $astrAll[$i]
   if(-not$continue.IsPresent-or-not$bHtmlExists){$strStartContent+=$strLinkOthers}
  }
  if(-not$continue.IsPresent-or-not$bHtmlExists){Create-HTMLFile -strPath $strFolderPath -strName $astrAll[$i] -strTitle (-join($strTitleTemplate,$astrAll[$i])) -strBody (Create-ContentFromTxtFile -strTxtPath (-join($strFolderPath,'\txt')) -strName $astrAll[$i] -astrAll $astrAll -strContentStart $strStartContent)}
  $bHtmlExists=$false
  $strStartContent=-join('<font face = "Courier New">',$strLinkMain)
 }
 Write-Host "#=> sort `$astrNouns"
 Write-Host $astrNouns.Count -NoNewline
 $iRem=0
 [bool]$bSwapped=$false
 [string[]]$astrRem=$null
 for($i=1;$i-lt$astrNouns.Count;$i++){
  $iRem=Show-PercentPoints -intCount $i -intMax $astrNouns.Count -intOld $iRem
   $bSwapped=$false
  for($k=0;$k-lt$astrNouns.Count-$i;$k++){
   if($astrNouns[$k][0]-gt$astrNouns[$k+1][0]){
    $astrRem=$astrNouns[$k]
    $astrNouns[$k]=$astrNouns[$k+1]
    $astrNouns[$k+1]=$astrRem
    $astrRem=$null
    $bSwapped=$true
   }
  }
  if(-not$bSwapped){break}
 }
 Write-Host
 #--------CreateMain--------#
 if($continue.IsPresent){if((Test-Path -Path (-join($strFolderPath,'\main.htm')))){$bHtmlExists=$true}}
 if(-not$continue.IsPresent-or-not$bHtmlExists){
  [string]$strContent=-join('<font face = "Courier New"><br>',"`n")
  $strContent+=Create-Headline -strInput 'Main'
  $strContent+=$strLinkAbout
  $strContent+=$strLinkVerbs
  $strContent+=$strLinkNouns
  $strContent+=$strLinkOthers
  $strContent+=$strLinkAll
  $strContent+='</font>'
  Create-HTMLFile -strPath $strFolderPath -strName 'main' -strTitle (-join($strTitleTemplate,'Main')) -strBody $strContent
 }
 $bHtmlExists=$false
 #--------CreateSitesFromSortedLists--------#
 if($continue.IsPresent){if((Test-Path -Path (-join($strFolderPath,'\content_about.htm')))){$bHtmlExists=$true}}
 if(-not$continue.IsPresent-or-not$bHtmlExists){Create-HTMLFile -strPath $strFolderPath -strName 'content_about' -strTitle (-join($strTitleTemplate,'about')) -strBody (Create-ContentTableFromList -astr1D $astrAbout -strContentStart (-join($strStartContent,(Create-Headline -strInput 'About'))))}
 $bHtmlExists=$false
 if($continue.IsPresent){if((Test-Path -Path (-join($strFolderPath,'\content_allverbs.htm')))){$bHtmlExists=$true}}
 if(-not$continue.IsPresent-or-not$bHtmlExists){Create-HTMLFile -strPath $strFolderPath -strName 'content_allverbs' -strTitle (-join($strTitleTemplate,'verbs')) -strBody (Create-ContentTableFromList -astr2D $astrVerbs -strContentStart (-join($strStartContent,(Create-Headline -strInput 'Allverbs'))) -ReplaceWordsWithSigns)}
 $bHtmlExists=$false
 for($i=0;$i-lt$astrVerbs.Count;$i++){
  if($continue.IsPresent){if((Test-Path -Path (-join($strFolderPath,'\content_',$astrVerbs[$i][0],'.htm')))){$bHtmlExists=$true}}
  if(-not$continue.IsPresent-or-not$bHtmlExists){Create-HTMLFile -strPath $strFolderPath -strName (-join('content_',$astrVerbs[$i][0])) -strTitle (-join($strTitleTemplate,$astrVerbs[$i][0])) -strBody (Create-ContentTableFromList -astr1D $astrVerbs[$i][1..($astrVerbs[$i].Count-1)] -strContentStart (-join($strStartContent,$strLinkVerbs,(Create-Headline -strInput $astrVerbs[$i][0]))) -ReplaceWordsWithSigns)}
  $bHtmlExists=$false
 }
 if($continue.IsPresent){if((Test-Path -Path (-join($strFolderPath,'\content_allnouns.htm')))){$bHtmlExists=$true}}
 if(-not$continue.IsPresent-or-not$bHtmlExists){Create-HTMLFile -strPath $strFolderPath -strName 'content_allnouns' -strTitle (-join($strTitleTemplate,'nouns')) -strBody (Create-ContentTableFromList -astr2D $astrNouns -strContentStart (-join($strStartContent,(Create-Headline -strInput 'Allnouns'))) -ReplaceWordsWithSigns)}
 $bHtmlExists=$false
 for($i=0;$i-lt$astrNouns.Count;$i++){
  if($continue.IsPresent){if((Test-Path -Path (-join($strFolderPath,'\content_',$astrNouns[$i][0],'.htm')))){$bHtmlExists=$true}}
  if(-not$continue.IsPresent-or-not$bHtmlExists){Create-HTMLFile -strPath $strFolderPath -strName (-join('content_',$astrNouns[$i][0])) -strTitle (-join($strTitleTemplate,$astrNouns[$i][0])) -strBody (Create-ContentTableFromList -astr1D $astrNouns[$i][1..($astrNouns[$i].Count-1)] -strContentStart (-join($strStartContent,$strLinkNouns,(Create-Headline -strInput $astrNouns[$i][0]))) -ReplaceWordsWithSigns)}
  $bHtmlExists=$false
 }
 if($continue.IsPresent){if((Test-Path -Path (-join($strFolderPath,'\content_others.htm')))){$bHtmlExists=$true}}
 if(-not$continue.IsPresent-or-not$bHtmlExists){Create-HTMLFile -strPath $strFolderPath -strName 'content_others' -strTitle (-join($strTitleTemplate,'others')) -strBody (Create-ContentTableFromList -astr1D $astrOthers -strContentStart (-join($strStartContent,(Create-Headline -strInput 'Others'))) -ReplaceWordsWithSigns)}
 $bHtmlExists=$false
 if($continue.IsPresent){if((Test-Path -Path (-join($strFolderPath,'\content_all.htm')))){$bHtmlExists=$true}}
 if(-not$continue.IsPresent-or-not$bHtmlExists){Create-HTMLFile -strPath $strFolderPath -strName 'content_all' -strTitle (-join($strTitleTemplate,'all')) -strBody (Create-ContentTableFromList -astr1D $astrAll -strContentStart (-join($strStartContent,(Create-Headline -strInput 'All'))) -ReplaceWordsWithSigns)}
 $bHtmlExists=$false
 #--------StartFinishedWebsite--------#
 Invoke-Item (-join($strFolderPath,'\main.htm'))
}
end{
 $bTxtFilesMissing=$null
 $astrAll=$null
 $astrAbout=$null
 $astrVerbs=$null
 $astrNouns=$null
 $astrOthers=$null
 $bAllreadyIncluded=$null
 $iRem=$null
 $astrSplitted=$null
 $strTitleTemplate=$null
 $strLinkAbout=$null
 $strLinkVerbs=$null
 $strLinkNouns=$null
 $strLinkOthers=$null
 $strLinkAll=$null
 $strLinkMain=$null
 $strStartContent=$null
 $bHtmlExists=$null
 $i=$null
 $k=$null
 $bSwapped=$null
 $astrRem=$null
 $strContent=$null
 [System.GC]::Collect()
 Write-Errorlog
}