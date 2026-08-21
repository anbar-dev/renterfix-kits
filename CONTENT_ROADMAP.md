# Apartment Survival Kits Content Roadmap

Working positioning:

> Minimal, renter-safe kits for move-in, daily apartment problems, and move-out.

Core promise:

> Buy only what your rental actually needs.

This file is the editorial backlog for the static site. When creating a new page, pick a planned page from here, create the HTML page, then update its status.

Status values:

- `published`: page already exists on the site.
- `next`: strong candidate for the next build.
- `planned`: good future page.
- `hold`: useful idea, but not first priority.

Page formula:

- Start with the renter problem, not the product.
- Include deposit risk, space cost, install effort, move-out friction, and buy priority.
- Recommend a minimum kit, optional upgrades, what not to buy, and move-out notes.
- Use Amazon affiliate links with the Associates tag already in the URL.
- Do not manually copy Amazon prices, star ratings, reviews, or product images.

## Site Categories

Recommended public category structure:

- `/kits/move-in/` - first apartment and move-in essentials.
- `/kits/kitchen/` - minimum kitchen, cooking, counter space, pantry, dishwashing.
- `/kits/cleaning/` - move-in cleaning, weekly reset, bathroom, natural cleaning.
- `/kits/no-drill/` - renter-safe fixes that avoid holes and permanent mounting.
- `/kits/small-space/` - storage and layout fixes for tiny apartments.
- `/kits/daily-fixes/` - annoying daily problems: light, noise, smell, heat, pests.
- `/kits/move-out/` - deposit recovery, residue, scuffs, patching, final cleaning.
- `/guides/` - comparison and trust pages, especially "what not to buy".

The site now uses a tiny static generator:

- Source HTML lives in `/src/pages/` and `/src/kits/`.
- Shared CSS and JS live in `/assets/`.
- The build output lives in `/docs/`.
- GitHub Pages should publish `/docs/`.
- Category pages and `sitemap.xml` are generated automatically.

When adding a full kit page, create an HTML source file under `/src/kits/<category>/`, with metadata at the top, then rebuild the site.

## Current Published Pages

| Status | Page | Current URL | Primary intent |
| --- | --- | --- | --- |
| published | Home | `/` | renter kit category portal |
| published | All kits | `/kits/` | kit directory |
| published | Move-in category | `/kits/move-in/` | first apartment and move-in essentials hub |
| published | Kitchen category | `/kits/kitchen/` | kitchen kit hub |
| published | Cleaning category | `/kits/cleaning/` | cleaning kit hub |
| published | No-drill category | `/kits/no-drill/` | no-drill renter fix hub |
| published | Small-space category | `/kits/small-space/` | small apartment systems hub |
| published | Daily fixes category | `/kits/daily-fixes/` | daily apartment problems hub |
| published | Move-out category | `/kits/move-out/` | move-out and deposit hub |
| published | Guides category | `/guides/` | trust and buying strategy hub |
| published | About | `/about/` | trust and positioning |
| published | Affiliate disclosure | `/affiliate-disclosure/` | Amazon disclosure |
| published | Privacy | `/privacy/` | basic privacy |
| published | Contact/request placeholder | `/contact/` | future requests |

## Priority Pages

These are the first pages to create because they are broad enough to monetize, specific enough for long-tail search, and useful enough to share.

