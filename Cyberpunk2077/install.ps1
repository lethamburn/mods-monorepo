# Cyberpunk 2077 graphics pack (patch 2.5): ReShade + Mango's Ultra Reshade + Nova LUT 4 + HD Reworked Ultra + CET
# Usage: .\install.ps1 [-GamePath "path\to\Cyberpunk 2077"]
param([string]$GamePath)
$ErrorActionPreference = 'Stop'
$here = $PSScriptRoot
$files = Join-Path $here 'files'

# Nexus files (not stored in the repo): zip pattern inside .\files and download page
$nexus = @(
  @{ Key='hd';    Pattern='Cyberpunk 2077 HD Reworked Project Ultra Quality*.zip'; Url='https://www.nexusmods.com/cyberpunk2077/mods/7652?tab=files&file_id=52300' },
  @{ Key='mango'; Pattern="Mango's Ultra Reshade V2*.zip";                          Url='https://www.nexusmods.com/cyberpunk2077/mods/3404?tab=files&file_id=49144' },
  @{ Key='nova';  Pattern='Nova LUT 4*.zip';                                        Url='https://www.nexusmods.com/cyberpunk2077/mods/11622?tab=files&file_id=144813' },
  @{ Key='cet';   Pattern='CET 1.38.1*.zip';                                        Url='https://www.nexusmods.com/cyberpunk2077/mods/107?tab=files&file_id=168615' }
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
foreach($rel in 'archive\pc\mod','bin\x64\plugins','red4ext','engine\config\platform\pc'){
  $s = Join-Path $GamePath $rel
  if(Test-Path $s){ $d = Join-Path $bk $rel; New-Item -ItemType Directory -Force (Split-Path $d) | Out-Null; Copy-Item $s $d -Recurse -Force }
}
"Backup: $bk"

# Extract to a private temp folder
$tmp = Join-Path $env:TEMP ("cp2077-pack-" + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory $tmp | Out-Null
foreach($k in $found.Keys){ Expand-Archive -LiteralPath $found[$k] -DestinationPath (Join-Path $tmp $k) -Force }

# Textures and LUT
$mod = Join-Path $GamePath 'archive\pc\mod'; New-Item -ItemType Directory -Force $mod | Out-Null
Copy-Item "$tmp\hd\archive\pc\mod\*"   $mod -Force
Copy-Item "$tmp\nova\archive\pc\mod\*" $mod -Force

# Cyber Engine Tweaks (ships its own version.dll loader)
Copy-Item "$tmp\cet\bin\x64\*" (Join-Path $GamePath 'bin\x64') -Recurse -Force

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
"Done. Launch the game: Home = ReShade menu, F1 = CET console."
