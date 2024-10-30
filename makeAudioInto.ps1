[CmdletBinding()]
param (
    [Parameter(mandatory=$false)]
    [string]$ffmpegPath = "F:\software\ffmpeg-7.0.2-essentials_build\bin\ffmpeg.exe",
    
    [Parameter(mandatory=$true, ParameterSetName="A")] [switch]$appleLAC,
    [Parameter(mandatory=$true, ParameterSetName="F")] [switch]$freeLAC
)
if(-Not (Test-Path $ffmpegPath)) { throw "ffmpeg install not found at specified location $ffmpegPath." }
Write-Verbose "ffmpeg found"

switch ($PSCmdlet.ParameterSetName) {
    "A" {
        Write-Verbose "setting variables for converting to ALAC"
        $allhits = Get-ChildItem -Include *.flac -Recurse
        $codec = "alac"
        $ext = ".m4a"
    }
    "F" {
        Write-Verbose "setting variables for converting to FLAC"
        $allhits = Get-ChildItem -Include *.m4a -Recurse # -include only works if -recurse is also there
        $codec = "flac"
        $ext = ".flac"
    }
}

($allhits).fullname
Write-Warning "Proceeding will delete ALL files in the list above, and replace them with $ext equivalents." -WarningAction Inquire

foreach($i in $allhits) {
    $oldPath = $i.FullName
    $newPath = $i.DirectoryName + "\" + $i.BaseName + $ext
    Start-Process -FilePath $ffmpegPath -ArgumentList " -i `"$oldPath`" -c:v copy -c:a $codec `"$newPath`" -hide_banner " -NoNewWindow -Wait
    Remove-Item $oldPath
}