| Status | Category | Page title | Suggested URL | Long-tail targets |
| --- | --- | --- | --- | --- |
| published | Move-in | Minimum Kitchen Kit for First Apartment Renters | `/kits/kitchen/minimum-kitchen-kit/` | minimum kitchen essentials for first apartment; first apartment kitchen essentials for someone who barely cooks; what kitchen items do I need for first apartment |
| published | Cleaning | First Apartment Cleaning Kit | `/kits/cleaning/first-apartment-cleaning-kit/` | first apartment cleaning supplies checklist; move in cleaning supplies apartment; basic cleaning supplies for first apartment |
| published | Move-in | Basic Tool Kit for Apartment Renters | `/kits/move-in/basic-tool-kit/` | basic tool kit for apartment renters; tools every renter needs; first apartment tool kit |
| published | Move-in | Open-First Box for Moving Day | `/kits/move-in/open-first-box/` | open first box checklist apartment; what to pack in first night box; moving day essentials apartment |
| published | Small-space | Entryway Without a Closet Kit | `/kits/small-space/entryway-no-closet/` | apartment entryway no closet; no closet entryway storage; small apartment entryway storage renter friendly |
| published | Kitchen | Tiny Kitchen Counter-Space Kit | `/kits/kitchen/tiny-counter-space/` | small apartment kitchen no counter space; tiny rental kitchen counter space; kitchen cart for small apartment |
| published | No-drill | No-Drill Cable Management Kit | `/kits/no-drill/cable-management/` | cable management for renters; hide cords apartment without drilling; renter friendly cable raceway |
| published | Daily fixes | Closet Smell and Dampness Kit | `/kits/daily-fixes/closet-smell-dampness/` | closet smells musty apartment; damp closet rental; how to fix musty closet smell |
| published | Move-out | Move-Out Cleaning Kit | `/kits/move-out/cleaning-kit/` | move out cleaning supplies apartment; apartment move out cleaning checklist; cleaning products to get deposit back |
| published | No-drill | No-Drill Wall Decor Kit | `/kits/no-drill/wall-decor/` | hang wall art in rental without holes; renter friendly wall decor; command strips damage apartment walls |
| published | Kitchen | No-Pantry Kitchen Organization Kit | `/kits/kitchen/no-pantry-organization/` | apartment kitchen no pantry; small kitchen pantry alternatives; no pantry storage ideas apartment |
| published | Daily fixes | Rental Door Security Without Drilling | `/kits/daily-fixes/door-security-no-drill/` | apartment door security without drilling; renter friendly door security; portable door lock apartment |

## Move-In Cluster

| Status | Page title | Suggested URL | Long-tail targets |
| --- | --- | --- | --- |
| planned | First Apartment Essentials, Minimal Version | `/kits/move-in/first-apartment-essentials-minimal/` | first apartment essentials checklist; first apartment essentials under budget; things you actually need for first apartment |
| published | Basic Tool Kit for Apartment Renters | `/kits/move-in/basic-tool-kit/` | basic tool kit for apartment renters; tools every renter needs; first apartment tool kit |
| published | Open-First Box for Moving Day | `/kits/move-in/open-first-box/` | open first box checklist apartment; moving day essentials apartment; first night in new apartment checklist |
| planned | First Apartment Bathroom Kit | `/kits/move-in/bathroom-starter-kit/` | first apartment bathroom essentials; bathroom starter kit apartment; what to buy for first apartment bathroom |
| planned | First Apartment Laundry Kit | `/kits/move-in/laundry-starter-kit/` | first apartment laundry essentials; apartment laundry supplies; laundry starter kit for renters |
| planned | First Night Sleep Kit | `/kits/move-in/first-night-sleep-kit/` | first night in new apartment essentials; moving day sleep kit; what to unpack first apartment |

## Kitchen Cluster

| Status | Page title | Suggested URL | Long-tail targets |
| --- | --- | --- | --- |
| published | Minimum Kitchen Kit for First Apartment Renters | `/kits/kitchen/minimum-kitchen-kit/` | minimum kitchen essentials for first apartment; first apartment kitchen essentials for someone who barely cooks; what kitchen items do I need for first apartment |
| planned | Kitchen Kit for Renters Who Barely Cook | `/kits/kitchen/barely-cook-kit/` | kitchen essentials for people who do not cook; first apartment kitchen basics no cooking; minimalist kitchen kit apartment |
| planned | Kitchen Kit for Renters Who Cook Daily | `/kits/kitchen/cook-daily-kit/` | apartment kitchen essentials for cooking daily; small kitchen cooking essentials; first apartment cooking kit |
| next | Tiny Kitchen Counter-Space Kit | `/kits/kitchen/tiny-counter-space/` | small apartment kitchen no counter space; tiny rental kitchen counter space; kitchen cart for small apartment |
| published | No-Pantry Kitchen Organization Kit | `/kits/kitchen/no-pantry-organization/` | apartment kitchen no pantry; small kitchen pantry alternatives; no pantry storage ideas apartment |
| published | No-Dishwasher Kitchen Survival Kit | `/kits/kitchen/no-dishwasher-kit/` | apartment no dishwasher what to buy; dish drying rack small kitchen; no dishwasher apartment essentials |
| planned | Rental Kitchen Upgrade Without Contact Paper | `/kits/kitchen/no-contact-paper-upgrade/` | renter friendly kitchen upgrade no contact paper; how to make rental kitchen look better no damage; peel and stick contact paper rental risk |

## Cleaning Cluster

