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

## How the site is organized

- `/kits/` - practical pages that solve one renter problem with a compact minimum kit, optional upgrades, skip notes, and renter-risk guidance.
- `/guides/` - buying strategy and comparison pages that explain what to skip, how to compare renter-friendly approaches, and how to think about deposit risk.
- `/about/`, `/contact/`, `/affiliate-disclosure/`, and `/privacy/` - trust, requests, disclosure, and policy pages.

Start from the home page when you are not sure where to begin. Choose a `kit` when the apartment problem is clear; choose a `guide` when the buying decision or tradeoff is the problem.

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

Generate brand assets:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\build-brand-assets.ps1
```

If Node is not installed locally, Codex can run the project using its bundled Node runtime.

## Publishing

Configure GitHub Pages to publish from the `main` branch and the `/docs` folder.

Do not edit files in `docs/` by hand. Edit `src/`, `assets/`, or `CONTENT_ROADMAP.md`, then rebuild.
