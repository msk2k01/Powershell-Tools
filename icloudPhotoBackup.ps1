[CmdletBinding()]
param (
    [Parameter(mandatory=$false)]
    [string]$Source = "$env:userprofile\Downloads\iCloud Photos.zip",                                                                   # path of expected zip of icloud download
    [string]$InternalDriveName = "Data",                                                                                                # name (NOT drive letter) of photos directory (used for $Destination below)
    [string]$Destination = "$((Get-Volume -FriendlyName "$InternalDriveName" -ErrorAction Stop).DriveLetter):\photos\2024"              # where to store the extracted photos
)
Write-Verbose "Using source archive $Source and destination folder $Destination"

$ExtractionTarget = "$Source\..\iCloud Photos"  # When Expand-Archive is performed, this is the folder where the extracted files go. Set to source archive's containing folder.

# Validate existence of source and destination.
if(-Not (Test-Path "$Source")) { throw "Source archive $Source was not found." }
if(-Not (Test-Path "$Destination")) { throw "Destination folder $Destination was not found." }
Write-Verbose "$Source and $Destination existence validated."

# Validate that extraction target folder does not exist
if(Test-Path "$ExtractionTarget") {
    Write-Warning "Extraction target folder $ExtractionTarget already exists."
    Remove-Item -Path "$ExtractionTarget" -Confirm
    if(Test-Path "$ExtractionTarget") {throw "Extraction target folder $ExtractionTarget already exists; delete before continuing."} # Refuse to operate if permission to delete denied.
}
Write-Verbose "Extraction target $ExtractionTarget known to not exist."

# Validate that source is up to date
if(-Not ((Get-ChildItem $Source).LastWriteTime.ToShortDateString() -eq (Get-Date).ToShortDateString())) {
    Write-Warning "Source archive $Source's last write time does not match today's date." -WarningAction Inquire
}

Write-Host "All validations complete. Performing extraction..."
Expand-Archive -LiteralPath "$Source" -Destination "$Source\..\" -ErrorAction Stop

# Move extracted photos where they belong
Write-Host "Moving extracted photos to $Destination..."
foreach($i in Get-ChildItem "$ExtractionTarget") {
    Move-Item -Path "$($i.FullName)" -Destination "$Destination"
}

Remove-Item "$ExtractionTarget"
Write-Host "Extraction target folder $ExtractionTarget deleted."

Write-Host "Photos extracted to $Destination" -ForegroundColor Green