| Status | Page title | Suggested URL | Long-tail targets |
| --- | --- | --- | --- |
| published | First Apartment Cleaning Kit | `/kits/cleaning/first-apartment-cleaning-kit/` | first apartment cleaning supplies checklist; move in cleaning supplies apartment; basic cleaning supplies for first apartment |
| planned | Move-In Deep Cleaning Kit | `/kits/cleaning/move-in-deep-cleaning-kit/` | move in deep cleaning supplies; clean apartment before moving in checklist; rental move in cleaning kit |
| planned | Weekly Reset Cleaning Kit | `/kits/cleaning/weekly-reset-kit/` | weekly reset cleaning checklist; apartment cleaning reset supplies; cleaning list by room step by step |
| planned | Bathroom Deep-Clean Kit for Renters | `/kits/cleaning/bathroom-deep-clean-kit/` | apartment bathroom deep cleaning supplies; rental bathroom cleaning kit; clean old apartment bathroom |
| planned | Natural Cleaning Starter Kit | `/kits/cleaning/natural-cleaning-starter-kit/` | natural cleaning starter kit; vinegar cleaning solution supplies; non toxic cleaning apartment |
| planned | Pet-Friendly Apartment Cleaning Kit | `/kits/cleaning/pet-friendly-cleaning-kit/` | pet friendly cleaning supplies apartment; renter cleaning kit with cat; dog apartment cleaning supplies |

## No-Drill Cluster

| Status | Page title | Suggested URL | Long-tail targets |
| --- | --- | --- | --- |
| published | No-Drill Curtains for Renters | `/kits/no-drill/no-drill-curtains/` | how to hang curtains in rental without holes; no drill curtains apartment; tension rod curtains rental |
| published | No-Drill Bathroom Storage | `/kits/no-drill/bathroom-storage/` | how to add storage to apartment bathroom without drilling; no drill bathroom storage rental; tiny rental bathroom storage |
| next | No-Drill Cable Management Kit | `/kits/no-drill/cable-management/` | cable management for renters; hide cords apartment without drilling; renter friendly cable raceway |
| published | No-Drill Wall Decor Kit | `/kits/no-drill/wall-decor/` | hang wall art in rental without holes; renter friendly wall decor; command strips damage apartment walls |
| planned | No-Drill Entryway Hooks | `/kits/no-drill/entryway-hooks/` | no drill entryway hooks apartment; renter friendly coat hooks; apartment hooks without holes |
| planned | No-Drill Shelf Alternatives | `/kits/no-drill/shelf-alternatives/` | shelves for renters without drilling; no drill shelf alternatives; renter friendly storage shelves |
| planned | Renter-Friendly Balcony Setup | `/kits/no-drill/balcony-setup/` | renter friendly balcony makeover; apartment balcony kit; small balcony setup apartment |

## Small-Space Cluster

| Status | Page title | Suggested URL | Long-tail targets |
| --- | --- | --- | --- |
| published | Entryway Without a Closet Kit | `/kits/small-space/entryway-no-closet/` | apartment entryway no closet; no closet entryway storage; small apartment entryway storage renter friendly |
| published | No-Closet Bedroom Storage Kit | `/kits/small-space/no-closet-bedroom-storage/` | bedroom no closet storage apartment; no closet bedroom ideas rental; freestanding wardrobe apartment |
| planned | Under-Bed Storage Kit | `/kits/small-space/under-bed-storage/` | under bed storage for small apartment; renter under bed storage; small bedroom storage kit |
| planned | Studio Apartment Storage Kit | `/kits/small-space/studio-storage-kit/` | studio apartment storage ideas; small studio apartment organization; storage kit for studio apartment |
| next | Tiny Bathroom Storage | `/kits/small-space/tiny-bathroom-storage/` | tiny apartment bathroom storage; small rental bathroom no storage; no drill bathroom storage |
| planned | Small Laundry Area Organization | `/kits/small-space/small-laundry-organization/` | laundry room organization small space; apartment laundry closet organization; small laundry area storage |
| planned | Reading Nook for Small Apartment | `/kits/small-space/reading-nook/` | cozy reading chair small spaces; reading nook small apartment; closet reading nook adults |

## Daily Fixes Cluster

