[CmdletBinding(SupportsShouldProcess)]
param()
begin{}
process{
 Write-Host 'CommandOrigin:',$strTab,$MyInvocation.CommandOrigin,$strBreak
 Write-Host 'DisplayScriptPosition:',$strTab,$MyInvocation.DisplayScriptPosition,$strBreak
 Write-Host 'InvocationName:',$strTab,$MyInvocation.InvocationName,$strBreak
 Write-Host 'Line:',$strTab,$MyInvocation.Line,$strBreak
 Write-Host 'MyCommand.Name:',$strTab,$MyInvocation.MyCommand.Name,$strBreak
 Write-Host 'MyCommand.ScriptBlock:',$strBreak,$MyInvocation.MyCommand.ScriptBlock,$strBreak
 Write-Host 'MyCommand.Source:',$strTab,$MyInvocation.MyCommand.Source,$strBreak
 Write-Host 'OffsetInLine:',$strTab,$MyInvocation.OffsetInLine,$strBreak
 Write-Host 'PSCommandPath:',$strTab,$MyInvocation.PSCommandPath,$strBreak
 Write-Host 'PSScriptRoot:',$strTab,$MyInvocation.PSScriptRoot,$strBreak
 Write-Host 'ScriptLineNumber:',$strTab,$MyInvocation.ScriptLineNumber,$strBreak
 Write-Host 'ScriptName:',$strTab,$MyInvocation.ScriptName,$strBreak
}
end{}