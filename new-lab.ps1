<#
.SYNOPSIS
    Scaffolds a new lab directory and standardized walkthrough README for INE certification tracks.

.DESCRIPTION
    Creates the required directory structure, subfolders for images/scripts, and copies 
    the standardized walkthrough template with pre-filled metadata.

.PARAMETER Track
    Certification track name (default: "eJPT").

.PARAMETER Module
    Curriculum module / course name (e.g., "Assessment Methodologies", "Host & Network Penetration Testing").

.PARAMETER LabName
    Name of the lab challenge (e.g., "Footprinting & Scanning CTF 1").

.PARAMETER Difficulty
    Difficulty rating (default: "Medium").

.EXAMPLE
    .\new-lab.ps1 -Module "Assessment Methodologies" -LabName "Footprinting CTF 1" -Difficulty "Medium"
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$Track = "eJPT",

    [Parameter(Mandatory = $true)]
    [string]$Module,

    [Parameter(Mandatory = $true)]
    [string]$LabName,

    [Parameter(Mandatory = $false)]
    [ValidateSet("Easy", "Easy / Medium", "Medium", "Intermediate", "Hard")]
    [string]$Difficulty = "Medium"
)

$ErrorActionPreference = "Stop"

$rootPath = $PSScriptRoot
$templatePath = Join-Path $rootPath "$Track\template.md"

if (-not (Test-Path $templatePath)) {
    Write-Error "Template file not found at: $templatePath"
    exit 1
}

$labDir = Join-Path $rootPath "$Track\$Module\$LabName"
$imagesDir = Join-Path $labDir "images"
$scriptsDir = Join-Path $labDir "scripts"
$targetReadme = Join-Path $labDir "README.md"

if (Test-Path $targetReadme) {
    Write-Warning "Lab README already exists at: $targetReadme"
    $overwrite = Read-Host "Do you want to overwrite it? (y/N)"
    if ($overwrite -ne "y" -and $overwrite -ne "Y") {
        Write-Host "Operation cancelled." -ForegroundColor Yellow
        exit 0
    }
}

# Create folder structure
New-Item -ItemType Directory -Path $imagesDir -Force | Out-Null
New-Item -ItemType Directory -Path $scriptsDir -Force | Out-Null

# Read template and substitute variables
$templateContent = Get-Content -Path $templatePath -Raw
$currentDate = (Get-Date).ToString("dd MMMM yyyy")

$walkthroughContent = $templateContent.Replace("[Lab Name]", $LabName)
$walkthroughContent = $walkthroughContent.Replace("[Course Name, e.g. Assessment Methodologies: Footprinting & Scanning]", "$($Module): $($LabName)")
$walkthroughContent = $walkthroughContent.Replace("[Easy / Medium / Hard]", $Difficulty)
$walkthroughContent = $walkthroughContent.Replace("YYYY-MM-DD", $currentDate)

Set-Content -Path $targetReadme -Value $walkthroughContent -Encoding UTF8

Write-Host " Lab scaffolded successfully!" -ForegroundColor Green
Write-Host " Target Directory: $labDir" -ForegroundColor Cyan
Write-Host " Walkthrough File: $targetReadme" -ForegroundColor Cyan
Write-Host " Next Steps:" -ForegroundColor Yellow
Write-Host "  1. Save your sequential screenshots in: $imagesDir"
Write-Host "  2. Save custom exploits/scripts in:     $scriptsDir"
Write-Host "  3. Open and complete your walkthrough:  $targetReadme"
