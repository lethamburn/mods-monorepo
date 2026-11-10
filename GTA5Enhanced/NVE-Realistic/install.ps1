# GTA V Enhanced realism pack: Natural Vision Enhanced (NVE) + NextGen Euphoria + Better Vehicle Deformation for NVE
# + Traffic V FEAR Edition + Skip Intro.
# STATUS: UNTESTED. Written before the game was downloaded; the zip layouts are assumed to be relative to the
# game root (the usual convention). Verify against each mod's page the first time and fix this script.
# Usage: .\install.ps1 [-GamePath "path\to\Grand Theft Auto V Enhanced"]
param([string]$GamePath)
$ErrorActionPreference = 'Stop'
$here = $PSScriptRoot
$files = Join-Path $here 'files'
$nx = 'https://www.nexusmods.com/gta5enhanced/mods'

# Install order matters: NVE first, add-ons after it. Only .zip is supported (convert .7z/.rar yourself).
# NVE is NOT on Nexus: get it from its author (Razed Mods) and drop the zip in .\files
$packs = @(
  @{ Key='nve';     Pattern='*NaturalVision*Enhanced*.zip'; Url='Author site (Razed Mods) - not on Nexus' },
  @{ Key='euphoria';Pattern='*NextGen*Euphoria*.zip';       Url="$nx/1?tab=files" },
  @{ Key='deform';  Pattern='*Vehicle*Deformation*.zip';    Url="$nx/41?tab=files" },
  @{ Key='traffic'; Pattern='*Traffic*FEAR*.zip';           Url="$nx/49?tab=files" },
  @{ Key='skipintro';Pattern='*Skip*Intro*.zip';            Url="$nx/216?tab=files" }
)

# Game folder
if(-not $GamePath){
  $cands = @("${env:ProgramFiles(x86)}\Steam\steamapps\common\Grand Theft Auto V Enhanced")
  $vdf = "${env:ProgramFiles(x86)}\Steam\steamapps\libraryfolders.vdf"
  if(Test-Path -LiteralPath $vdf){ $cands += (Select-String -LiteralPath $vdf -Pattern '"path"\s+"(.+)"').Matches | % { Join-Path ($_.Groups[1].Value -replace '\\\\','\') 'steamapps\common\Grand Theft Auto V Enhanced' } }
  $GamePath = $cands | ? { Test-Path -LiteralPath $_ } | ? { @(Get-ChildItem -LiteralPath $_ -File -ErrorAction SilentlyContinue).Count -gt 0 } | Select -First 1
}
if(-not $GamePath){ throw 'GTA V Enhanced not found or not downloaded yet (empty folder). Download it in Steam first, or use -GamePath.' }
if(Get-Process -Name 'GTA5_Enhanced','GTA5','PlayGTAV' -ErrorAction SilentlyContinue){ throw 'Close the game before installing.' }
"Game: $GamePath"

# Required files
$found = [ordered]@{}; $missing = @()
foreach($p in $packs){
  $f = Get-ChildItem -LiteralPath $files -Filter $p.Pattern -File -ErrorAction SilentlyContinue | Select -First 1
  if($f){ $found[$p.Key] = $f.FullName } else { $missing += $p }
}
if($missing){
  "Missing files in $files (download each with 'Manual download' while logged in to Nexus):"
  $missing | % { "  - $($_.Pattern)`n    $($_.Url)" }
  throw 'Put the zips in .\files and run again.'
}

# Backup: whole game root is too big, so only back up files the zips will overwrite
$bk = Join-Path $env:USERPROFILE ("gta5e-backup-" + (Get-Date -Format 'yyyyMMdd-HHmmss'))
$tmp = Join-Path $env:TEMP ("gta5e-pack-" + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory $tmp | Out-Null
foreach($k in $found.Keys){ Expand-Archive -LiteralPath $found[$k] -DestinationPath (Join-Path $tmp $k) -Force }
foreach($k in $found.Keys){
  $root = Join-Path $tmp $k
  # If the zip has a single top-level folder that is not part of the game layout, step into it
  $top = @(Get-ChildItem -LiteralPath $root)
  if($top.Count -eq 1 -and $top[0].PSIsContainer -and -not (Test-Path -LiteralPath (Join-Path $GamePath $top[0].Name))){ $root = $top[0].FullName }
  Get-ChildItem -LiteralPath $root -Recurse -File | % {
    $rel = $_.FullName.Substring($root.Length).TrimStart('\')
    $dst = Join-Path $GamePath $rel
    if(Test-Path -LiteralPath $dst){
      $b = Join-Path $bk $rel; New-Item -ItemType Directory -Force (Split-Path $b) | Out-Null
      Copy-Item -LiteralPath $dst -Destination $b -Force
    }
  }
  Copy-Item -Path (Join-Path $root '*') -Destination $GamePath -Recurse -Force
  "Installed: $k"
}
if(Test-Path -LiteralPath $bk){ "Backup of overwritten files: $bk" }

Remove-Item -LiteralPath $tmp -Recurse -Force
"Done. Launch from Steam and check NVE's own instructions for its in-game menu / ReShade key."
