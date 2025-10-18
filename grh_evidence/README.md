GRH Evidence helpers

Place your photos/screenshots in `assets/photos/` and update `photo_log.md` and `violations.md`.

Quick steps:

1. Add images to `assets/photos/`.
2. Edit `photo_log.md` to add dates, locations, and descriptions for each file.
3. Run `python generate_manifest.py` to create or update `evidence_manifest.csv` (installs optional: Pillow).
4. Use the Markdown PDF extension in VSCode to export `photo_log.md` and `violations.md` to PDF. Include the `assets/photos/` folder when zipping.

If you want, I can add a PowerShell packaging script to zip the evidence and export markdown automatically.
