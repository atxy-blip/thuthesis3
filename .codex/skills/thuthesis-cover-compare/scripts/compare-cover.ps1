param(
  [Parameter(Mandatory = $true)]
  [string]$Fixture,

  [string]$Thuthesis2eRoot = "C:\Users\admin\Documents\Source\thuthesis2e",
  [string]$Thuthesis3Root = "C:\Users\admin\Documents\Source\thuthesis3",
  [string]$OutRoot = "",
  [int]$FirstWords = 0,
  [switch]$NoInstall
)

$ErrorActionPreference = "Stop"

function Invoke-Checked {
  param(
    [Parameter(Mandatory = $true)][scriptblock]$Command,
    [Parameter(Mandatory = $true)][string]$Label
  )

  & $Command
  if ($LASTEXITCODE -ne 0) {
    throw "$Label failed with exit code $LASTEXITCODE"
  }
}

function Invoke-XeLaTeX {
  param(
    [Parameter(Mandatory = $true)][string]$TexFile,
    [Parameter(Mandatory = $true)][string]$WorkDir,
    [Parameter(Mandatory = $true)][string]$TexInputs,
    [Parameter(Mandatory = $true)][string]$Label
  )

  New-Item -ItemType Directory -Force -Path $WorkDir | Out-Null
  Push-Location $WorkDir
  try {
    $env:TEXINPUTS = $TexInputs
    Invoke-Checked -Label $Label -Command {
      & xelatex -interaction=batchmode -halt-on-error $TexFile
    }
  }
  finally {
    Pop-Location
  }
}

function Invoke-PdfLaTeX {
  param(
    [Parameter(Mandatory = $true)][string]$TexFile,
    [Parameter(Mandatory = $true)][string]$WorkDir,
    [Parameter(Mandatory = $true)][string]$TexInputs,
    [Parameter(Mandatory = $true)][string]$Label
  )

  New-Item -ItemType Directory -Force -Path $WorkDir | Out-Null
  Push-Location $WorkDir
  try {
    $env:TEXINPUTS = $TexInputs
    Invoke-Checked -Label $Label -Command {
      & pdflatex -interaction=batchmode -halt-on-error $TexFile
    }
  }
  finally {
    Pop-Location
  }
}

$fixtureTex = [System.IO.Path]::GetFileName($Fixture)
if (-not $fixtureTex.EndsWith(".tex", [System.StringComparison]::OrdinalIgnoreCase)) {
  $fixtureTex = "$fixtureTex.tex"
}
$fixtureName = [System.IO.Path]::GetFileNameWithoutExtension($fixtureTex)

$fixture2e = Join-Path $Thuthesis2eRoot "testfiles\01-title-page\$fixtureTex"
$fixture3 = Join-Path $Thuthesis3Root "testfiles\01-title-page\$fixtureTex"

if (-not (Test-Path -LiteralPath $fixture2e)) {
  throw "Oracle fixture not found: $fixture2e"
}
if (-not (Test-Path -LiteralPath $fixture3)) {
  throw "thuthesis3 fixture not found: $fixture3"
}

if ([string]::IsNullOrWhiteSpace($OutRoot)) {
  $OutRoot = Join-Path $Thuthesis3Root ".llmdoc-tmp\cover-compare\$fixtureName"
}
elseif (-not [System.IO.Path]::IsPathRooted($OutRoot)) {
  $OutRoot = [System.IO.Path]::GetFullPath((Join-Path (Get-Location) $OutRoot))
}

$out2e = Join-Path $OutRoot "2e"
$out3 = Join-Path $OutRoot "thuthesis3"
New-Item -ItemType Directory -Force -Path $out2e, $out3 | Out-Null

if (-not $NoInstall) {
  Push-Location $Thuthesis3Root
  try {
    Invoke-Checked -Label "l3build install" -Command { & l3build install }
  }
  finally {
    Pop-Location
  }
}

