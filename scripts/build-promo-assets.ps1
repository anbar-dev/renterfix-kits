Add-Type -AssemblyName System.Drawing

$ErrorActionPreference = "Stop"

$Root = Resolve-Path (Join-Path $PSScriptRoot "..")
$PromoRoot = Join-Path $Root "promo"
$BaseUrl = "https://apartmentsurvivalkits.com"

function New-Dir($Path) {
  if (-not (Test-Path $Path)) {
    New-Item -ItemType Directory -Path $Path | Out-Null
  }
}

function Escape-Csv($Value) {
  $Text = [string]$Value
  '"' + $Text.Replace('"', '""') + '"'
}

function Add-TrackingUrl($Url, $Slug, $PinFile) {
  $Content = ($PinFile -replace '\.png$', '') -replace '[^a-zA-Z0-9_-]', '-'
  $Separator = "?"
  if ($Url.Contains("?")) {
    $Separator = "&"
  }
  return "$Url$Separator" + "utm_source=pinterest&utm_medium=social&utm_campaign=bulk_promo&utm_content=$Slug-$Content"
}

function New-Brush($Hex) {
  $Color = [System.Drawing.ColorTranslator]::FromHtml($Hex)
  New-Object System.Drawing.SolidBrush($Color)
}

function Add-RoundedRect($Graphics, $Brush, $X, $Y, $W, $H, $R) {
  $Path = New-Object System.Drawing.Drawing2D.GraphicsPath
  $D = $R * 2
  $Path.AddArc($X, $Y, $D, $D, 180, 90)
  $Path.AddArc($X + $W - $D, $Y, $D, $D, 270, 90)
  $Path.AddArc($X + $W - $D, $Y + $H - $D, $D, $D, 0, 90)
  $Path.AddArc($X, $Y + $H - $D, $D, $D, 90, 90)
  $Path.CloseFigure()
  $Graphics.FillPath($Brush, $Path)
  $Path.Dispose()
}

function Draw-WrappedText($Graphics, $Text, $Font, $Brush, $X, $Y, $MaxWidth, $LineHeight) {
  $Words = ([string]$Text).Split(" ")
  $Line = ""
  $CurrentY = $Y

  foreach ($Word in $Words) {
    $Candidate = if ($Line.Length) { "$Line $Word" } else { $Word }
    $Size = $Graphics.MeasureString($Candidate, $Font)
    if ($Size.Width -gt $MaxWidth -and $Line.Length) {
      $Graphics.DrawString($Line, $Font, $Brush, $X, $CurrentY)
      $CurrentY += $LineHeight
      $Line = $Word
    } else {
      $Line = $Candidate
    }
  }

  if ($Line.Length) {
    $Graphics.DrawString($Line, $Font, $Brush, $X, $CurrentY)
    $CurrentY += $LineHeight
  }

  return $CurrentY
}

