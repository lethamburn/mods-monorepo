# GTA V Enhanced - NVE-Realistic: Natural Vision Enhanced + physics/traffic add-ons

Target: RTX 4070 SUPER (12 GB), 1440p, DLSS Quality. No car packs on purpose (VRAM).

**Status:** ScriptHookV, NVE (Update #3), Better Vehicle Deformation v3 (Realistic), Traffic V FEAR v1.3 and Skip Intro installed on 2026-11-11 by `install.ps1` (file copy verified; first in-game launch not yet checked). NextGen Euphoria installed via `euphoria.ps1` (needs OpenRPF + CodeWalker); the game has not been launched yet with any of this.

1. Download the game in Steam first.
2. Put the zips in `files\` (the script prints the link of any missing one). NVE is not on Nexus: get it from its author. ScriptHookV: http://www.dev-c.com/gtav/scripthookv/ (the download link only works with that page as Referer).
3. With the game closed: `powershell -ExecutionPolicy Bypass -File .\install.ps1`

Order: ScriptHookV (without NativeTrainer), NVE (`Main Package` folder), Better Vehicle Deformation, Traffic V FEAR, Skip Intro. Nexus ships .rar files and the script only reads .zip, so each was repacked as a zip with the game-relative layout: Deformation `onigiri\common\data\handling.meta` (install step from the mod page; install only the Realistic OR the Exaggerated version, never both), Traffic `onigiri\common\data\levels\gta5\popcycle.dat` + `onigiri\platform\levels\gta5\popgroups.ymt` (overwrites traffic/vehicle sets), Skip Intro `onigiri\platform\movies\rockstar_logos.bik`. ScriptHookV's `args.txt` disables BattlEye, so no Steam launch option is needed (single player only, no GTA Online). Do not add Beautify GTA5 Enhanced: it overlaps NVE. Skip the Addon Carpack V2 (6.1 GB) on 12 GB VRAM.

**NextGen Euphoria (`euphoria.ps1`, not run by `install.ps1`):** installed 2026-11-11. It edits `physicstasks.ymt` into a copy of `update.rpf`, so it needs OpenRPF (gta5-mods.com, LSMP; copy only `OpenRPF.asi`, NOT its `dsound.dll`) and CodeWalker 30 dev48+ (author's Discord only). The script uses CodeWalker's `CodeWalker.Core.dll` as a library instead of the GUI (the GUI's RPF Explorer cannot browse `mods\`): `.\euphoria.ps1 -CodeWalker <unzipped folder> -Ymt <physicstasks.ymt from the mod's archive>`. It copies `update\update.rpf` (2.9 GB) to `mods\update\`, converts that copy to OpenRPF encryption, replaces the file and verifies it; the original is untouched. To undo: delete `mods\` and `OpenRPF.asi`. Video tutorial of the manual way: https://www.youtube.com/watch?v=JipvLmurdzc. Traffic V FEAR also lists Simple Trainer (prevent MP vehicle despawn) as an external requirement.

In game: set PostFX and Particles Quality to Ultra, display brightness 50%; INSERT opens the ReShade menu (NVE tab). NVE ships its own ReShade and `xinput1_4.dll`: do not install another ReShade. Backup of overwritten files goes to `%USERPROFILE%\gta5e-backup-<timestamp>`.

## Credits

All mods belong to their authors. This repo only contains an installer script and does not redistribute their files; download them from the original pages. Authors are taken from the Nexus mod listing.

| Mod | Author | Link |
|---|---|---|
| ScriptHookV | Alexander Blade | http://www.dev-c.com/gtav/scripthookv/ |
| Natural Vision Enhanced | Razed Mods (not verified; not on Nexus) | author site |
| NextGen Euphoria | iammrmikeman | https://www.nexusmods.com/gta5enhanced/mods/1 |
| Better Vehicle Deformation for NVE | HSjoaco33 | https://www.nexusmods.com/gta5enhanced/mods/41 |
| Traffic V FEAR Edition - NVE Enhanced Compatible | FEAR2105 | https://www.nexusmods.com/gta5enhanced/mods/49 |
| Skip Intro | b1elao | https://www.nexusmods.com/gta5enhanced/mods/216 |
| OpenRPF (OpenIV.asi for GTA V Enhanced) | LSMP | https://www.gta5-mods.com/tools/openrpf-openiv-asi-for-gta-v-enhanced |
| CodeWalker (30 dev48, used as a library by `euphoria.ps1`) | dexyfex | author Discord (not redistributed) |
