[CmdletBinding()]
param (
    [Parameter(mandatory=$true)]
    [string]$ProgramPath
)

if(-Not (Test-Path $ProgramPath)) { throw "An external program $ProgramPath necessary for script functionality could not be found." }
else { Write-Verbose "Dependency check: $ProgramPath found" }