function Draw-Pin($Pin, $Article, $Index, $OutPath) {
  $W = 1000
  $H = 1500
  $Bitmap = New-Object System.Drawing.Bitmap($W, $H)
  $Graphics = [System.Drawing.Graphics]::FromImage($Bitmap)
  $Graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $Graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

  $Bg = New-Brush $Pin.Bg
  $Ink = New-Brush $Pin.Ink
  $Muted = New-Brush $Pin.Muted
  $Panel = New-Brush $Pin.Panel
  $Accent = New-Brush $Pin.Accent
  $Paper = New-Brush "#fbfaf6"

  $Graphics.FillRectangle($Bg, 0, 0, $W, $H)
  Add-RoundedRect $Graphics $Panel 70 86 860 1228 36
  Add-RoundedRect $Graphics $Accent 70 86 860 18 9
  Add-RoundedRect $Graphics $Paper 770 1130 112 112 24

  $BrandFont = New-Object System.Drawing.Font("Segoe UI", 25, [System.Drawing.FontStyle]::Bold)
  $PillFont = New-Object System.Drawing.Font("Segoe UI", 24, [System.Drawing.FontStyle]::Bold)
  $TitleFont = New-Object System.Drawing.Font("Segoe UI", 68, [System.Drawing.FontStyle]::Bold)
  $SubFont = New-Object System.Drawing.Font("Segoe UI", 34, [System.Drawing.FontStyle]::Regular)
  $BulletFont = New-Object System.Drawing.Font("Segoe UI", 30, [System.Drawing.FontStyle]::Bold)
  $SmallFont = New-Object System.Drawing.Font("Segoe UI", 24, [System.Drawing.FontStyle]::Regular)
  $LogoFont = New-Object System.Drawing.Font("Segoe UI", 58, [System.Drawing.FontStyle]::Bold)

  $Y = 145
  $Graphics.DrawString("Apartment Survival Kits", $BrandFont, $Muted, 120, $Y)
  $Y += 86

  Add-RoundedRect $Graphics $Accent 120 $Y 300 54 18
  $Graphics.DrawString($Article.Category.ToUpperInvariant(), $PillFont, $Paper, 142, $Y + 9)
  $Y += 105

  $Y = Draw-WrappedText $Graphics $Pin.Title $TitleFont $Ink 120 $Y 760 78
  $Y += 34
  $Y = Draw-WrappedText $Graphics $Pin.Subtitle $SubFont $Muted 122 $Y 720 45
  $Y += 72

  foreach ($Bullet in $Pin.Bullets) {
    Add-RoundedRect $Graphics $Accent 124 ($Y + 9) 18 18 9
    $Y = Draw-WrappedText $Graphics $Bullet $BulletFont $Ink 164 $Y 670 40
    $Y += 28
  }

  Add-RoundedRect $Graphics $Ink 120 1140 520 84 24
  $Graphics.DrawString("Read the full kit", $BulletFont, $Paper, 154, 1161)

  $Graphics.DrawString("A", $LogoFont, $Accent, 805, 1148)
  $Graphics.DrawString("apartmentsurvivalkits.com", $SmallFont, $Muted, 120, 1270)
  $Graphics.DrawString("#ad", $SmallFont, $Muted, 800, 1270)

  $Bitmap.Save($OutPath, [System.Drawing.Imaging.ImageFormat]::Png)

  $BrandFont.Dispose()
  $PillFont.Dispose()
  $TitleFont.Dispose()
  $SubFont.Dispose()
  $BulletFont.Dispose()
  $SmallFont.Dispose()
  $LogoFont.Dispose()
  $Bg.Dispose()
  $Ink.Dispose()
  $Muted.Dispose()
  $Panel.Dispose()
  $Accent.Dispose()
  $Paper.Dispose()
  $Graphics.Dispose()
  $Bitmap.Dispose()
}

