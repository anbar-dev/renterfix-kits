const fs = require("fs");
const path = require("path");

const rootDir = path.resolve(__dirname, "..");
const outDir = path.join(rootDir, "docs");
const sourceDirs = [path.join(rootDir, "src", "pages"), path.join(rootDir, "src", "kits")];
const assetSource = path.join(rootDir, "assets");

const site = {
  name: "RenterFix Kits",
  baseUrl: "https://apartmentsurvivalkits.com",
  customDomain: "apartmentsurvivalkits.com",
  analyticsId: "G-LKHYE9G1SS",
  description: "Minimal, renter-safe kits for move-in, daily apartment problems, and move-out."
};

const categories = [
  {
    slug: "move-in",
    title: "Move-in kits",
    eyebrow: "Move-in",
    description: "First apartment essentials, basic tools, open-first boxes, bathroom supplies, laundry, and first-night basics.",
    planned: [
      "Minimum kitchen kit",
      "Basic tool kit",
      "Open-first box",
      "Bathroom starter kit",
      "Laundry starter kit",
      "First-night sleep kit"
    ]
  },
  {
    slug: "kitchen",
    title: "Kitchen kits",
    eyebrow: "Kitchen",
    description: "Minimum cooking setups, tiny counter-space fixes, no-pantry storage, no-dishwasher routines, and renter-safe kitchen upgrades.",
    planned: [
      "Minimum kitchen kit",
      "Barely-cook kitchen kit",
      "Cook-daily kitchen kit",
      "Tiny counter-space kit",
      "No-pantry organization",
      "No-dishwasher survival kit"
    ]
  },
  {
    slug: "cleaning",
    title: "Cleaning kits",
    eyebrow: "Cleaning",
    description: "Move-in cleaning, weekly resets, bathroom deep cleans, natural cleaning, pet-friendly supplies, and move-out cleaning.",
    planned: [
      "First apartment cleaning kit",
      "Move-in deep cleaning kit",
      "Weekly reset kit",
      "Bathroom deep-clean kit",
      "Natural cleaning starter kit",
      "Pet-friendly cleaning kit"
    ]
  },
  {
    slug: "no-drill",
    title: "No-drill fixes",
    eyebrow: "No-drill",
    description: "Deposit-aware fixes for curtains, wall decor, cable management, bathroom storage, hooks, shelves, and balconies.",
    planned: [
      "No-drill curtains",
      "No-drill bathroom storage",
      "No-drill cable management",
      "No-drill wall decor",
      "No-drill entryway hooks",
      "Renter-friendly balcony setup"
    ]
  },
  {
    slug: "small-space",
    title: "Small-space systems",
    eyebrow: "Small-space",
    description: "No closet, no pantry, under-bed storage, studio layouts, tiny bathrooms, compact laundry, and cramped entryways.",
    planned: [
      "Entryway without a closet",
      "No-closet bedroom storage",
      "Under-bed storage",
      "Studio apartment storage",
      "Tiny bathroom storage",
      "Small laundry organization"
    ]
  },
  {
    slug: "daily-fixes",
    title: "Daily apartment fixes",
    eyebrow: "Daily fixes",
    description: "Recurring apartment annoyances: dark rooms, musty closets, noise, heat, cold, shower pressure, pests, and renter security.",
    planned: [
      "Dark apartment lighting",
      "Closet smell and dampness",
      "Noisy neighbor kit",
      "Room too hot",
      "Room too cold",
      "Door security without drilling"
    ]
  },
  {
    slug: "move-out",
    title: "Move-out kits",
    eyebrow: "Move-out",
    description: "Deposit recovery, final cleaning, adhesive residue, carpet stains, wall repair, walkthrough prep, and patch-or-not decisions.",
    planned: [
      "Move-out cleaning kit",
      "Wall repair kit",
      "Adhesive residue removal",
      "Carpet stain kit",
      "Final walkthrough checklist",
      "Patch or do not patch?"
    ]
  }
];

