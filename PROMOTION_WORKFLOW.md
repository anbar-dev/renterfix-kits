# Promotion Workflow

This file describes the low-effort distribution flow for Apartment Survival Kits.

## Current Strategy

For every strong article, create a small promo pack:

- 3 Pinterest-ready vertical PNGs.
- Pinterest bulk upload CSV rows.
- Pinterest title and description copy.
- 20-30 second short video script.
- Fiverr brief for cheap batch editing.
- Reddit angle for manual, non-spam replies.

Pins should link to the article page, not directly to Amazon. The article page contains the Amazon affiliate links and disclosure.

## Folder Structure

```text
promo/
  pinterest-bulk-upload.csv
  article-slug/
    pins/
      pin-01.png
      pin-02.png
      pin-03.png
    pinterest-copy.md
    short-video-script.md
    fiverr-brief.md
    reddit-angle.md
```

The static site build copies `promo/` into `docs/promo/`, so images become public after GitHub Pages publishes.

Example:

```text
https://apartmentsurvivalkits.com/promo/dark-apartment-lighting/pins/pin-01.png
```

## Pinterest Bulk Upload

Use a Pinterest business account. It is free unless ads are used.

Upload:

```text
promo/pinterest-bulk-upload.csv
```

The CSV points to public image URLs on the site. Push the site before uploading the CSV, otherwise Pinterest cannot fetch the media.

Each Pin row needs a unique destination URL. When publishing multiple variants for the same article, use UTM parameters so Pinterest does not reject rows with `Duplicate Pin link`:

```text
?utm_source=pinterest&utm_medium=social&utm_campaign=bulk_promo&utm_content=article-slug-pin-01
```

Recommended boards:

- `Renter-Friendly Fixes`
- `Small Kitchen Organization`
- `Moving Day Checklists`
- `Small Apartment Storage`
- `No-Drill Apartment Ideas`

## Disclosure

Pinterest descriptions should include a clear disclosure such as `#ad` when the linked page contains affiliate links. The Pin links to the article, and the article includes the Amazon Associate disclosure.

## Build Commands

Generate promo assets:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\build-promo-assets.ps1
```

Rebuild site:

```powershell
node .\scripts\build-site.js
```

If normal Node is unavailable, Codex can use its bundled Node runtime.
