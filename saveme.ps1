[CmdletBinding()]
param (
    # Script must be called with either a specified $Directory (parameter set A) or with $Shortcut (set B). Otherwise the script will not be executed.
    [Parameter(mandatory=$true, ParameterSetName="A")] 
    [string]$Directory,

    [Parameter(mandatory=$true, ParameterSetName="B")]
    [int]$Shortcut, 
    
    [Parameter(mandatory=$false)]
    [string]$InternalCopyName = "Data", # name (NOT drive letter) of left drive
    [string]$ExternalCopyName = "Data-Backup",  # name (NOT drive letter) of right drive
    [string]$ShortcutsFile = "$PSScriptRoot\saveme-shortcuts.ps1", # file containing comparison shortcuts
    [string]$winmergePath = "C:\Program Files\WinMerge\WinMergeU.exe"
)

# WinMerge dependency check
if(-Not (Test-Path $winmergePath)) { throw "64-bit WinMerge install not found." }

# Get the drive letters for the drives to compare between
[char]$n = (Get-Volume -FriendlyName $InternalCopyName -ErrorAction Stop).DriveLetter
Write-Verbose "$InternalCopyName drive's DriveLetter detected as $n."
[char]$x = (Get-Volume -FriendlyName $ExternalCopyName -ErrorAction Stop).DriveLetter
Write-Verbose "$ExternalCopyName drive's DriveLetter detected as $x."

# Define log file stored on external drive
$log = "$($x):\saveme-log.txt"

switch ($PSCmdlet.ParameterSetName) {
    "A" {
        Write-Verbose "Entering execution path A (DIRECTORY compare using given argument $Directory)"
        
        $folder = Split-Path (Convert-Path $Directory -ErrorAction Stop) -NoQualifier
        Write-Verbose "Directory to compare parsed as $folder"

        Add-Content -Path "$log" -Value "$(Get-Date -Format "yyyy-MM-dd HH:mm") on $env:computername...`t$($n):$($folder)`t$($x):$($folder)"
        Write-Verbose "Calling WinMergeU with arguments $($n):$($folder) and $($x):$($folder)"
        Start-Process -FilePath $winmergePath -ArgumentList " `"$($n):$($folder)`" `"$($x):$($folder)`" /r /fl "
        break
    }
    "B" {
        Write-Verbose "Entering execution path B (SHORTCUT)"

        # import shortcuts. to make the code more modular, shortucts are defined in a separate file. This defines $comps into this script
        Write-Verbose "Attempting to import shortcuts from $ShortcutsFile"
        if(Test-Path "$ShortcutsFile") { . "$ShortcutsFile" }
        else { throw "$ShortcutsFile could not be found." }

        if(-Not($Shortcut -In 0..($comps.length-1))) { # if an invalid index is passed
            
            # generate table of shortcuts
            $index = 0
            foreach($i in $comps) {
                Add-Member -InputObject $i -MemberType NoteProperty -Name "Index" -Value $index
                $index += 1
            }

            $comps | Format-Table -Property Index, Label, Left, Right, Filters
            throw "Comparison index out of range. See above table for valid comparisons."
        }

        Add-Content -Path "$log" -Value "$(Get-Date -Format "yyyy-MM-dd HH:mm") on $env:computername...`t$($comps[$Shortcut].Left)`t$($comps[$Shortcut].Right)`tFilter: $($comps[$Shortcut].Filters)"
        Write-Verbose "Calling Winmerge with arguments $($comps[$Shortcut].Left) and $($comps[$Shortcut].Right) with filter $($comps[$Shortcut].Filters)"
        Start-Process -FilePath $winmergePath -ArgumentList " `"$($comps[$Shortcut].Left)`" `"$($comps[$Shortcut].Right)`" /r /fl /f `"$($comps[$Shortcut].Filters)`" "
        break
    }
}

Write-Verbose "End of script reached. Exiting"
exit
