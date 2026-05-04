#!/usr/bin/env texlua

-- Build script for thuthesis3.
-- run with `l3build`

module        = "thuthesis3"

checkengines  = {"xetex", "luatex"}
checkopts     = "-interaction=batchmode"
lvtext        = ".tex"

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
