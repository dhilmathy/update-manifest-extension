[CmdletBinding()]
param()

Trace-VstsEnteringInvocation $MyInvocation
try
{
	# Get the inputs.
	[string] $manifestFilePaths = Get-VstsInput -Name manifestFilePaths -Require
    [string] $nodeToUpdate = Get-VstsInput -Name nodeToUpdate -Require
    [string] $valueToUpdate = Get-VstsInput -Name valueToUpdate
    [string] $isVersion = Get-VstsInput -Name isVersion -Require
    [string] $versionPart = Get-VstsInput -Name versionPart

	# Invoke the script to do the actual work.
	$scriptFilePath = Join-Path -Path $PSScriptRoot -ChildPath '\update-manifest.ps1'
    Write-Host $scriptFilePath
	& $scriptFilePath -manifestFilePaths $manifestFilePaths -nodeToUpdate $nodeToUpdate -valueToUpdate $valueToUpdate -isVersion $isVersion -versionPart $versionPart
}
finally
{
	Trace-VstsLeavingInvocation $MyInvocation
}