$texinputs2e = ".;$Thuthesis2eRoot;$Thuthesis2eRoot\testfiles\01-title-page;$Thuthesis2eRoot\testfiles\01-title-page\support;"
$texinputs3 = ".;$Thuthesis3Root\build\local;$Thuthesis3Root\testfiles\01-title-page;$Thuthesis3Root\testfiles\01-title-page\support;"

Invoke-XeLaTeX -TexFile $fixture2e -WorkDir $out2e -TexInputs $texinputs2e -Label "xelatex thuthesis2e fixture"
Invoke-XeLaTeX -TexFile $fixture3 -WorkDir $out3 -TexInputs $texinputs3 -Label "xelatex thuthesis3 fixture"

$pdf2e = Join-Path $out2e "$fixtureName.pdf"
$pdf3 = Join-Path $out3 "$fixtureName.pdf"
if (-not (Test-Path -LiteralPath $pdf2e)) {
  throw "Expected oracle PDF not found: $pdf2e"
}
if (-not (Test-Path -LiteralPath $pdf3)) {
  throw "Expected thuthesis3 PDF not found: $pdf3"
}

$compTex = Join-Path $OutRoot "comp.tex"
$compPdf = Join-Path $OutRoot "comp.pdf"
$overlayPdf2e = Join-Path $OutRoot "oracle.pdf"
$overlayPdf3 = Join-Path $OutRoot "actual.pdf"
Copy-Item -LiteralPath $pdf2e -Destination $overlayPdf2e -Force
Copy-Item -LiteralPath $pdf3 -Destination $overlayPdf3 -Force
$compContent = @"
\documentclass{article}
\usepackage{pdfpagediff}
\begin{document}
\layerPages{actual.pdf}{oracle.pdf}
\end{document}
"@
Set-Content -LiteralPath $compTex -Value $compContent -Encoding UTF8

Invoke-PdfLaTeX -TexFile $compTex -WorkDir $OutRoot -TexInputs ".;" -Label "pdflatex pdfpagediff overlay"

$bbox2e = Join-Path $OutRoot "bbox-2e.html"
$bbox3 = Join-Path $OutRoot "bbox-thuthesis3.html"
Invoke-Checked -Label "pdftotext bbox thuthesis2e" -Command { & pdftotext -bbox $pdf2e $bbox2e }
Invoke-Checked -Label "pdftotext bbox thuthesis3" -Command { & pdftotext -bbox $pdf3 $bbox3 }

$words2e = Select-String -Path $bbox2e -Pattern "<word " | ForEach-Object { $_.Line }
$words3 = Select-String -Path $bbox3 -Pattern "<word " | ForEach-Object { $_.Line }
if ($FirstWords -gt 0) {
  $words2e = $words2e | Select-Object -First $FirstWords
  $words3 = $words3 | Select-Object -First $FirstWords
}
$diff = Compare-Object -ReferenceObject $words2e -DifferenceObject $words3
$diffPath = Join-Path $OutRoot "bbox-diff.txt"

if ($diff) {
  $diff | Out-File -LiteralPath $diffPath -Encoding UTF8
  Write-Host "BBOX_DIFF"
  if ($FirstWords -gt 0) {
    Write-Host "Compared first $FirstWords text elements."
  }
  Write-Host "Output: $OutRoot"
  Write-Host "Overlay: $compPdf"
  Write-Host "Diff: $diffPath"
  exit 2
}

$matchText = if ($FirstWords -gt 0) { "BBOX_MATCH first $FirstWords text elements" } else { "BBOX_MATCH all text elements" }
$matchText | Set-Content -LiteralPath $diffPath -Encoding UTF8
Write-Host "BBOX_MATCH"
if ($FirstWords -gt 0) {
  Write-Host "Compared first $FirstWords text elements."
}
Write-Host "Output: $OutRoot"
Write-Host "Overlay: $compPdf"
Write-Host "Diff: $diffPath"