const guidePlans = [
  "Things first apartment renters can skip",
  "Command strips vs tension rods",
  "How deposit risk scores work",
  "Renter-friendly is not damage-free",
  "Minimal first apartment buying strategy"
];

function escapeHtml(value) {
  return String(value)
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;");
}

function walkFiles(dir) {
  if (!fs.existsSync(dir)) return [];
  return fs.readdirSync(dir, { withFileTypes: true }).flatMap((entry) => {
    const fullPath = path.join(dir, entry.name);
    if (entry.isDirectory()) return walkFiles(fullPath);
    return entry.isFile() && entry.name.endsWith(".html") ? [fullPath] : [];
  });
}

function parseSource(filePath) {
  const raw = fs.readFileSync(filePath, "utf8");
  const match = raw.match(/^<!--\s*([\s\S]*?)\s*-->\s*/);
  const meta = {};
  let body = raw;

  if (match) {
    body = raw.slice(match[0].length);
    match[1].split(/\r?\n/).forEach((line) => {
      const pair = line.match(/^\s*([A-Za-z0-9_-]+):\s*(.*?)\s*$/);
      if (pair) meta[pair[1]] = pair[2];
    });
  }

  if (!meta.path || !meta.title || !meta.description) {
    throw new Error(`Missing required metadata in ${filePath}`);
  }

  return { filePath, meta, body };
}

function rootPrefix(urlPath) {
  const clean = urlPath.replace(/^\/|\/$/g, "");
  if (!clean) return "";
  return "../".repeat(clean.split("/").length);
}

function destinationFor(urlPath) {
  const clean = urlPath.replace(/^\/|\/$/g, "");
  return clean ? path.join(outDir, clean, "index.html") : path.join(outDir, "index.html");
}

function canonicalUrl(urlPath) {
  const clean = urlPath === "/" ? "/" : `/${urlPath.replace(/^\/|\/$/g, "")}/`;
  return `${site.baseUrl}${clean === "/" ? "/" : clean}`;
}

function renderHeader(root) {
  return `
  <header class="site-header">
    <nav class="nav" aria-label="Main navigation">
      <a class="brand" href="${root}"><span class="brand-mark">R</span><span>${site.name}</span></a>
      <button class="menu-button" data-menu-button aria-expanded="false" aria-label="Open menu">=</button>
      <div class="nav-links" data-nav-links>
        <a href="${root}kits/">Kits</a>
        <a href="${root}guides/">Guides</a>
        <a href="${root}about/">About</a>
        <a href="${root}affiliate-disclosure/">Disclosure</a>
      </div>
    </nav>
  </header>`;
}

function renderFooter(root) {
  return `
  <footer class="footer">
    <div class="footer-inner">
      <span>${site.name}</span>
      <span>As an Amazon Associate, this site earns from qualifying purchases.</span>
      <span><a href="${root}privacy/">Privacy</a> | <a href="${root}affiliate-disclosure/">Affiliate disclosure</a></span>
    </div>
  </footer>`;
}

function renderAnalytics() {
  if (!site.analyticsId) return "";
  return `  <script async src="https://www.googletagmanager.com/gtag/js?id=${site.analyticsId}"></script>
  <script>
    window.dataLayer = window.dataLayer || [];
    function gtag(){dataLayer.push(arguments);}
    gtag('js', new Date());
    gtag('config', '${site.analyticsId}');
  </script>
`;
}

function renderPage({ title, description, urlPath, body }) {
  const root = rootPrefix(urlPath);
  return `<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>${escapeHtml(title)}</title>
  <meta name="description" content="${escapeHtml(description)}">
  <link rel="canonical" href="${canonicalUrl(urlPath)}">
  <link rel="stylesheet" href="${root}assets/style.css">
${renderAnalytics().trimEnd()}
</head>
<body>
${renderHeader(root)}
  <main>
${body.trim()}
  </main>
${renderFooter(root)}
  <script src="${root}assets/script.js"></script>
</body>
</html>
`;
}