| Status | Page title | Suggested URL | Long-tail targets |
| --- | --- | --- | --- |
| published | Dark Apartment Lighting | `/kits/daily-fixes/dark-apartment-lighting/` | apartment has no ceiling light what to buy; dark apartment lighting ideas; plug in lighting for apartment |
| published | Closet Smell and Dampness Kit | `/kits/daily-fixes/closet-smell-dampness/` | closet smells musty apartment; damp closet rental; how to fix musty closet smell |
| planned | Noisy Neighbor Kit | `/kits/daily-fixes/noisy-neighbor-kit/` | noisy neighbors apartment what to buy; reduce noise in apartment rental; soundproof apartment renter friendly |
| planned | Room Too Hot Kit | `/kits/daily-fixes/room-too-hot-kit/` | apartment room too hot what to buy; cool down apartment bedroom; renter friendly cooling kit |
| planned | Room Too Cold Kit | `/kits/daily-fixes/room-too-cold-kit/` | apartment room too cold what to buy; renter friendly draft stopper; cold apartment bedroom kit |
| planned | Bad Shower Pressure Basics | `/kits/daily-fixes/shower-pressure-basics/` | apartment shower pressure low; renter shower head replacement; rental shower upgrade |
| planned | Roach Sighting Move-In Kit | `/kits/daily-fixes/roach-sighting-kit/` | saw roach before moving in apartment; roach prevention apartment kit; apartment pest prevention supplies |
| published | Rental Door Security Without Drilling | `/kits/daily-fixes/door-security-no-drill/` | apartment door security without drilling; renter friendly door security; portable door lock apartment |

## Move-Out Cluster

| Status | Page title | Suggested URL | Long-tail targets |
| --- | --- | --- | --- |
| next | Move-Out Wall Repair Kit | `/kits/move-out/wall-repair-kit/` | small holes apartment wall repair; move out wall repair kit; fix scuffs apartment wall |
| published | Move-Out Cleaning Kit | `/kits/move-out/cleaning-kit/` | move out cleaning supplies apartment; apartment move out cleaning checklist; cleaning products to get deposit back |
| planned | Adhesive Residue Removal Kit | `/kits/move-out/adhesive-residue-removal/` | how to remove command strip residue apartment wall; adhesive residue remover painted walls; remove tape residue rental |
| planned | Carpet Stain Kit for Renters | `/kits/move-out/carpet-stain-kit/` | apartment carpet stain cleaning kit; remove carpet stains before move out; renter carpet stain deposit |
| planned | Deposit-Safe Final Walkthrough Checklist | `/kits/move-out/final-walkthrough-checklist/` | how to get security deposit back apartment checklist; final walkthrough apartment checklist; move out inspection checklist renter |
| planned | Move-Out Patch or Do Not Patch Guide | `/guides/should-renters-patch-wall-holes/` | should I patch nail holes apartment; landlord says not to patch holes; apartment move out wall holes |

## Guides And Trust Pages

These pages may not monetize as directly, but they build trust and internal links to kit pages.

| Status | Page title | Suggested URL | Long-tail targets |
| --- | --- | --- | --- |
| published | Things First Apartment Renters Can Skip | `/guides/first-apartment-things-to-skip/` | things you do not need for first apartment; first apartment essentials not worth buying; first apartment overbuying |
| published | Command Strips vs Tension Rods vs Freestanding Storage | `/guides/command-strips-vs-tension-rods/` | command strips damage apartment walls; tension rod vs command strips; renter friendly mounting options |
| published | How Deposit Risk Scores Work | `/guides/deposit-risk-score/` | renter friendly damage risk; deposit safe apartment products; how to avoid losing security deposit |
| planned | Renter-Friendly Does Not Always Mean Damage-Free | `/guides/renter-friendly-not-damage-free/` | renter friendly products damage walls; peel and stick rental damage; adhesive shelves rental risk |
| published | Minimal First Apartment Buying Strategy | `/guides/minimal-first-apartment-buying-strategy/` | what to buy first apartment first; first apartment essentials priority; first apartment budget buying guide |

## Content Selection Rules

When choosing the next page, prefer topics that meet at least three criteria:

- Solves a concrete pain, not a vague decor desire.
- Can recommend 3-8 Amazon products naturally.
- Has a clear "what not to buy" section.
- Applies to many American renters.
- Has long-tail phrasing around first apartment, renter friendly, no drill, small apartment, or move-out.
- Can be shared on Reddit as advice without feeling like an ad.
- Can become a Pinterest pin with a simple checklist.

Avoid pages that are mostly style inspiration unless they include a real constraint such as no drilling, tiny space, low budget, no pantry, no closet, or move-out risk.

## Future Promotion Notes

For every new page, create:

- 1 Reddit-style helpful answer that can be posted manually with disclosure if linking.
- 3 Pinterest pin titles.
- 1 short meta description.
- 3 internal links to related pages.

Promotion angles:

- "Minimum kit" beats "ultimate list".
- "What to skip" builds trust.
- "Deposit risk" differentiates from ordinary affiliate pages.
- "Open-first box", "moving day", and "move-out panic" are high-intent moments.
