# Powershell-Tools
This repository is a showcase of PowerShell scripts I've written that I use on a semi-regular basis. Scripts my be added or removed to this repository based on what I am currently using at the time.

# Script Descriptions

## amuseme
This script picks a random video within a folder (including its subfolders) and opens it with VLC. I use this to pick random episodes from my large library of TV show DVD rips.

## icloudPhotoBackup
This script locates a downloaded archive of my iCloud Photos camera roll and extracts it into my folder structure for photo backups. It is designed to be very safe by performing a number of checks beforehand:

1. Verifying the existence of both the expected source archive, and the intended extraction destination.
2. Extracting to a "temporary" folder before moving each item to the intended destination. A check for old temporary folders is also done.
3. Verifying that the date of the source archive matches todays date. This is for cases when old `iCloud Photos.zip` archives are left in the downloads folder, and the new one gets a different name (such as `iCloud Photos(1).zip`). A warning is shown if the dates do not match, which likely suggest it's about to operate on an unintended archive.

The passing of each check can be verified by running the script with the -Verbose flag.

## saveme
This script quickly opens WinMerge for directory comparisons with custom parameters. Notable features include:

1. "Shortcuts" to frequent, more advanced comparisons has been added. Initiating a comparison via a shortcut is mutually exclusive to using a directory path, enforced using Powershell parameter sets. For modularity, these are defined in a separate .ps1 file and stored in `$comps`. Here is an example shortcut entry:
    ```powershell
    [PSCustomObject]@{
            Index = "" # filled in automatically for displaying list in terminal
            Label = "Documents (Backlog Excluded)"  # description
            Left = "$($n):\files\documents" # directory to show on left side in WinMerge
            Right = "$($x):\files\documents"    # directory to show on right side in WinMerge
            Filters = "!_backlog\"  # search filters used by WinMerge
        },
    ```

2. The derivations of the two drives in which directories to compare are stored is more standardized than in earlier versions of this script that I wrote. For both drives, the script derives the drive letter from the drive's friendly name. The friendly names can be passed as parameters.

3. Error catching practice/exploring: Several practices have been employed to avoid unwanted behavior:
    * Extensive usage of Verbose output for debugging purposes
    * Passing `-ErrorAction Stop` to cmdlets called, such that any errors terminate execution
    * Explicitly typecasting the internal and external drive letters to chars
    * using `throw` to produce errors instead of `Write-Error` (`throw` produces terminating errors, which halts execution)
    * Calling WinMerge with `Start-Process` instead of adding it to path and calling directly (allows for better control flow using `-Wait` flag)

## turnTheseIntoALAC
This script finds each FLAC or WAV file in a folder and converts them to ALAC with ffmpeg.

# Usage
I've tried writing these scripts such that most specific folder and file paths are easily user-defined through parameters. However I have not yet tested them on other people's computers, or with different folder structures. Default parameter values are set based on how my personal computer is set up, so others interested in using these scripts may want to change those defaults to something more useful to them.