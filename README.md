# Apartment Survival Kits

Static affiliate/editorial site for renter-friendly apartment kits.

## Structure

- `src/pages/` - standalone page body HTML with metadata.
- `src/kits/` - future full kit pages, grouped by category.
- `assets/` - shared CSS, JavaScript, and images.
- `promo/` - generated Pinterest/social promo packs and bulk upload CSV.
- `scripts/build-site.js` - tiny static generator.
- `docs/` - generated site output for GitHub Pages.
- `CONTENT_ROADMAP.md` - editorial roadmap and long-tail backlog.
- `ARTICLE_CREATION_GUIDE.md` - rules and workflow for creating kit pages.

## Build

Run:

```powershell
node .\scripts\build-site.js
```

Generate promo assets:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\build-promo-assets.ps1
```

Upload `promo/pinterest-upload-now.csv` for immediate pins and `promo/pinterest-upload-scheduled.csv` for scheduled pins. `promo/PINTEREST_LEDGER.csv` tracks what has already been exported or uploaded.

If Node is not installed locally, Codex can run the project using its bundled Node runtime.

## Publishing

Configure GitHub Pages to publish from the `main` branch and the `/docs` folder.

Do not edit files in `docs/` by hand. Edit `src/`, `assets/`, or `CONTENT_ROADMAP.md`, then rebuild.
