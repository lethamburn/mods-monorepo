# NextGen Euphoria for GTA V Enhanced: put physicstasks.ymt into mods\update\update.rpf without CodeWalker's GUI.
# Needs: OpenRPF.asi in the game folder (no dsound.dll), CodeWalker 30 dev48+ unzipped (its Core DLL is used as a library),
# and physicstasks.ymt extracted from the mod's archive. Game must be closed. The original update\update.rpf is never touched:
# the script works on the copy in mods\update (created from the original if missing). Re-run to repeat; to start over, delete mods\update\update.rpf.
# Usage: .\euphoria.ps1 -CodeWalker "path\to\CodeWalker30_dev48" -Ymt "path\to\physicstasks.ymt" [-GamePath "path\to\Grand Theft Auto V Enhanced"]
param(
  [Parameter(Mandatory)][string]$CodeWalker,
  [Parameter(Mandatory)][string]$Ymt,
  [string]$GamePath
)
$ErrorActionPreference = 'Stop'
if(-not $GamePath){
  $GamePath = "${env:ProgramFiles(x86)}\Steam\steamapps\common\Grand Theft Auto V Enhanced"
}
if(-not (Test-Path -LiteralPath "$GamePath\update\update.rpf")){ throw "update.rpf not found in $GamePath" }
if(-not (Test-Path -LiteralPath "$GamePath\OpenRPF.asi")){ throw 'OpenRPF.asi is not installed in the game folder.' }
if(Get-Process -Name 'GTA5_Enhanced','GTA5','PlayGTAV' -ErrorAction SilentlyContinue){ throw 'Close the game first.' }
$mods = Join-Path $GamePath 'mods\update'
New-Item -ItemType Directory -Force $mods | Out-Null
if(-not (Test-Path -LiteralPath "$mods\update.rpf")){ Copy-Item -LiteralPath "$GamePath\update\update.rpf" "$mods\update.rpf" }

Set-Location $CodeWalker
foreach($n in 'SharpDX','SharpDX.Mathematics','SharpDX.DXGI','SharpDX.Direct3D11','SharpDX.D3DCompiler','SharpDX.Direct2D1','SharpDX.XAudio2','SharpDX.XInput'){ try{ [Reflection.Assembly]::LoadFrom("$CodeWalker\$n.dll") | Out-Null }catch{} }
$asm = [Reflection.Assembly]::LoadFrom("$CodeWalker\CodeWalker.Core.dll")
$asm.GetType('CodeWalker.GameFiles.RpfManager').GetProperty('IsGen9').SetValue($null, $true)
$asm.GetType('CodeWalker.GameFiles.GTA5Keys').GetMethod('LoadFromPath').Invoke($null, @($GamePath, $true, ''))
$rpfT = $asm.GetType('CodeWalker.GameFiles.RpfFile')
function U($o){ if($o -is [System.Management.Automation.PSObject]){ $o.psobject.BaseObject } else { $o } }
function Open-Rpf {
  $r = New-Object -TypeName 'CodeWalker.GameFiles.RpfFile' -ArgumentList @("$GamePath\mods\update\update.rpf", 'mods\update\update.rpf')
  $r.ScanStructure($null, $null); $r
}
function Get-Tune($r){
  $x = $r.Root.Directories | ? { $_.Name -eq 'x64' }; $d = $x.Directories | ? { $_.Name -eq 'data' }
  $d.Directories | ? { $_.Name -eq 'tune' }
}

$rpf = Open-Rpf
"Encryption before: $($rpf.Encryption)"
# Convert to the encryption OpenRPF reads (the "conversion to openrpf" question in CodeWalker's GUI)
$confirmT = $rpfT.GetMethod('EnsureValidEncryption').GetParameters()[1].ParameterType
$del = [System.Management.Automation.LanguagePrimitives]::ConvertTo({ param($f) $true }, $confirmT)
[void]$rpfT.GetMethod('EnsureValidEncryption').Invoke($null, [object[]]@((U $rpf), $del))
$bytes = [IO.File]::ReadAllBytes($Ymt)
[void]$rpfT.GetMethod('CreateFile').Invoke($null, [object[]]@((U (Get-Tune $rpf)), 'physicstasks.ymt', [byte[]]$bytes, $true))

# Verify
$rpf2 = Open-Rpf
$e = (Get-Tune $rpf2).Files | ? { $_.Name -eq 'physicstasks.ymt' }
$back = $rpf2.ExtractFile($e)
$same = ($back.Length -eq $bytes.Length) -and (-not (Compare-Object $back $bytes -SyncWindow 0))
"Encryption now: $($rpf2.Encryption); physicstasks.ymt identical: $same"
if(-not $same){ throw 'Verification failed: delete mods\update\update.rpf and re-run.' }
