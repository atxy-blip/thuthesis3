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

excludetests = {"info-anonymous-compat"}

textfiles     = {"LICENSE", "README*.md", "CHANGELOG.md", "*.ins"}
ctanreadme    = "README-CTAN.md"

thulogofiles  = {"thu-fig-logo.pdf", "thu-text-logo.pdf"}

sourcefiledir = "source"
sourcefiles   = {"*.dtx", table.unpack(thulogofiles)}
installfiles  = {"*.cls", "*.def", table.unpack(thulogofiles)}

binaryfiles   = {table.unpack(thulogofiles)}

typesetexe    = "xelatex"
typesetfiles  = {"thuthesis3.dtx"}

unpackexe     = "xetex"
unpackfiles   = {"thuthesis3.dtx"}

-- Custom target: save all tests for all configs
target_list["save-all"] = {
  func = function()
    local saved_testfiledir  = testfiledir
    local saved_testsuppdir  = testsuppdir
    local saved_includetests = includetests
    local saved_excludetests = excludetests
    for _, config in ipairs(checkconfigs) do
      if config ~= "build" then
        local configname = config .. ".lua"
        if fileexists(configname) then
          dofile(configname)
        end
      end
      -- Discover test files (same logic as l3build's check function)
      local names = {}
      for _, kind in ipairs(test_order) do
        local ext = test_types[kind].test
        local excludepatterns = {}
        local num_exclude = 0
        for _, glob in ipairs(excludetests) do
          num_exclude = num_exclude + 1
          excludepatterns[num_exclude] = glob_to_pattern(glob .. ext)
        end
        for _, glob in ipairs(includetests) do
          for _, name in ipairs(filelist(testfiledir, glob .. ext)) do
            local exclude = false
            for i = 1, num_exclude do
              if string.match(name, excludepatterns[i]) then
                exclude = true
                break
              end
            end
            if not exclude then
              table.insert(names, string.sub(name, 1, -#ext - 1))
            end
          end
        end
      end
      table.sort(names)
      if #names > 0 then
        print("")
        print("Saving " .. #names .. " test(s) for config: " .. config)
        local ok = save(names)
        if ok ~= 0 then
          return ok
        end
      end
      -- Restore defaults for next config
      testfiledir   = saved_testfiledir
      testsuppdir   = saved_testsuppdir
      includetests  = saved_includetests
      excludetests  = saved_excludetests
    end
    return 0
  end
}
