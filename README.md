# Powershell-Tools
This repository is a showcase of PowerShell scripts I've written that I use on a semi-regular basis. Scripts my be added to or removed from this repository, based on what I'm currently using at the time.

# Script Descriptions

## amuseme
This script picks a random video within a folder (including its subfolders) and opens it with VLC. I use this to pick random episodes from my large library of TV show DVD rips.

## icloudPhotoBackup
This script locates a downloaded archive of my iCloud Photos camera roll and extracts it into my folder structure for photo backups. It is designed to be very safe by performing a number of checks beforehand:

1. Verifying the existence of both the expected source archive, and the intended extraction destination.
2. Extracting to a "temporary" folder before moving each item to the intended destination. A check for old temporary folders is also done.
3. Verifying that the date of the source archive matches the current date. This is for cases when old `iCloud Photos.zip` archives are left in the downloads folder, and the new one gets a different name (such as `iCloud Photos(1).zip`). A warning is shown if the dates do not match (which usually suggests it's about to operate on an unintended archive).

The passing of each check can be verified by running the script with the -Verbose flag.

## saveme
This script quickly opens WinMerge for directory comparisons with custom parameters. Two modes of execution have been implemented and are detailed below.

### "Directory" Mode
"Directory" mode compares two folders with identical folder paths, except for the drive letter. (This mode is used most often, as I use this script to manage a mirror copy of my computer's data drive.)

### "Shortcut" Mode 
"Shortcut" mode is used for more advanced comparisons, such as those with file type or subfolder filters, and comparisons between folders without identical paths. 

By default, shortcuts are stored in the same folder as the script, in a file named `shortcuts-saveme.ps1`. This file contains a `$comps` array which stores each shortcut as a PSCustomObject. The script imports `$comps` during execution and reads the shortcuts from it.

Since it isn't included in the repository, here's an example of what `shortcuts-saveme.ps1` looks like with a sample shortcut:

```powershell
$comps = @(
    [PSCustomObject]@{
        Label = "Documents (Backlog Excluded)"  # description
        Left = "$($env:userprofile)\documents" # directory to show on left side in WinMerge
        Right = "$($x):\files\documents"    # directory to show on right side in WinMerge
        Filters = "!_backlog\"  # search filters used by WinMerge
    },
    # ...repeat for each shortcut
)
```

In defining shortcut paths, one can use `$($n)` to refer to the drive letter of the internal drive, and `$($x)` for the drive letter of the external drive. (This is the same syntax that's used by the script.)

When the `-Shortcut` switch is passed at runtime, a menu is displayed of all shortcuts from which the user can select.

### Safegaurds
Several safe coding practices have been employed to avoid unwanted behavior:
* Extensive usage of Verbose output for debugging purposes
* Passing `-ErrorAction Stop` to some cmdlets called, such that any errors terminate execution
* Explicitly typecasting the internal and external drive letters to chars
* The script will not run if an external drive (whose friendly name matches `$ExternalCopyName`) is not detected, even if the comparison to make does not utilize it. This is intentional and serves as a reminder to back up the data being operated on.
* using `throw` to produce terminating errors (as opposed to `Write-Error`, which throws non-terminating errors)
* Logging all comparisons made in a text file

## turnTheseIntoALAC
This script finds each FLAC or WAV file in a folder and converts them to ALAC with ffmpeg.

# Usage
I've tried writing these scripts such that most specific folder and file paths are easily user-defined through parameters. However I have not yet tested them on other people's computers, or with different folder structures. Default parameter values are set based on how my personal computer is set up, so others interested in using these scripts may want to change those defaults to something more useful to them.