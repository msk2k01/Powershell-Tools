[CmdletBinding()]
param (
    [Parameter(mandatory=$false)]
    [string]$ffmpegPath = "F:\software\ffmpeg.exe"
)
if(-Not (Test-Path $ffmpegPath)) { throw "ffmpeg install not found at specified location $ffmpegPath." }
Write-Verbose "ffmpeg found"

foreach($i in (Get-ChildItem -Include *.flac, *.wav -Recurse)) { # -include only works if -recurse is also there
    Start-Process -FilePath $ffmpegPath -ArgumentList " -i `"$pwd\$($i.Name)`" -c:v copy -c:a alac `"$pwd\$($i.BaseName).m4a`" -hide_banner " -NoNewWindow -Wait
    Remove-Item $i -Confirm
}
Get-ChildItem