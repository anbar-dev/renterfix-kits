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

function Get-PinKey($Slug, $PinFile) {
  $Content = ($PinFile -replace '\.png$', '') -replace '[^a-zA-Z0-9_-]', '-'
  return "$Slug/$Content"
}

function Get-LedgerMap($Path) {
  $Map = @{}
  if (Test-Path $Path) {
    Import-Csv -Path $Path | ForEach-Object {
      if ($_.pin_key) {
        $Map[$_.pin_key] = $_
      }
    }
  }
  return $Map
}

function New-PinterestCsvRow($Title, $MediaUrl, $Board, $Description, $DestinationUrl, $PublishDate, $Keywords) {
  return ((Escape-Csv $Title), (Escape-Csv $MediaUrl), (Escape-Csv $Board), "", (Escape-Csv $Description), (Escape-Csv $DestinationUrl), (Escape-Csv $PublishDate), (Escape-Csv $Keywords) -join ",")
}

function New-LedgerCsvRow($PinKey, $ArticleSlug, $PinFile, $Title, $Board, $MediaUrl, $DestinationUrl, $PublishDate, $Status, $PinterestUrl, $Notes) {
  return ((Escape-Csv $PinKey), (Escape-Csv $ArticleSlug), (Escape-Csv $PinFile), (Escape-Csv $Title), (Escape-Csv $Board), (Escape-Csv $MediaUrl), (Escape-Csv $DestinationUrl), (Escape-Csv $PublishDate), (Escape-Csv $Status), (Escape-Csv $PinterestUrl), (Escape-Csv $Notes) -join ",")
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
    Slug = "cable-management"
    Category = "No-Drill"
    Board = "No-Drill Apartment Ideas"
    Url = "$BaseUrl/kits/no-drill/cable-management/"
    Keywords = "cable management renters, hide cords apartment, no drill cable management, renter friendly cable raceway, apartment cord organization"
    VideoHook = "Cable mess in a rental? Route the cord first, then choose the lightest holder that keeps it out of the walkway."
    Pins = @(
      [pscustomobject]@{
        File = "pin-01.png"
        Title = "Cable Management for Renters"
        Subtitle = "A no-drill setup for desks, TVs, lamps, and chargers without turning your walls into a project."
        Bullets = @("Route before sticking", "Use light clips", "Test hidden surfaces")
        Description = "Cable management for renters: no-drill raceways, adhesive clips, routing ideas, and what can damage apartment walls. This page contains Amazon affiliate links. #ad"
        Bg = "#40543f"; Panel = "#fbfaf6"; Ink = "#20231f"; Muted = "#62685f"; Accent = "#d87558"
      },
      [pscustomobject]@{
        File = "pin-02.png"
        Title = "Hide Cords Without Drilling"
        Subtitle = "Use existing furniture routes first, then add a short channel or clip only where the cable needs support."
        Bullets = @("No wall holes", "Measure first", "Keep cables accessible")
        Description = "How to hide cords in an apartment without drilling, with renter-friendly cable raceways, clips, and risk notes. #ad"
        Bg = "#d87558"; Panel = "#fbfaf6"; Ink = "#20231f"; Muted = "#62685f"; Accent = "#466a86"
      },
      [pscustomobject]@{
        File = "pin-03.png"
        Title = "Do Not Stick a Raceway Everywhere"
        Subtitle = "Adhesive cable management can still pull paint, so choose the smallest fix and test the surface first."
        Bullets = @("Skip textured walls", "Avoid heavy bundles", "Plan move-out removal")
        Description = "Renter-friendly cable management checklist: what to buy, what to skip, and how to reduce deposit risk. #ad"
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
  },
  [pscustomobject]@{
    Slug = "minimum-kitchen-kit"
    Category = "Kitchen"
    Board = "First Apartment Essentials"
    Url = "$BaseUrl/kits/kitchen/minimum-kitchen-kit/"
    Keywords = "minimum kitchen essentials, first apartment kitchen, apartment kitchen basics, small kitchen starter kit, renter kitchen checklist"
    VideoHook = "First apartment kitchen? You do not need a full registry. You need the boring minimum kit first."
    Pins = @(
      [pscustomobject]@{
        File = "pin-01.png"
        Title = "First Apartment Kitchen Minimum Kit"
        Subtitle = "Buy the few things that let you cook, reheat, clean, and store food before buying nice extras."
        Bullets = @("Cook one real meal", "Clean up fast", "Skip duplicate gadgets")
        Description = "A minimum kitchen essentials checklist for first apartment renters who want useful basics before extra gadgets. This page contains Amazon affiliate links. #ad"
        Bg = "#7d947c"; Panel = "#fbfaf6"; Ink = "#20231f"; Muted = "#62685f"; Accent = "#d87558"
      },
      [pscustomobject]@{
        File = "pin-02.png"
        Title = "Do Not Overbuy Your First Kitchen"
        Subtitle = "Start with one pan, one pot, a knife, a board, basic utensils, and a cleanup system."
        Bullets = @("Small-space friendly", "Beginner renter basics", "Useful from day one")
        Description = "What kitchen items you actually need for a first apartment, with a simple minimum kit and skip notes. #ad"
        Bg = "#466a86"; Panel = "#fbfaf6"; Ink = "#20231f"; Muted = "#62685f"; Accent = "#efb857"
      },
      [pscustomobject]@{
        File = "pin-03.png"
        Title = "Kitchen Basics If You Barely Cook"
        Subtitle = "Enough to make breakfast, simple dinners, leftovers, and emergency meals without filling every cabinet."
        Bullets = @("Fewer pieces", "Less wasted money", "Easy to move out")
        Description = "Minimal first apartment kitchen essentials for renters who barely cook but still need a functional kitchen. #ad"
        Bg = "#d87558"; Panel = "#fbfaf6"; Ink = "#20231f"; Muted = "#62685f"; Accent = "#40543f"
      }
    )
  },
  [pscustomobject]@{
    Slug = "first-apartment-cleaning-kit"
    Category = "Cleaning"
    Board = "Apartment Cleaning Checklists"
    Url = "$BaseUrl/kits/cleaning/first-apartment-cleaning-kit/"
    Keywords = "first apartment cleaning supplies, move in cleaning kit, apartment cleaning checklist, renter cleaning supplies, basic cleaning kit"
    VideoHook = "Before you unpack everything, make the apartment clean enough to touch."
    Pins = @(
      [pscustomobject]@{
        File = "pin-01.png"
        Title = "First Apartment Cleaning Kit"
        Subtitle = "The move-in cleaning basics to buy before boxes, furniture, and cabinet clutter get in the way."
        Bullets = @("Clean surfaces first", "Bathroom before unpacking", "Skip specialty clutter")
        Description = "First apartment cleaning supplies checklist for move-in day, basic resets, and renter-friendly cleaning priorities. This page contains Amazon affiliate links. #ad"
        Bg = "#40543f"; Panel = "#fbfaf6"; Ink = "#20231f"; Muted = "#62685f"; Accent = "#efb857"
      },
      [pscustomobject]@{
        File = "pin-02.png"
        Title = "Move-In Cleaning Supplies Checklist"
        Subtitle = "A practical starter kit for counters, bathroom grime, floors, trash, gloves, and paper towels."
        Bullets = @("Before you unpack", "Small apartment basics", "No huge product shelf")
        Description = "Move-in cleaning supplies for apartment renters: simple products to clean the place before settling in. #ad"
        Bg = "#efb857"; Panel = "#fbfaf6"; Ink = "#20231f"; Muted = "#62685f"; Accent = "#466a86"
      },
      [pscustomobject]@{
        File = "pin-03.png"
        Title = "Clean Before You Set Up"
        Subtitle = "If you wait until after furniture arrives, the annoying corners become much harder to reach."
        Bullets = @("Gloves and scrubbers", "Trash bags ready", "Bathroom first")
        Description = "Basic cleaning kit for a first apartment, with move-in priorities and what not to overbuy. #ad"
        Bg = "#466a86"; Panel = "#fbfaf6"; Ink = "#20231f"; Muted = "#62685f"; Accent = "#d87558"
      }
    )
  },
  [pscustomobject]@{
    Slug = "move-out-cleaning-kit"
    Category = "Move-Out"
    Board = "Apartment Cleaning Checklists"
    Url = "$BaseUrl/kits/move-out/cleaning-kit/"
    Keywords = "move out cleaning supplies apartment, apartment move out checklist, get security deposit back, renter cleaning kit"
    VideoHook = "Moving out? Document the apartment first, then clean the high-visibility areas in the right order."
    Pins = @(
      [pscustomobject]@{
        File = "pin-01.png"
        Title = "Move-Out Cleaning Kit"
        Subtitle = "The focused apartment cleaning checklist for the final week of a rental, without buying a whole janitor closet."
        Bullets = @("Document first", "Kitchen and bath", "Floors last")
        Description = "Move-out cleaning supplies apartment renters can use for the final clean, with deposit-aware priorities and what to skip. This page contains Amazon affiliate links. #ad"
        Bg = "#40543f"; Panel = "#fbfaf6"; Ink = "#20231f"; Muted = "#62685f"; Accent = "#efb857"
      },
      [pscustomobject]@{
        File = "pin-02.png"
        Title = "Apartment Move-Out Cleaning Checklist"
        Subtitle = "Clean empty cabinets, appliances, bathroom fixtures, closets, and floors before the final key handoff."
        Bullets = @("Photos before cleaning", "Targeted products", "No harsh overkill")
        Description = "Apartment move-out cleaning checklist for renters who want to clean thoroughly without creating new wall, floor, or fixture damage. #ad"
        Bg = "#d87558"; Panel = "#fbfaf6"; Ink = "#20231f"; Muted = "#62685f"; Accent = "#466a86"
      },
      [pscustomobject]@{
        File = "pin-03.png"
        Title = "Clean Before You Hand Over the Keys"
        Subtitle = "A simple final-clean sequence that keeps documentation, kitchen grime, bathroom buildup, and floors in order."
        Bullets = @("Check the lease", "Skip normal wear", "Leave it empty")
        Description = "What to clean before moving out of an apartment, including product priorities, final inspection notes, and deposit-aware skip advice. #ad"
        Bg = "#466a86"; Panel = "#fbfaf6"; Ink = "#20231f"; Muted = "#62685f"; Accent = "#d87558"
      }
    )
  },
  [pscustomobject]@{
    Slug = "basic-tool-kit"
    Category = "Move-In"
    Board = "First Apartment Essentials"
    Url = "$BaseUrl/kits/move-in/basic-tool-kit/"
    Keywords = "basic tool kit apartment, tools every renter needs, first apartment tools, renter tool kit, move in tools"
    VideoHook = "A renter tool kit is not a garage. It is the small set that saves you from borrowing everything."
    Pins = @(
      [pscustomobject]@{
        File = "pin-01.png"
        Title = "Basic Tool Kit for Apartment Renters"
        Subtitle = "The small set of tools that handles assembly, hanging, tightening, measuring, and move-in fixes."
        Bullets = @("No garage needed", "Handles flat-pack furniture", "Useful on moving day")
        Description = "Basic tool kit checklist for apartment renters and first apartment move-in tasks. This page contains Amazon affiliate links. #ad"
        Bg = "#d87558"; Panel = "#fbfaf6"; Ink = "#20231f"; Muted = "#62685f"; Accent = "#40543f"
      },
      [pscustomobject]@{
        File = "pin-02.png"
        Title = "Tools Every Renter Actually Needs"
        Subtitle = "Start with a screwdriver set, tape measure, level, utility knife, pliers, and a few simple helpers."
        Bullets = @("Assembly basics", "Damage-aware fixes", "Easy to store")
        Description = "Tools every renter needs for an apartment, without buying a bulky homeowner kit. #ad"
        Bg = "#40543f"; Panel = "#fbfaf6"; Ink = "#20231f"; Muted = "#62685f"; Accent = "#efb857"
      },
      [pscustomobject]@{
        File = "pin-03.png"
        Title = "Do Not Move In Without These Tools"
        Subtitle = "Boxes, furniture, curtains, labels, batteries, and loose screws all show up in the first week."
        Bullets = @("Tape measure first", "Utility knife ready", "Small toolkit only")
        Description = "First apartment tools checklist for renters who need the basics without overbuying. #ad"
        Bg = "#466a86"; Panel = "#fbfaf6"; Ink = "#20231f"; Muted = "#62685f"; Accent = "#d87558"
      }
    )
  },
  [pscustomobject]@{
    Slug = "no-drill-curtains"
    Category = "No-Drill"
    Board = "No-Drill Apartment Ideas"
    Url = "$BaseUrl/kits/no-drill/no-drill-curtains/"
    Keywords = "no drill curtains, renter curtains, hang curtains without holes, apartment curtains no drilling, tension rod curtains"
    VideoHook = "Need curtains in a rental? Start with the window type, not the prettiest curtain rod."
    Pins = @(
      [pscustomobject]@{
        File = "pin-01.png"
        Title = "No-Drill Curtains for Renters"
        Subtitle = "Choose tension, twist-and-fit, magnetic, or adhesive options based on the window and deposit risk."
        Bullets = @("No holes", "Measure first", "Deposit-aware")
        Description = "How to hang curtains in a rental without holes, with no-drill curtain options and what to skip. This page contains Amazon affiliate links. #ad"
        Bg = "#466a86"; Panel = "#fbfaf6"; Ink = "#20231f"; Muted = "#62685f"; Accent = "#efb857"
      },
      [pscustomobject]@{
        File = "pin-02.png"
        Title = "Hang Curtains Without Drilling"
        Subtitle = "A renter-friendly curtain kit for privacy, sleep, and ugly blinds without permanent hardware."
        Bullets = @("Tension rod options", "Temporary privacy", "No wall anchors")
        Description = "No-drill curtain ideas for apartments, including tension rods and renter-safe window cover options. #ad"
        Bg = "#7d947c"; Panel = "#fbfaf6"; Ink = "#20231f"; Muted = "#62685f"; Accent = "#d87558"
      },
      [pscustomobject]@{
        File = "pin-03.png"
        Title = "Rental Curtains Without Losing Deposit"
        Subtitle = "The safest setup depends on surface, window depth, curtain weight, and move-out cleanup."
        Bullets = @("Avoid heavy rods", "Test adhesive carefully", "Keep hardware light")
        Description = "Renter-friendly curtain setup checklist for apartments where drilling is not allowed. #ad"
        Bg = "#efb857"; Panel = "#fbfaf6"; Ink = "#20231f"; Muted = "#62685f"; Accent = "#40543f"
      }
    )
  },
  [pscustomobject]@{
    Slug = "entryway-no-closet"
    Category = "Small Space"
    Board = "Small Apartment Storage"
    Url = "$BaseUrl/kits/small-space/entryway-no-closet/"
    Keywords = "apartment entryway no closet, small entryway storage, no closet entryway, renter friendly entryway, apartment shoe storage"
    VideoHook = "No entry closet? Your front door needs a landing zone, not a pile."
    Pins = @(
      [pscustomobject]@{
        File = "pin-01.png"
        Title = "Entryway With No Closet?"
        Subtitle = "Create a tiny landing zone for shoes, keys, bags, coats, mail, and daily clutter."
        Bullets = @("Shoes contained", "Keys visible", "No drilling needed")
        Description = "Apartment entryway no closet kit with renter-friendly storage ideas for shoes, coats, keys, and bags. This page contains Amazon affiliate links. #ad"
        Bg = "#40543f"; Panel = "#fbfaf6"; Ink = "#20231f"; Muted = "#62685f"; Accent = "#d87558"
      },
      [pscustomobject]@{
        File = "pin-02.png"
        Title = "Small Apartment Entryway Fix"
        Subtitle = "A compact setup for renters who walk into the living room and have nowhere to drop daily stuff."
        Bullets = @("Narrow storage", "Freestanding hooks", "Less floor clutter")
        Description = "Small apartment entryway storage ideas for rentals without an entry closet or mudroom. #ad"
        Bg = "#d87558"; Panel = "#fbfaf6"; Ink = "#20231f"; Muted = "#62685f"; Accent = "#466a86"
      },
      [pscustomobject]@{
        File = "pin-03.png"
        Title = "Stop the Doorway Pile"
        Subtitle = "Give every daily item a home within arm's reach before the entry becomes a mess."
        Bullets = @("Landing tray", "Shoe zone", "Bag hook alternative")
        Description = "No-closet entryway storage kit for renters who need a cleaner apartment entrance. #ad"
        Bg = "#466a86"; Panel = "#fbfaf6"; Ink = "#20231f"; Muted = "#62685f"; Accent = "#efb857"
      }
    )
  },
  [pscustomobject]@{
    Slug = "closet-smell-dampness"
    Category = "Daily Fix"
    Board = "Renter-Friendly Fixes"
    Url = "$BaseUrl/kits/daily-fixes/closet-smell-dampness/"
    Keywords = "musty closet smell, damp closet apartment, closet odor renter, apartment humidity, closet moisture absorber"
    VideoHook = "A musty closet usually needs airflow, moisture control, and a boring cleanup before fragrance."
    Pins = @(
      [pscustomobject]@{
        File = "pin-01.png"
        Title = "Closet Smells Musty?"
        Subtitle = "Start with moisture control and airflow before trying to cover the smell with scent."
        Bullets = @("Find damp zones", "Add airflow", "Skip heavy fragrance")
        Description = "Closet smell and dampness kit for apartment renters dealing with musty closets and moisture. This page contains Amazon affiliate links. #ad"
        Bg = "#7d947c"; Panel = "#fbfaf6"; Ink = "#20231f"; Muted = "#62685f"; Accent = "#466a86"
      },
      [pscustomobject]@{
        File = "pin-02.png"
        Title = "Damp Closet in an Apartment"
        Subtitle = "A renter-safe kit for moisture absorbers, odor checks, airflow, and storage changes."
        Bullets = @("Moisture first", "Air gaps matter", "Protect clothes")
        Description = "How to fix a damp closet in a rental apartment with simple moisture and airflow basics. #ad"
        Bg = "#466a86"; Panel = "#fbfaf6"; Ink = "#20231f"; Muted = "#62685f"; Accent = "#d87558"
      },
      [pscustomobject]@{
        File = "pin-03.png"
        Title = "Do Not Just Add Scent"
        Subtitle = "If the closet is damp, fragrance can hide the problem while clothes keep absorbing the smell."
        Bullets = @("Check humidity", "Separate fabrics", "Clean then absorb")
        Description = "Musty closet smell checklist for renters: what to buy, what to skip, and how to reduce dampness. #ad"
        Bg = "#efb857"; Panel = "#fbfaf6"; Ink = "#20231f"; Muted = "#62685f"; Accent = "#40543f"
      }
    )
  }
)

New-Dir $PromoRoot

$CsvHeader = "Title,Media URL,Pinterest board,Thumbnail,Description,Link,Publish date,Keywords"
$LedgerHeader = "pin_key,article_slug,pin_file,title,board,media_url,destination_url,publish_date,status,pinterest_url,notes"
$LedgerPath = Join-Path $PromoRoot "PINTEREST_LEDGER.csv"
$ExistingLedger = Get-LedgerMap $LedgerPath
$SeedUploadedPins = @(
  "dark-apartment-lighting/pin-01",
  "dark-apartment-lighting/pin-02",
  "dark-apartment-lighting/pin-03",
  "no-pantry-organization/pin-01",
  "no-pantry-organization/pin-02",
  "no-pantry-organization/pin-03",
  "open-first-box/pin-01",
  "open-first-box/pin-02",
  "open-first-box/pin-03"
)

$AllCsvRows = New-Object System.Collections.Generic.List[string]
$NextCsvRows = New-Object System.Collections.Generic.List[string]
$NowCsvRows = New-Object System.Collections.Generic.List[string]
$ScheduledCsvRows = New-Object System.Collections.Generic.List[string]
$LedgerRows = New-Object System.Collections.Generic.List[string]
$AllCsvRows.Add($CsvHeader)
$NextCsvRows.Add($CsvHeader)
$NowCsvRows.Add($CsvHeader)
$ScheduledCsvRows.Add($CsvHeader)
$LedgerRows.Add($LedgerHeader)
$ScheduleStart = (Get-Date).ToUniversalTime().Date.AddDays(1).AddHours(15)
$ScheduleOffset = 0
$NextUploadCount = 0
$ImmediateUploadLimit = 9
$ScheduledUploadOffset = 0
$LatestKnownPublishDate = $null

foreach ($Entry in $ExistingLedger.Values) {
  if (@("uploaded", "published") -contains $Entry.status -and $Entry.publish_date) {
    try {
      $ParsedPublishDate = [datetime]::Parse($Entry.publish_date, [Globalization.CultureInfo]::InvariantCulture)
      if (-not $LatestKnownPublishDate -or $ParsedPublishDate -gt $LatestKnownPublishDate) {
        $LatestKnownPublishDate = $ParsedPublishDate
      }
    } catch {
      # Ignore malformed legacy dates and fall back to the seed schedule.
    }
  }
}

if (-not $LatestKnownPublishDate) {
  $LatestKnownPublishDate = $ScheduleStart.AddDays($SeedUploadedPins.Count - 1)
}

$ScheduledBatchStart = $LatestKnownPublishDate.Date.AddDays(1).AddHours($LatestKnownPublishDate.Hour).AddMinutes($LatestKnownPublishDate.Minute)

foreach ($Article in $Articles) {
  $ArticleDir = Join-Path $PromoRoot $Article.Slug
  $PinsDir = Join-Path $ArticleDir "pins"
  New-Dir $ArticleDir
  New-Dir $PinsDir
  $ArticleAllCsvRows = New-Object System.Collections.Generic.List[string]
  $ArticleNextCsvRows = New-Object System.Collections.Generic.List[string]
  $ArticleAllCsvRows.Add($CsvHeader)
  $ArticleNextCsvRows.Add($CsvHeader)

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
    $PinKey = Get-PinKey $Article.Slug $Pin.File
    $MediaUrl = "$BaseUrl/promo/$($Article.Slug)/pins/$($Pin.File)"
    $TrackedUrl = Add-TrackingUrl $Article.Url $Article.Slug $Pin.File
    $Existing = $ExistingLedger[$PinKey]
    $PublishDate = ""
    $Status = "ready"
    $PinterestUrl = ""
    $Notes = ""

    if ($Existing) {
      $PublishDate = $Existing.publish_date
      $Status = $Existing.status
      $PinterestUrl = $Existing.pinterest_url
      $Notes = $Existing.notes
    } elseif ($SeedUploadedPins -contains $PinKey) {
      $PublishDate = $ScheduleStart.AddDays($ScheduleOffset).ToString("yyyy-MM-ddTHH:mm:ss", [Globalization.CultureInfo]::InvariantCulture)
      $Status = "uploaded"
      $Notes = "Confirmed uploaded in the first Pinterest bulk import."
    }

    $ShouldExportNext = @("ready", "exported", "error") -contains $Status
    if ($ShouldExportNext) {
      $Status = "exported"
      $ExportPublishDate = ""
      if ($NextUploadCount -ge $ImmediateUploadLimit) {
        $ExportPublishDate = $ScheduledBatchStart.AddDays($ScheduledUploadOffset).ToString("yyyy-MM-ddTHH:mm:ss", [Globalization.CultureInfo]::InvariantCulture)
        $ScheduledUploadOffset += 1
      }
      $PublishDate = $ExportPublishDate
      if ($ExportPublishDate) {
        $Notes = "Included in pinterest-upload-scheduled.csv and pinterest-upload-next.csv; set status to uploaded after successful import."
      } else {
        $Notes = "Included in pinterest-upload-now.csv and pinterest-upload-next.csv; set status to uploaded after successful import."
      }
      $NextCsvRow = New-PinterestCsvRow $Pin.Title $MediaUrl $Article.Board $Pin.Description $TrackedUrl $ExportPublishDate $Article.Keywords
      $NextCsvRows.Add($NextCsvRow)
      $ArticleNextCsvRows.Add($NextCsvRow)
      if ($ExportPublishDate) {
        $ScheduledCsvRows.Add($NextCsvRow)
      } else {
        $NowCsvRows.Add($NextCsvRow)
      }
      $NextUploadCount += 1
    }

    $CsvRow = New-PinterestCsvRow $Pin.Title $MediaUrl $Article.Board $Pin.Description $TrackedUrl $PublishDate $Article.Keywords
    $AllCsvRows.Add($CsvRow)
    $ArticleAllCsvRows.Add($CsvRow)
    $LedgerRows.Add((New-LedgerCsvRow $PinKey $Article.Slug $Pin.File $Pin.Title $Article.Board $MediaUrl $TrackedUrl $PublishDate $Status $PinterestUrl $Notes))
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
  Set-Content -Path (Join-Path $ArticleDir "pinterest-bulk-upload.csv") -Value ($ArticleAllCsvRows -join "`r`n") -Encoding UTF8
  Set-Content -Path (Join-Path $ArticleDir "pinterest-upload-next.csv") -Value ($ArticleNextCsvRows -join "`r`n") -Encoding UTF8

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

Set-Content -Path (Join-Path $PromoRoot "pinterest-bulk-upload.csv") -Value ($AllCsvRows -join "`r`n") -Encoding UTF8
Set-Content -Path (Join-Path $PromoRoot "pinterest-upload-next.csv") -Value ($NextCsvRows -join "`r`n") -Encoding UTF8
Set-Content -Path (Join-Path $PromoRoot "pinterest-upload-now.csv") -Value ($NowCsvRows -join "`r`n") -Encoding UTF8
Set-Content -Path (Join-Path $PromoRoot "pinterest-upload-scheduled.csv") -Value ($ScheduledCsvRows -join "`r`n") -Encoding UTF8
Set-Content -Path $LedgerPath -Value ($LedgerRows -join "`r`n") -Encoding UTF8

Write-Host "Built promo assets for $($Articles.Count) articles into promo/ ($NextUploadCount rows in pinterest-upload-next.csv)"
