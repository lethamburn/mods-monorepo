# Cyberpunk 2077 - KK-Photorealism (patch 2.5, RTX)

Installs ReShade 6.8.0 + the KK Photorealism CP77 Light Version preset (natural, low-saturation look, no ray tracing needed) and the shaders it uses (LevelsPlus, pColors, DPX, Levels, LumaSharpen, Clarity2). No game files are replaced.

1. Put the preset zip in `files\` (if missing, the script prints its download link).
2. With the game closed: `powershell -ExecutionPolicy Bypass -File .\install.ps1`
3. It backs up to `%USERPROFILE%\cp2077-backup-*`, installs ReShade (downloaded from reshade.me, signature verified), downloads the shader packages from the same GitHub URLs ReShade's own installer uses, and sets the preset.

In game: Home = ReShade menu.

## Optional: DLSS 5 (manual, not scripted)

The preset page also asks for the "DLSS 5 Manager" (github.com/NODIX-TECH/DLSS-5-MANAGER). It is unofficial: it installs a modified OptiScaler (`version.dll`, unsigned) and an unsigned `nvngx_dlssnr.dll` (NVIDIA neural rendering, reportedly leaked). It is NOT part of this installer and was run by hand by the user, after `install.ps1`; it keeps ReShade's `dxgi.dll`. Not verified by the installer; the preset works without it (it does not enable any DLSS 5 technique).

## Credits

This repo does not redistribute these files; the installer downloads them from the original sources.

| Item | Author | Link |
|---|---|---|
| KK Photorealism CP77 Light Version (preset) | Kamil310390 | https://www.nexusmods.com/cyberpunk2077/mods/35618 |
| ReShade 6.8.0 | crosire | https://reshade.me/ |
| Standard effects, Legacy effects (LevelsPlus) | crosire | https://github.com/crosire/reshade-shaders |
| SweetFX (DPX, Levels, LumaSharpen) | CeeJay.dk | https://github.com/CeeJayDK/SweetFX |
| GShade-Shaders (Clarity2) | Marot | https://github.com/Mortalitas/GShade-Shaders |
| potatoFX (pColors) | PotatoFury | https://github.com/GimleLarpes/potatoFX |
