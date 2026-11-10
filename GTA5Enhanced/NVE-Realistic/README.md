# GTA V Enhanced - NVE-Realistic: Natural Vision Enhanced + physics/traffic add-ons

Target: RTX 4070 SUPER (12 GB), 1440p, DLSS Quality. No car packs on purpose (VRAM).

**Status: untested.** The pack was written while the game was not yet downloaded (Steam folder empty). `install.ps1` assumes each zip is laid out relative to the game root; check each mod's page on the first run and fix the script. Mods compatible with NVE list Natural Vision Enhanced as an off-site requirement.

1. Download the game in Steam first.
2. Put the zips in `files\` (the script prints the link of any missing one). Natural Vision Enhanced is not on Nexus: get it from its author.
3. With the game closed: `powershell -ExecutionPolicy Bypass -File .\install.ps1`

Order: NVE, NextGen Euphoria, Better Vehicle Deformation for NVE, Traffic V FEAR Edition, Skip Intro. Do not add Beautify GTA5 Enhanced: it overlaps NVE (lighting/colour). Skip the Addon Carpack V2 (6.1 GB) on 12 GB VRAM. NextGen Euphoria's page says its install tutorial is a video: read it before the first run.

## Credits

All mods belong to their authors. This repo only contains an installer script and does not redistribute their files; download them from the original pages. Authors are taken from the Nexus mod listing.

| Mod | Author | Link |
|---|---|---|
| Natural Vision Enhanced | Razed Mods (not verified; not on Nexus) | author site |
| NextGen Euphoria | iammrmikeman | https://www.nexusmods.com/gta5enhanced/mods/1 |
| Better Vehicle Deformation for NVE | HSjoaco33 | https://www.nexusmods.com/gta5enhanced/mods/41 |
| Traffic V FEAR Edition - NVE Enhanced Compatible | FEAR2105 | https://www.nexusmods.com/gta5enhanced/mods/49 |
| Skip Intro | b1elao | https://www.nexusmods.com/gta5enhanced/mods/216 |