function categoryCard(category) {
  return `<article class="card kit-card">
  <div class="pill-row"><span class="pill">${escapeHtml(category.eyebrow)}</span></div>
  <h3>${escapeHtml(category.title)}</h3>
  <p>${escapeHtml(category.description)}</p>
  <a class="link" href="${category.slug}/">Open category</a>
</article>`;
}

function plannedList(items) {
  return items.map((item) => `<li>${escapeHtml(item)}</li>`).join("");
}

function renderKitCards(pages, currentPath) {
  if (!pages.length) {
    return `<div class="empty-state card">
  <h2>Kit pages coming soon.</h2>
  <p>This category is being shaped around practical renter problems. Start with the planned topics below, or browse another category with finished kits.</p>
</div>`;
  }

  return `<div class="grid three">
${pages.map((page) => {
    const href = relativeHref(currentPath, page.meta.path);
    return `<article class="card kit-card">
  <div class="pill-row"><span class="pill">${escapeHtml(page.meta.category || "Kit")}</span></div>
  <h3>${escapeHtml(page.meta.title)}</h3>
  <p>${escapeHtml(page.meta.summary || page.meta.description)}</p>
  <a class="link" href="${href}">Open kit</a>
</article>`;
  }).join("\n")}
</div>`;
}

function relativeHref(fromPath, toPath) {
  const fromDir = path.posix.dirname(`/${fromPath.replace(/^\/|\/$/g, "")}/index.html`);
  const toDir = `/${toPath.replace(/^\/|\/$/g, "")}/`;
  let rel = path.posix.relative(fromDir, toDir);
  if (!rel) rel = ".";
  return rel.endsWith("/") ? rel : `${rel}/`;
}

function renderCategoryPage(category, pages) {
  const urlPath = `/kits/${category.slug}/`;
  const published = pages.filter((page) => page.meta.category === category.slug && page.meta.type === "kit");
  const body = `
    <section class="page-hero">
      <div class="page-title">
        <p class="eyebrow">${escapeHtml(category.eyebrow)}</p>
        <h1>${escapeHtml(category.title)}.</h1>
        <p>${escapeHtml(category.description)}</p>
      </div>
    </section>
    <section class="section">
      <div class="section-title">
        <div>
          <p class="eyebrow">Available kits</p>
          <h2>Start with a specific renter problem.</h2>
          <p>Each finished kit keeps the list compact, calls out renter risk, and separates useful basics from things most people can skip.</p>
        </div>
      </div>
      ${renderKitCards(published, urlPath)}
    </section>
    <section class="band">
      <div class="section">
        <div class="section-title">
          <div>
            <p class="eyebrow">Coming next</p>
            <h2>More problems in this category.</h2>
            <p>These are common renter situations worth solving with a compact, deposit-aware kit.</p>
          </div>
        </div>
        <div class="card roadmap-list"><ul>${plannedList(category.planned)}</ul></div>
      </div>
    </section>`;

  return {
    urlPath,
    html: renderPage({
      title: `${category.title} | ${site.name}`,
      description: category.description,
      urlPath,
      body
    })
  };
}

function renderKitsIndex() {
  const body = `
    <section class="page-hero">
      <div class="page-title">
        <p class="eyebrow">Content map</p>
        <h1>Renter kit categories.</h1>
        <p>The site is organized around problems renters actually search for: move-in, kitchen, cleaning, no-drill fixes, small-space systems, daily annoyances, and move-out.</p>
      </div>
    </section>
    <section class="section">
      <div class="grid three">
        ${categories.map(categoryCard).join("\n")}
        <article class="card kit-card">
          <div class="pill-row"><span class="pill">Guides</span></div>
          <h3>Guides</h3>
          <p>Trust pages for comparisons, risk scoring, and what renters can skip before buying.</p>
          <a class="link" href="../guides/">Open guides</a>
        </article>
      </div>
    </section>`;

  return {
    urlPath: "/kits/",
    html: renderPage({
      title: `Renter Kit Categories | ${site.name}`,
      description: "Browse renter-friendly kit categories for move-in, kitchen, cleaning, no-drill fixes, small spaces, daily problems, and move-out.",
      urlPath: "/kits/",
      body
    })
  };
}

