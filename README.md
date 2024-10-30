# Powershell-Tools

## amuseme
This script picks a random video within a folder (including its subfolders) and opens it with VLC.

## icloudPhotoBackup
**Note: This script is no longer being actively maintained or tested.**

This script locates a downloaded archive of my iCloud Photos camera roll and extracts it into my folder structure for photo backups. It is designed to be very safe by performing a number of checks beforehand:

1. Verifying the existence of both the expected source archive, and the intended extraction destination.
2. Extracting to a "temporary" folder before moving each item to the intended destination. A check for old temporary folders is also done.
3. Verifying that the date of the source archive matches the current date. This is for cases when old `iCloud Photos.zip` archives are left in the downloads folder, and the new one gets a different name (such as `iCloud Photos(1).zip`). A warning is shown if the dates do not match (which usually suggests it's about to operate on an unintended archive).

The passing of each check can be verified by running the script with the -Verbose flag.

## makeAudioInto
An interface to easily convert music files between ALAC and FLAC formats using ffmpeg. Both formats are lossless, so no fidelity is lost between conversions. Most metadata, including album art, is preserved in the conversion. The mode of conversion is specified by passing either the `-appleLAC` or `-freeLAC` parameter at runtime. For instance, `makeAudioInto.ps1 -appleLAC` will find all .flac files in the current folder (and any subdirectories) and convert them to ALAC format.

This script replaced an older variant, which only converted files into ALAC. It also introduces a confirmation prompt which reminds the user that the old files will be deleted before continuing. The old version required the user to manually authorize the deletion of each old file.

## saveme
This script quickly opens WinMerge for directory comparisons with custom parameters. It compares two folders with identical folder paths, except for the drive letter. 

Several safe coding practices have been employed to avoid unwanted behavior:
* Extensive usage of Verbose output for debugging purposes
* Passing `-ErrorAction Stop` to some cmdlets called, such that any errors terminate execution
* Explicitly typecasting the internal and external drive letters to chars
* The script will not run if an external drive (whose friendly name matches `$ExternalCopyName`) is not detected, even if the comparison to make does not utilize it. This is intentional and serves as a reminder to back up the data being operated on.
* using `throw` to produce terminating errors (as opposed to `Write-Error`, which throws non-terminating errors)
* Logging all comparisons made in a text file

# Usage
I've tried writing these scripts such that most specific folder and file paths are easily user-defined through parameters. However I have not yet tested them on other people's computers, or with different folder structures. Default parameter values are set based on how my personal computer is set up, so others interested in using these scripts may want to change those defaults to something more useful to them.
