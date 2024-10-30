[CmdletBinding()]
param (
    [Parameter(mandatory=$true)][string]$Directory,
    
    [Parameter(mandatory=$false)]
    [string]$InternalCopyName = "Data", # name (NOT drive letter) of left drive
    [string]$ExternalCopyName = "Data-Backup",  # name (NOT drive letter) of right drive
    [string]$WinmergePath = "C:\Program Files\WinMerge\WinMergeU.exe"
)

# WinMerge dependency check
if(-Not (Test-Path $WinmergePath)) { throw "64-bit WinMerge install not found." }
Write-Verbose "Winmerge executable found at $WinmergePath"

# Get the drive letters for the drives to compare between
[char]$n = (Get-Volume -FriendlyName $InternalCopyName -ErrorAction Stop).DriveLetter
Write-Verbose "$InternalCopyName drive's DriveLetter detected as $n."
[char]$x = (Get-Volume -FriendlyName $ExternalCopyName -ErrorAction Stop).DriveLetter
Write-Verbose "$ExternalCopyName drive's DriveLetter detected as $x."

$log = "$($x):\saveme-log.txt" # Define log file stored on external drive
$folder = Split-Path (Convert-Path $Directory -ErrorAction Stop) -NoQualifier
Write-Verbose "Directory to compare parsed as $folder"
Add-Content -Path "$log" -Value "$(Get-Date -Format "yyyy-MM-dd HH:mm") on $env:computername...`t$($n):$($folder)`t$($x):$($folder)"

Write-Verbose "Calling WinMergeU with arguments $($n):$($folder) and $($x):$($folder)"
Start-Process -FilePath $WinmergePath -ArgumentList " `"$($n):$($folder)`" `"$($x):$($folder)`" /r /fl "

Write-Verbose "End of script reached. Exiting"
exit
