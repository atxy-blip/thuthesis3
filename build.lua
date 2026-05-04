#!/usr/bin/env texlua

-- Build script for thuthesis3.
-- run with `l3build`

module        = "thuthesis3"

checkengines  = {"xetex"}
checkopts     = "-interaction=batchmode"
lvtext        = ".tex"

checkconfigs = {
  "build",
  "testfiles/config-title-page",
--   "testfiles/config-title-page-en",
--   "testfiles/config-crossref",
--   "testfiles/config-nomencl",
--   "testfiles/config-bibtex",
--   "testfiles/config-biblatex",
}

textfiles     = {"LICENSE", "README*.md", "CHANGELOG.md", "*.ins"}
ctanreadme    = "README-CTAN.md"

thunamefile    = "tsinghua-name-bachelor.pdf"

sourcefiledir = "source"
sourcefiles   = {"*.dtx", thunamefile}
installfiles  = {"*.cls", "*.def", thunamefile}

binaryfiles   = {thunamefile}

typesetexe    = "xelatex"
typesetfiles  = {"thuthesis3.dtx"}

unpackexe     = "xetex"
unpackfiles   = {"thuthesis3.dtx"}
