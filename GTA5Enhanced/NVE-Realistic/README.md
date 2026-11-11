# GTA V Enhanced - NVE-Realistic: Natural Vision Enhanced + physics/traffic add-ons

Target: RTX 4070 SUPER (12 GB), 1440p, DLSS Quality. No car packs on purpose (VRAM).

**Status:** ScriptHookV + NVE (Update #3, Oct 2026) + Skip Intro installed on 2026-11-11 by `install.ps1` (file copy verified; first in-game launch not yet checked). NextGen Euphoria, Better Vehicle Deformation and Traffic V FEAR are optional: they are skipped when their zip is missing (Nexus was returning 500 errors) and the script can be re-run later.

1. Download the game in Steam first.
2. Put the zips in `files\` (the script prints the link of any missing one). NVE is not on Nexus: get it from its author. ScriptHookV: http://www.dev-c.com/gtav/scripthookv/ (the download link only works with that page as Referer).
3. With the game closed: `powershell -ExecutionPolicy Bypass -File .\install.ps1`

Order: ScriptHookV (without NativeTrainer), NVE (the `Main Package` folder of its zip), then the optional add-ons, Skip Intro last. Skip Intro (NVE variant, from the .rar) is repacked as `onigiri\platform\movies
ockstar_logos.bik` in a zip. ScriptHookV's `args.txt` disables BattlEye, so no Steam launch option is needed (single player only, no GTA Online). Do not add Beautify GTA5 Enhanced: it overlaps NVE. Skip the Addon Carpack V2 (6.1 GB) on 12 GB VRAM. NextGen Euphoria's page says its install tutorial is a video: read it before adding it. The add-on zips' layouts are still unverified.

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