$Articles = @(
  [pscustomobject]@{
    Slug = "dark-apartment-lighting"
    Category = "Daily Fix"
    Board = "Renter-Friendly Fixes"
    Url = "$BaseUrl/kits/daily-fixes/dark-apartment-lighting/"
    Keywords = "apartment lighting, renter friendly lighting, no ceiling light, dark apartment, rental apartment ideas"
    VideoHook = "Your apartment has no ceiling light? Do not buy five tiny lamps first."
    Pins = @(
      [pscustomobject]@{
        File = "pin-01.png"
        Title = "Apartment Has No Ceiling Light?"
        Subtitle = "Start with one bright upward lamp, then add task lighting where your eyes actually work."
        Bullets = @("Floor lamp first", "Task light second", "Control visible cords")
        Description = "A renter-friendly lighting kit for dark apartments with no ceiling light, plug-in lighting ideas, and what to skip. This page contains Amazon affiliate links. #ad"
        Bg = "#d87558"; Panel = "#fbfaf6"; Ink = "#20231f"; Muted = "#62685f"; Accent = "#466a86"
      },
      [pscustomobject]@{
        File = "pin-02.png"
        Title = "Dark Rental Room? Fix It Without Drilling"
        Subtitle = "A simple lighting stack for renters: ambient, task, tiny dead zones, then cable cleanup."
        Bullets = @("No hardwiring", "No ceiling fixture needed", "Better first-night lighting")
        Description = "Dark apartment lighting ideas for renters: floor lamps, plug-in pendants, rechargeable lights, and safer cord routing. #ad"
        Bg = "#40543f"; Panel = "#fbfaf6"; Ink = "#20231f"; Muted = "#62685f"; Accent = "#efb857"
      },
      [pscustomobject]@{
        File = "pin-03.png"
        Title = "Stop Buying Tiny Lamps First"
        Subtitle = "If the whole room is dark, cute accent lamps are usually the wrong first purchase."
        Bullets = @("Bright ambient source", "One useful task light", "Skip weak mood lights")
        Description = "What to buy when an apartment has no ceiling light: a compact renter-friendly kit with product ideas and skip notes. #ad"
        Bg = "#466a86"; Panel = "#fbfaf6"; Ink = "#20231f"; Muted = "#62685f"; Accent = "#d87558"
      }
    )
  },
  [pscustomobject]@{
    Slug = "no-pantry-organization"
    Category = "Kitchen"
    Board = "Small Kitchen Organization"
    Url = "$BaseUrl/kits/kitchen/no-pantry-organization/"
    Keywords = "no pantry apartment, small kitchen organization, renter kitchen storage, pantry alternatives, apartment kitchen ideas"
    VideoHook = "No pantry in your apartment? Do not buy a giant container set first."
    Pins = @(
      [pscustomobject]@{
        File = "pin-01.png"
        Title = "No Pantry in Your Apartment?"
        Subtitle = "Build pantry behavior with cabinet shelves, door storage, visible cans, and one measured overflow zone."
        Bullets = @("Use cabinets first", "Measure before buying", "Skip random bins")
        Description = "Small kitchen pantry alternatives for apartments with no pantry: cabinet risers, door storage, bins, and what to skip. This page contains Amazon affiliate links. #ad"
        Bg = "#7d947c"; Panel = "#fbfaf6"; Ink = "#20231f"; Muted = "#62685f"; Accent = "#d87558"
      },
      [pscustomobject]@{
        File = "pin-02.png"
        Title = "Small Kitchen Storage Without Drilling"
        Subtitle = "A no-pantry setup for renters who need dry goods off the counter and out of random piles."
        Bullets = @("No wall shelves", "No permanent changes", "Cleaner food zones")
        Description = "A renter-friendly no-pantry kitchen organization kit for small apartments, tiny cabinets, and dry goods clutter. #ad"
        Bg = "#efb857"; Panel = "#fbfaf6"; Ink = "#20231f"; Muted = "#62685f"; Accent = "#40543f"
      },
      [pscustomobject]@{
        File = "pin-03.png"
        Title = "Do Not Buy Containers First"
        Subtitle = "The best no-pantry fix starts with zones: daily dry goods, cans, wraps, and overflow."
        Bullets = @("Fewer duplicates", "Less counter clutter", "Fits rental cabinets")
        Description = "How to organize food without a pantry in a small apartment, with renter-safe products and buying priorities. #ad"
        Bg = "#466a86"; Panel = "#fbfaf6"; Ink = "#20231f"; Muted = "#62685f"; Accent = "#efb857"
      }
    )
  },
  [pscustomobject]@{
    Slug = "open-first-box"
    Category = "Move-In"
    Board = "Moving Day Checklists"
    Url = "$BaseUrl/kits/move-in/open-first-box/"
    Keywords = "moving day checklist, first apartment essentials, first night box, move in checklist, apartment moving tips"
    VideoHook = "The most useful moving box is the one you do not put in the moving pile."
    Pins = @(
      [pscustomobject]@{
        File = "pin-01.png"
        Title = "Your First Box to Open on Moving Day"
        Subtitle = "Pack the boring things that save your first night: light, power, trash, labels, and box-opening tools."
        Bullets = @("Keep it separate", "Make it visible", "Use it before unpacking")
        Description = "Open first box checklist for apartment move-in day: what to pack for the first night before every other box is unpacked. This page contains Amazon affiliate links. #ad"
        Bg = "#d87558"; Panel = "#fbfaf6"; Ink = "#20231f"; Muted = "#62685f"; Accent = "#40543f"
      },
      [pscustomobject]@{
        File = "pin-02.png"
        Title = "First Night in a New Apartment Checklist"
        Subtitle = "Do not bury chargers, toiletries, trash bags, tape, markers, flashlight, or move-in documents."
        Bullets = @("Avoid midnight store runs", "Document damage early", "Unpack without panic")
        Description = "Moving day essentials for apartment renters: first-night items, tools, cleanup basics, and what not to bury in the truck. #ad"
        Bg = "#40543f"; Panel = "#fbfaf6"; Ink = "#20231f"; Muted = "#62685f"; Accent = "#efb857"
      },
      [pscustomobject]@{
        File = "pin-03.png"
        Title = "Do Not Pack These Too Deep"
        Subtitle = "The open-first box is not decoration. It is your first 24 hours in a visible bin."
        Bullets = @("Utility knife", "Power strip", "Trash bags")
        Description = "What to pack in a first-night moving box for an apartment, plus useful products and skip notes for renters. #ad"
        Bg = "#466a86"; Panel = "#fbfaf6"; Ink = "#20231f"; Muted = "#62685f"; Accent = "#d87558"
      }
    )
  }
)

New-Dir $PromoRoot

$CsvRows = New-Object System.Collections.Generic.List[string]
$CsvHeader = "Title,Media URL,Pinterest board,Thumbnail,Description,Link,Publish date,Keywords"
$CsvRows.Add($CsvHeader)
$ScheduleStart = (Get-Date).ToUniversalTime().Date.AddDays(1).AddHours(15)
$ScheduleOffset = 0

