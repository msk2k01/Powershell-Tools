[CmdletBinding()]
param (
    [Parameter(mandatory=$false)]
    [string] $MediaRoot = "G:\media\tv", # folder where shows are located
    [string] $ShowName = "" # subfolder containing a specific show to watch; (if not passed, script searches entire root)
)

# Assertions
Invoke-Expression -Command "$PSScriptRoot/ineed.ps1 `"C:\Program Files\VideoLAN\VLC\vlc.exe`" "
if(-Not (Test-Path "$MediaRoot\$ShowName")) { throw "The media location $MediaRoot\$ShowName could not be found." }

Write-Verbose "Indexing episodes..."
$ep = Get-ChildItem $MediaRoot\$ShowName -Include *.mkv, *.mp4 -Recurse
$index = Get-Random -Maximum ($ep.length-1)

Write-Verbose "Playing Episode: $($ep[$index].FullName)"
Start-Process -FilePath "C:\Program Files\VideoLAN\VLC\vlc.exe" -ArgumentList "--fullscreen `"$($ep[$index].FullName)`""

Write-Verbose "End of script reached. Exiting"
exit