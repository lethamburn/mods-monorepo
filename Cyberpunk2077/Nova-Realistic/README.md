# Cyberpunk 2077 - Nova-Realistic: graphics + city pack (patch 2.5, RTX)

Installs ReShade 6.8.0 + Mango's Ultra Reshade V2 + Nova LUT 4 + HD Reworked Project Ultra + ReFRACT + Visual Effects Fixes + the Crowd * Restored series + Shift (first person / vehicle camera) + Nova City 2 (custom weather and lighting) with Weather Switcher and The Nullifier, plus the frameworks they need (Cyber Engine Tweaks, redscript, Codeware, TweakXL, ArchiveXL, Mod Settings). RED4ext 1.31.0 must already be installed.

1. Put the 19 Nexus zips in `files\` (if any is missing, the script prints its download link).
2. With the game closed: `powershell -ExecutionPolicy Bypass -File .\install.ps1`
3. It backs up to `%USERPROFILE%\cp2077-backup-*`, installs and configures everything. ReShade is downloaded from reshade.me and its signature is verified.

In game: Home = ReShade menu, F1 = CET console. First launch recompiles scripts and takes longer. HD Reworked Ultra adds ~1-1.5 GB VRAM; if you get stutter, use the Balanced file of the same mod instead. Visual Effects Fixes is only v0.1 (very early). Shift and Weather Switcher settings: CET overlay (F1). Nova City 2 warning: before uninstalling it, set the weather to sunny with the Nova City Tools CET window and make a new save, or saves with a custom weather state crash on load.

## Credits

All mods belong to their authors. This repo only contains an installer script and does not redistribute their files; download them from the original pages.

| Mod | Author | Link |
|---|---|---|
| Cyberpunk 2077 HD Reworked Project (Ultra Quality 2.0) | Halk Hogan PL | https://www.nexusmods.com/cyberpunk2077/mods/7652 |
| Mango's Ultra Reshade V2 (2.1) | FuzzyMangos | https://www.nexusmods.com/cyberpunk2077/mods/3404 |
| Nova LUT 4 (AgX - New HDR) | CyanideX | https://www.nexusmods.com/cyberpunk2077/mods/11622 |
| ReFRACT 1.5.0 | CyanideX | https://www.nexusmods.com/cyberpunk2077/mods/34858 |
| Visual Effects Fixes 0.1 | Sosuinepsixuyu (uploaded by sosuine) | https://www.nexusmods.com/cyberpunk2077/mods/35461 |
| Crowd Variety Restored 1.0.4 | dnbnhlp | https://www.nexusmods.com/cyberpunk2077/mods/34908 |
| Crowd Walks Restored 1.0.1 | dnbnhlp | https://www.nexusmods.com/cyberpunk2077/mods/34789 |
| Crowd Props Restored 1.0.2 | dnbnhlp | https://www.nexusmods.com/cyberpunk2077/mods/35285 |
| Crowd Umbrellas Restored 1.0.2 | dnbnhlp | https://www.nexusmods.com/cyberpunk2077/mods/35264 |
| Shift (Dynamic First Person Camera) 1.14.0 | theCyanideX | https://www.nexusmods.com/cyberpunk2077/mods/22340 |
| Nova City 2 2.3.2 | CyanideX (uploaded by theCyanideX) | https://www.nexusmods.com/cyberpunk2077/mods/12490 |
| Weather Switcher 1.7.6 | CyanideX (uploaded by theCyanideX) | https://www.nexusmods.com/cyberpunk2077/mods/18027 |
| The Nullifier 1.4.6 | robber804 | https://www.nexusmods.com/cyberpunk2077/mods/23091 |
| Mod Settings 0.2.28 | Jack Humbert | https://www.nexusmods.com/cyberpunk2077/mods/4885 |
| ArchiveXL 1.28.6 | psiberx | https://www.nexusmods.com/cyberpunk2077/mods/4198 |
| Cyber Engine Tweaks 1.38.1 | yamashi and contributors | https://www.nexusmods.com/cyberpunk2077/mods/107 |
| redscript 0.5.32 | jac3km4 | https://www.nexusmods.com/cyberpunk2077/mods/1511 |
| Codeware 1.21.2 | psiberx | https://www.nexusmods.com/cyberpunk2077/mods/7780 |
| TweakXL 1.12.0 | psiberx | https://www.nexusmods.com/cyberpunk2077/mods/4197 |
| ReShade 6.8.0 | crosire | https://reshade.me/ |
| RED4ext 1.31.0 (prerequisite) | WopsS | https://github.com/WopsS/RED4ext |

Shaders bundled inside Mango's preset come from their own authors: Clarity (AstrayFX, Astray), prod80 / PD80 shaders (prod80), LumaSharpen (CeeJay.dk), built on the ReShade FX shader framework by crosire.
