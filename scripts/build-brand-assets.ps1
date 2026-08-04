Add-Type -AssemblyName System.Drawing

$ErrorActionPreference = "Stop"

$Root = Resolve-Path (Join-Path $PSScriptRoot "..")
$BrandRoot = Join-Path $Root "assets\brand"

function New-Dir($Path) {
  if (-not (Test-Path $Path)) {
    New-Item -ItemType Directory -Path $Path | Out-Null
  }
}

function New-Brush($Hex) {
  $Color = [System.Drawing.ColorTranslator]::FromHtml($Hex)
  New-Object System.Drawing.SolidBrush($Color)
}

function New-Pen($Hex, $Width) {
  $Color = [System.Drawing.ColorTranslator]::FromHtml($Hex)
  New-Object System.Drawing.Pen($Color, $Width)
}

function Draw-CenteredText($Graphics, $Text, $Font, $Brush, $Rect) {
  $Format = New-Object System.Drawing.StringFormat
  $Format.Alignment = [System.Drawing.StringAlignment]::Center
  $Format.LineAlignment = [System.Drawing.StringAlignment]::Center
  $Graphics.DrawString($Text, $Font, $Brush, $Rect, $Format)
  $Format.Dispose()
}

function Save-ProfileImage($Path) {
  $Size = 800
  $Bitmap = New-Object System.Drawing.Bitmap($Size, $Size)
  $Graphics = [System.Drawing.Graphics]::FromImage($Bitmap)
  $Graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $Graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

  $Olive = New-Brush "#40543f"
  $Cream = New-Brush "#fbfaf6"
  $Terracotta = New-Brush "#d87558"
  $Ink = New-Brush "#20231f"
  $Muted = New-Brush "#62685f"
  $Gold = New-Brush "#efb857"

  $Graphics.FillRectangle($Olive, 0, 0, $Size, $Size)
  $Graphics.FillEllipse($Cream, 92, 92, 616, 616)
  $Graphics.FillEllipse($Terracotta, 340, 78, 120, 120)
  $Graphics.FillEllipse($Gold, 570, 470, 72, 72)
  $Graphics.FillEllipse($Terracotta, 178, 510, 54, 54)

  $BigFont = New-Object System.Drawing.Font("Segoe UI", 178, [System.Drawing.FontStyle]::Bold)
  $SmallFont = New-Object System.Drawing.Font("Segoe UI", 34, [System.Drawing.FontStyle]::Bold)
  $TinyFont = New-Object System.Drawing.Font("Segoe UI", 24, [System.Drawing.FontStyle]::Regular)

  Draw-CenteredText $Graphics "ASK" $BigFont $Ink (New-Object System.Drawing.RectangleF(100, 210, 600, 230))
  Draw-CenteredText $Graphics "APARTMENT" $SmallFont $Terracotta (New-Object System.Drawing.RectangleF(100, 455, 600, 55))
  Draw-CenteredText $Graphics "SURVIVAL KITS" $TinyFont $Muted (New-Object System.Drawing.RectangleF(100, 510, 600, 48))

  $Bitmap.Save($Path, [System.Drawing.Imaging.ImageFormat]::Png)

  $BigFont.Dispose()
  $SmallFont.Dispose()
  $TinyFont.Dispose()
  $Olive.Dispose()
  $Cream.Dispose()
  $Terracotta.Dispose()
  $Ink.Dispose()
  $Muted.Dispose()
  $Gold.Dispose()
  $Graphics.Dispose()
  $Bitmap.Dispose()
}

function Save-FaviconPng($Path, $Size) {
  $Bitmap = New-Object System.Drawing.Bitmap($Size, $Size)
  $Graphics = [System.Drawing.Graphics]::FromImage($Bitmap)
  $Graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $Graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

  $Olive = New-Brush "#40543f"
  $Cream = New-Brush "#fbfaf6"
  $Terracotta = New-Brush "#d87558"
  $Outline = New-Pen "#fbfaf6" ([Math]::Max(2, [int]($Size * 0.045)))

  $Graphics.FillRectangle($Olive, 0, 0, $Size, $Size)
  $Padding = [int]($Size * 0.13)
  $Graphics.FillEllipse($Cream, $Padding, $Padding, $Size - ($Padding * 2), $Size - ($Padding * 2))
  $Graphics.DrawEllipse($Outline, $Padding, $Padding, $Size - ($Padding * 2), $Size - ($Padding * 2))

  $FontSize = [Math]::Max(10, [int]($Size * 0.55))
  $Font = New-Object System.Drawing.Font("Segoe UI", $FontSize, [System.Drawing.FontStyle]::Bold)
  Draw-CenteredText $Graphics "A" $Font $Terracotta (New-Object System.Drawing.RectangleF(0, -($Size * 0.03), $Size, $Size))

  $Bitmap.Save($Path, [System.Drawing.Imaging.ImageFormat]::Png)

  $Font.Dispose()
  $Olive.Dispose()
  $Cream.Dispose()
  $Terracotta.Dispose()
  $Outline.Dispose()
  $Graphics.Dispose()
  $Bitmap.Dispose()
}

New-Dir $BrandRoot

Save-ProfileImage (Join-Path $BrandRoot "pinterest-profile.png")
Save-FaviconPng (Join-Path $BrandRoot "favicon-512.png") 512
Save-FaviconPng (Join-Path $BrandRoot "favicon-192.png") 192
Save-FaviconPng (Join-Path $BrandRoot "favicon-32.png") 32

Write-Host "Built brand assets into assets/brand/"
