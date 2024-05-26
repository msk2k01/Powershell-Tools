Invoke-Expression -Command "$PSScriptRoot/ineed.ps1 `"F:\software\ffmpeg.exe`" "

foreach($i in (Get-ChildItem -Include *.flac, *.wav -Recurse)) { # -include only works if -recurse is also there
    Start-Process -FilePath "F:\software\ffmpeg.exe" -ArgumentList " -i `"$pwd\$($i.Name)`" -c:v copy -c:a alac `"$pwd\$($i.BaseName).m4a`" -hide_banner " -NoNewWindow -Wait
    Remove-Item $i -Confirm
}
Get-ChildItem