function renderGuidesIndex(pages) {
  const published = pages.filter((page) => page.meta.type === "guide");
  const body = `
    <section class="page-hero">
      <div class="page-title">
        <p class="eyebrow">Guides</p>
        <h1>Trust pages and buying strategy.</h1>
        <p>Comparison pages and buying guides for renter risk, what to skip, and how to avoid buying the wrong thing.</p>
      </div>
    </section>
    <section class="section">
      ${renderKitCards(published, "/guides/")}
    </section>
    <section class="band">
      <div class="section">
        <div class="section-title">
          <div>
            <p class="eyebrow">Coming next</p>
            <h2>More buying guides.</h2>
          </div>
        </div>
        <div class="card roadmap-list"><ul>${plannedList(guidePlans)}</ul></div>
      </div>
    </section>`;

  return {
    urlPath: "/guides/",
    html: renderPage({
      title: `Renter Buying Guides | ${site.name}`,
      description: "Renter buying guides about deposit risk, no-drill tradeoffs, minimal first apartment shopping, and what to skip.",
      urlPath: "/guides/",
      body
    })
  };
}

function renderSitemap(paths) {
  const urls = paths
    .sort()
    .map((urlPath) => `  <url><loc>${canonicalUrl(urlPath)}</loc></url>`)
    .join("\n");

  return `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
${urls}
</urlset>
`;
}

function renderRobots() {
  return `User-agent: *
Allow: /

Sitemap: ${site.baseUrl}/sitemap.xml
`;
}

function copyDir(src, dest) {
  if (!fs.existsSync(src)) return;
  fs.mkdirSync(dest, { recursive: true });
  for (const entry of fs.readdirSync(src, { withFileTypes: true })) {
    const srcPath = path.join(src, entry.name);
    const destPath = path.join(dest, entry.name);
    if (entry.isDirectory()) {
      copyDir(srcPath, destPath);
    } else if (entry.isFile()) {
      fs.copyFileSync(srcPath, destPath);
    }
  }
}

function writeOutput(urlPath, html) {
  const dest = destinationFor(urlPath);
  fs.mkdirSync(path.dirname(dest), { recursive: true });
  fs.writeFileSync(dest, html, "utf8");
}

function build() {
  const resolvedOut = path.resolve(outDir);
  if (!resolvedOut.startsWith(rootDir + path.sep)) {
    throw new Error(`Refusing to write outside project: ${resolvedOut}`);
  }

  fs.rmSync(outDir, { recursive: true, force: true });
  fs.mkdirSync(outDir, { recursive: true });

  const pages = sourceDirs.flatMap(walkFiles).map(parseSource);
  const outputs = [];

  for (const page of pages) {
    outputs.push({
      urlPath: page.meta.path,
      html: renderPage({
        title: page.meta.title,
        description: page.meta.description,
        urlPath: page.meta.path,
        body: page.body
      })
    });
  }

  outputs.push(renderKitsIndex());
  outputs.push(renderGuidesIndex(pages));
  for (const category of categories) outputs.push(renderCategoryPage(category, pages));

  const paths = new Set();
  for (const output of outputs) {
    writeOutput(output.urlPath, output.html);
    paths.add(output.urlPath);
  }

  copyDir(assetSource, path.join(outDir, "assets"));
  fs.writeFileSync(path.join(outDir, "sitemap.xml"), renderSitemap([...paths]), "utf8");
  fs.writeFileSync(path.join(outDir, "robots.txt"), renderRobots(), "utf8");
  fs.writeFileSync(path.join(outDir, "CNAME"), `${site.customDomain}\n`, "utf8");
  fs.writeFileSync(path.join(outDir, ".nojekyll"), "", "utf8");

  console.log(`Built ${paths.size} pages into ${path.relative(rootDir, outDir)}`);
}

build();