foreach ($Article in $Articles) {
  $ArticleDir = Join-Path $PromoRoot $Article.Slug
  $PinsDir = Join-Path $ArticleDir "pins"
  New-Dir $ArticleDir
  New-Dir $PinsDir
  $ArticleCsvRows = New-Object System.Collections.Generic.List[string]
  $ArticleCsvRows.Add($CsvHeader)

  $CopyLines = @(
    "# Pinterest Copy - $($Article.Slug)",
    "",
    "Article URL: $($Article.Url)",
    "Board: $($Article.Board)",
    "",
    "## Pins"
  )

  $Index = 1
  foreach ($Pin in $Article.Pins) {
    $OutPath = Join-Path $PinsDir $Pin.File
    Draw-Pin $Pin $Article $Index $OutPath
    $MediaUrl = "$BaseUrl/promo/$($Article.Slug)/pins/$($Pin.File)"
    $TrackedUrl = Add-TrackingUrl $Article.Url $Article.Slug $Pin.File
    $PublishDate = $ScheduleStart.AddDays($ScheduleOffset).ToString("yyyy-MM-ddTHH:mm:ss", [Globalization.CultureInfo]::InvariantCulture)
    $CsvRow = ((Escape-Csv $Pin.Title), (Escape-Csv $MediaUrl), (Escape-Csv $Article.Board), "", (Escape-Csv $Pin.Description), (Escape-Csv $TrackedUrl), (Escape-Csv $PublishDate), (Escape-Csv $Article.Keywords) -join ",")
    $CsvRows.Add($CsvRow)
    $ArticleCsvRows.Add($CsvRow)
    $CopyLines += @(
      "",
      "### $($Pin.File)",
      "",
      "Title: $($Pin.Title)",
      "",
      "Description: $($Pin.Description)",
      "",
      "Media URL after publishing: $MediaUrl",
      "",
      "Tracked destination URL: $TrackedUrl",
      "",
      "Scheduled publish date: $PublishDate UTC",
      "",
      "Keywords: $($Article.Keywords)"
    )
    $Index += 1
    $ScheduleOffset += 1
  }

  Set-Content -Path (Join-Path $ArticleDir "pinterest-copy.md") -Value ($CopyLines -join "`r`n") -Encoding UTF8
  Set-Content -Path (Join-Path $ArticleDir "pinterest-bulk-upload.csv") -Value ($ArticleCsvRows -join "`r`n") -Encoding UTF8

  $Video = @"
# Short Video Script - $($Article.Slug)

Length: 20-30 seconds
Format: 9:16 vertical
Destination: Pinterest video pin, YouTube Shorts, TikTok

Hook:
$($Article.VideoHook)

Beat 1:
Show the renter problem in one sentence.

Beat 2:
Show the 3-part kit logic from the Pin bullets.

Beat 3:
Show one fast "what to skip" warning.

Close:
Full renter-friendly checklist on Apartment Survival Kits.

On-screen disclosure:
#ad - page contains Amazon affiliate links.
"@
  Set-Content -Path (Join-Path $ArticleDir "short-video-script.md") -Value $Video -Encoding UTF8

  $Fiverr = @"
# Fiverr Brief - $($Article.Slug)

Create one 20-30 second vertical video, 1080x1920, using the script in short-video-script.md.

Style:
- Clean apartment/renter aesthetic.
- Large readable text.
- Calm practical pacing, not flashy.
- Use the colors from the included Pin PNGs.
- No fake prices, ratings, discounts, or Amazon logos.

Deliverables:
- 1 MP4 vertical video.
- 1 editable project file if possible.
- 1 thumbnail frame.

Required text:
- Apartment Survival Kits
- #ad
- Full checklist: $($Article.Url)
"@
  Set-Content -Path (Join-Path $ArticleDir "fiverr-brief.md") -Value $Fiverr -Encoding UTF8

  $Reddit = @"
# Reddit Angle - $($Article.Slug)

Use manually only where it is genuinely relevant. Do not drop links as the first move.

Helpful no-link reply angle:
$($Article.VideoHook)

Suggested approach:
1. Answer the person's specific problem.
2. Mention the 3-part checklist in plain text.
3. Link only if the subreddit allows it or the person asks.

Disclosure if linking:
I made a full checklist; it contains affiliate links.
"@
  Set-Content -Path (Join-Path $ArticleDir "reddit-angle.md") -Value $Reddit -Encoding UTF8
}

Set-Content -Path (Join-Path $PromoRoot "pinterest-bulk-upload.csv") -Value ($CsvRows -join "`r`n") -Encoding UTF8

Write-Host "Built promo assets for $($Articles.Count) articles into promo/"
