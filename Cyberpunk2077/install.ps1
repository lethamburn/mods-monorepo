# Cyberpunk 2077 graphics + city pack (patch 2.5): ReShade, Mango's preset, Nova LUT 4, HD Reworked Ultra,
# ReFRACT, Visual Effects Fixes, Crowd * Restored, plus CET / redscript / Codeware / TweakXL
# Usage: .\install.ps1 [-GamePath "path\to\Cyberpunk 2077"]
param([string]$GamePath)
$ErrorActionPreference = 'Stop'
$here = $PSScriptRoot
$files = Join-Path $here 'files'
$nx = 'https://www.nexusmods.com/cyberpunk2077/mods'

# Nexus files (not stored in the repo): zip pattern inside .\files and download page.
# All zips are laid out relative to the game root, except Mango's (preset, handled separately).
$nexus = @(
  @{ Key='hd';       Pattern='Cyberpunk 2077 HD Reworked Project Ultra Quality*.zip'; Url="$nx/7652?tab=files&file_id=52300" },
  @{ Key='mango';    Pattern="Mango's Ultra Reshade V2*.zip";                         Url="$nx/3404?tab=files&file_id=49144" },
  @{ Key='nova';     Pattern='Nova LUT 4*.zip';                                       Url="$nx/11622?tab=files&file_id=144813" },
  @{ Key='cet';      Pattern='CET 1.38.1*.zip';                                       Url="$nx/107?tab=files&file_id=168615" },
  @{ Key='redscript';Pattern='redscript*.zip';                                        Url="$nx/1511?tab=files&file_id=167681" },
  @{ Key='codeware'; Pattern='Codeware*.zip';                                         Url="$nx/7780?tab=files&file_id=170432" },
  @{ Key='tweakxl';  Pattern='TweakXL*.zip';                                          Url="$nx/4197?tab=files&file_id=168221" },
  @{ Key='refract';  Pattern='ReFRACT*.zip';                                          Url="$nx/34858?tab=files&file_id=168959" },
  @{ Key='vfxfix';   Pattern='Visual Effects Fixes*.zip';                             Url="$nx/35461?tab=files&file_id=167200" },
  @{ Key='crowdvar'; Pattern='Crowd Variety Restored*.zip';                           Url="$nx/34908?tab=files&file_id=168643" },
  @{ Key='crowdwalk';Pattern='Crowd Walks Restored*.zip';                             Url="$nx/34789?tab=files&file_id=165532" },
  @{ Key='crowdprop';Pattern='Crowd Props Restored*.zip';                             Url="$nx/35285?tab=files&file_id=168624" },
  @{ Key='crowdumb'; Pattern='Crowd Umbrellas Restored*.zip';                         Url="$nx/35264?tab=files&file_id=167207" }
)
$reshadeUrl = 'https://reshade.me/downloads/ReShade_Setup_6.8.0.exe'
$reshadeThumb = '589690208A5E52FB96980C4A6698F50ACD47C49F'

# Game folder
if(-not $GamePath){
  $cands = @("${env:ProgramFiles(x86)}\Steam\steamapps\common\Cyberpunk 2077")
  $vdf = "${env:ProgramFiles(x86)}\Steam\steamapps\libraryfolders.vdf"
  if(Test-Path $vdf){ $cands += (Select-String $vdf -Pattern '"path"\s+"(.+)"').Matches | % { Join-Path ($_.Groups[1].Value -replace '\\\\','\') 'steamapps\common\Cyberpunk 2077' } }
  $GamePath = $cands | ? { Test-Path "$_\bin\x64\Cyberpunk2077.exe" } | Select -First 1
}
if(-not $GamePath){ throw 'Cyberpunk 2077 not found. Use -GamePath.' }
if(Get-Process Cyberpunk2077 -ErrorAction SilentlyContinue){ throw 'Close the game before installing.' }
"Game: $GamePath"

# RED4ext is a prerequisite (Codeware, TweakXL, ReFRACT run on it)
if(-not (Test-Path (Join-Path $GamePath 'red4ext\RED4ext.dll'))){
  Write-Warning 'RED4ext not found. Install RED4ext 1.31.0 first: https://github.com/WopsS/RED4ext/releases'
}

# Required files
$found = @{}; $missing = @()
foreach($n in $nexus){
  $f = Get-ChildItem $files -Filter $n.Pattern -File -ErrorAction SilentlyContinue | Select -First 1
  if($f){ $found[$n.Key] = $f.FullName } else { $missing += $n }
}
if($missing){
  "Missing files in $files (download each with 'Manual download' while logged in to Nexus):"
  $missing | % { "  - $($_.Pattern)`n    $($_.Url)" }
  throw 'Put the zips in .\files and run again.'
}

# Backup
$bk = Join-Path $env:USERPROFILE ("cp2077-backup-" + (Get-Date -Format 'yyyyMMdd-HHmmss'))
foreach($rel in 'archive\pc\mod','bin\x64\plugins','red4ext','r6\scripts','r6\tweaks','r6\config','engine\config\platform\pc'){
  $s = Join-Path $GamePath $rel
  if(Test-Path $s){ $d = Join-Path $bk $rel; New-Item -ItemType Directory -Force (Split-Path $d) | Out-Null; Copy-Item $s $d -Recurse -Force }
}
"Backup: $bk"

# Extract to a private temp folder
$tmp = Join-Path $env:TEMP ("cp2077-pack-" + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory $tmp | Out-Null
foreach($k in $found.Keys){ Expand-Archive -LiteralPath $found[$k] -DestinationPath (Join-Path $tmp $k) -Force }

# Everything except Mango's preset is laid out relative to the game root
New-Item -ItemType Directory -Force (Join-Path $GamePath 'archive\pc\mod') | Out-Null
foreach($k in $found.Keys){ if($k -ne 'mango'){ Copy-Item "$tmp\$k\*" $GamePath -Recurse -Force; "Installed: $k" } }

# ReShade (official build, signature checked)
$rs = Join-Path $tmp 'ReShade_Setup.exe'
Invoke-WebRequest $reshadeUrl -OutFile $rs -UseBasicParsing -Headers @{ 'User-Agent'='Mozilla/5.0' }
if((Get-AuthenticodeSignature $rs).SignerCertificate.Thumbprint -ne $reshadeThumb){ throw 'Unexpected ReShade signature, aborting.' }
$exe = Join-Path $GamePath 'bin\x64\Cyberpunk2077.exe'
Start-Process $rs -ArgumentList "`"$exe`" --api dxgi --headless" -Wait

# Mango's preset (Recommended) + shaders, then ReShade paths
$bin = Join-Path $GamePath 'bin\x64'
$mangoSrc = Get-ChildItem "$tmp\mango" -Recurse -Directory -Filter x64 | ? { $_.FullName -match 'Recommended' } | Select -First 1
Copy-Item "$($mangoSrc.FullName)\*" $bin -Recurse -Force
$ini = Join-Path $bin 'ReShade.ini'
$c = Get-Content $ini | ? { $_ -notmatch '^(PresetPath|EffectSearchPaths|TextureSearchPaths)=' }
$out = foreach($l in $c){ $l; if($l -eq '[GENERAL]'){
  "PresetPath=.\Mango's Ultra Reshade V2.ini"
  'EffectSearchPaths=.\reshade-shaders\Shaders\**'
  'TextureSearchPaths=.\reshade-shaders\Textures\**' } }
Set-Content $ini $out -Encoding ASCII

Remove-Item $tmp -Recurse -Force
"Done. First launch recompiles scripts (redscript) and can take a bit longer. Home = ReShade menu, F1 = CET console."
