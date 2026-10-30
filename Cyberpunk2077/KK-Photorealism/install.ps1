# Cyberpunk 2077 KK Photorealism pack (patch 2.5): ReShade + KK Photorealism CP77 Light Version preset
# Shaders come from the official ReShade effect package list (GitHub). The optional DLSS 5 step is NOT part of this script.
# Usage: .\install.ps1 [-GamePath "path\to\Cyberpunk 2077"]
param([string]$GamePath)
$ErrorActionPreference = 'Stop'
$here = $PSScriptRoot
$files = Join-Path $here 'files'
$presetUrl = 'https://www.nexusmods.com/cyberpunk2077/mods/35618?tab=files&file_id=167590'
$reshadeUrl = 'https://reshade.me/downloads/ReShade_Setup_6.8.0.exe'
$reshadeThumb = '589690208A5E52FB96980C4A6698F50ACD47C49F'
$presetIni = 'KK Photorealism CP77 Light Version.ini'

# Shader packages (same URLs as ReShade's EffectPackages.ini): what to copy and where, relative to reshade-shaders\Shaders
$packages = @(
  @{ Key='slim';    Url='https://github.com/crosire/reshade-shaders/archive/slim.zip';               Src='reshade-shaders-slim\Shaders';   Dest='';         Only=$null; Textures='reshade-shaders-slim\Textures' },
  @{ Key='sweetfx'; Url='https://github.com/CeeJayDK/SweetFX/archive/master.zip';                    Src='SweetFX-master\Shaders\SweetFX'; Dest='';         Only=@('DPX.fx','Levels.fx','LumaSharpen.fx'); Textures=$null },
  @{ Key='legacy';  Url='https://github.com/crosire/reshade-shaders/archive/legacy.zip';             Src='reshade-shaders-legacy\Shaders'; Dest='';         Only=@('LevelsPlus.fx'); Textures=$null },
  @{ Key='gshade';  Url='https://github.com/Mortalitas/GShade-Shaders/archive/refs/heads/master.zip'; Src='GShade-Shaders-master\Shaders';  Dest='';         Only=@('Clarity2.fx'); Textures=$null },
  @{ Key='potato';  Url='https://github.com/GimleLarpes/potatoFX/archive/refs/heads/master.zip';     Src='potatoFX-main\Shaders';          Dest='potatoFX'; Only=$null; Textures=$null }
)

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

# Preset zip (not stored in the repo)
$preset = Get-ChildItem $files -Filter 'KK Photorealism*.zip' -File -ErrorAction SilentlyContinue | Select -First 1
if(-not $preset){
  "Missing the preset zip in $files (download with 'Manual download' while logged in to Nexus):"
  "  - KK Photorealism*.zip`n    $presetUrl"
  throw 'Put the zip in .\files and run again.'
}

# Backup
$bk = Join-Path $env:USERPROFILE ("cp2077-backup-" + (Get-Date -Format 'yyyyMMdd-HHmmss'))
$bin = Join-Path $GamePath 'bin\x64'
New-Item -ItemType Directory -Force $bk | Out-Null
foreach($n in 'dxgi.dll','ReShade.ini','ReShadePreset.ini'){ if(Test-Path "$bin\$n"){ Copy-Item "$bin\$n" $bk -Force } }
if(Test-Path "$bin\reshade-shaders"){ Copy-Item "$bin\reshade-shaders" $bk -Recurse -Force }
"Backup: $bk"

$tmp = Join-Path $env:TEMP ("cp2077-kk-" + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory $tmp | Out-Null

# ReShade (official build, signature checked)
$rs = Join-Path $tmp 'ReShade_Setup.exe'
Invoke-WebRequest $reshadeUrl -OutFile $rs -UseBasicParsing -Headers @{ 'User-Agent'='Mozilla/5.0' }
if((Get-AuthenticodeSignature $rs).SignerCertificate.Thumbprint -ne $reshadeThumb){ throw 'Unexpected ReShade signature, aborting.' }
Start-Process $rs -ArgumentList "`"$bin\Cyberpunk2077.exe`" --api dxgi --headless" -Wait

# Shaders
$sh = Join-Path $bin 'reshade-shaders\Shaders'; $tx = Join-Path $bin 'reshade-shaders\Textures'
New-Item -ItemType Directory -Force $sh, $tx | Out-Null
foreach($p in $packages){
  $zip = Join-Path $tmp "$($p.Key).zip"
  Invoke-WebRequest $p.Url -OutFile $zip -UseBasicParsing -Headers @{ 'User-Agent'='Mozilla/5.0' }
  $dir = Join-Path $tmp $p.Key
  Expand-Archive -LiteralPath $zip -DestinationPath $dir -Force
  $dest = if($p.Dest){ Join-Path $sh $p.Dest } else { $sh }
  New-Item -ItemType Directory -Force $dest | Out-Null
  $src = Join-Path $dir $p.Src
  if($p.Only){ foreach($f in $p.Only){ Copy-Item (Join-Path $src $f) $dest -Force } } else { Copy-Item "$src\*" $dest -Recurse -Force }
  if($p.Textures){ Copy-Item "$(Join-Path $dir $p.Textures)\*" $tx -Recurse -Force }
  "Shaders: $($p.Key)"
}

# Preset + ReShade paths
Expand-Archive -LiteralPath $preset.FullName -DestinationPath $tmp\preset -Force
Copy-Item (Join-Path $tmp "preset\$presetIni") $bin -Force
$ini = Join-Path $bin 'ReShade.ini'
$c = Get-Content $ini | ? { $_ -notmatch '^(PresetPath|EffectSearchPaths|TextureSearchPaths)=' }
$out = foreach($l in $c){ $l; if($l -eq '[GENERAL]'){
  "PresetPath=.\$presetIni"
  'EffectSearchPaths=.\reshade-shaders\Shaders\**'
  'TextureSearchPaths=.\reshade-shaders\Textures\**' } }
Set-Content $ini $out -Encoding ASCII

Remove-Item $tmp -Recurse -Force
"Done. Home = ReShade menu."
