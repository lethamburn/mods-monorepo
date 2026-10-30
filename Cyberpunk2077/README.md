# Cyberpunk 2077 - graphics pack (patch 2.5, RTX)

Installs ReShade 6.8.0 + Mango's Ultra Reshade V2 + Nova LUT 4 + HD Reworked Project Ultra + Cyber Engine Tweaks 1.38.1.

1. Put the 4 Nexus zips in `files\` (if any is missing, the script prints its download link).
2. With the game closed: `powershell -ExecutionPolicy Bypass -File .\install.ps1`
3. It backs up to `%USERPROFILE%\cp2077-backup-*`, installs and configures everything. ReShade is downloaded from reshade.me and its signature is verified.

In game: Home = ReShade menu, F1 = CET console. HD Reworked Ultra adds ~1-1.5 GB VRAM; if you get stutter, use the Balanced file of the same mod instead.

## Credits

All mods belong to their authors. This repo only contains an installer script and does not redistribute their files; download them from the original pages.

| Mod | Author | Link |
|---|---|---|
| Cyberpunk 2077 HD Reworked Project (Ultra Quality 2.0) | Halk Hogan PL | https://www.nexusmods.com/cyberpunk2077/mods/7652 |
| Mango's Ultra Reshade V2 (2.1) | FuzzyMangos | https://www.nexusmods.com/cyberpunk2077/mods/3404 |
| Nova LUT 4 (AgX - New HDR) | CyanideX | https://www.nexusmods.com/cyberpunk2077/mods/11622 |
| Cyber Engine Tweaks (1.38.1) | yamashi and contributors | https://www.nexusmods.com/cyberpunk2077/mods/107 |
| ReShade (6.8.0) | crosire | https://reshade.me/ |

Shaders bundled inside Mango's preset come from their own authors: Clarity (AstrayFX, Astray), prod80 / PD80 shaders (prod80), LumaSharpen (CeeJay.dk), built on the ReShade FX shader framework by crosire.
