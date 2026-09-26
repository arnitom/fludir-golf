-- Setur inn töflu úr CSV-skrá, t.d. {{< csv-tafla gogn/kaupendur.csv >}}
-- Slóðin er miðuð við rót verkefnisins. Fyrsta línan er fyrirsögn töflunnar.
-- Skilur bæði kommu og semíkommu (Excel á íslensku notar semíkommu).

local function lesa_linu(lina, skil)
  local reitir, reitur, i, innan = {}, "", 1, false
  while i <= #lina do
    local c = lina:sub(i, i)
    if innan then
      if c == '"' and lina:sub(i + 1, i + 1) == '"' then
        reitur = reitur .. '"'
        i = i + 1
      elseif c == '"' then
        innan = false
      else
        reitur = reitur .. c
      end
    elseif c == '"' then
      innan = true
    elseif c == skil then
      table.insert(reitir, reitur)
      reitur = ""
    else
      reitur = reitur .. c
    end
    i = i + 1
  end
  table.insert(reitir, reitur)
  return reitir
end

local function reitur(texti)
  return { pandoc.Plain({ pandoc.Str(texti) }) }
end

return {
  ["csv-tafla"] = function(args)
    local slod = pandoc.utils.stringify(args[1])
    local skra = io.open(pandoc.path.join({ quarto.project.directory, slod }), "rb")
    if not skra then
      error("Fann ekki CSV-skrána: " .. slod)
    end
    local texti = skra:read("a")
    skra:close()

    if not utf8.len(texti) then
      error(slod .. " er ekki vistuð sem UTF-8. Í Excel: Vista sem > 'CSV UTF-8'.")
    end
    texti = texti:gsub("^\239\187\191", ""):gsub("\r\n?", "\n")

    local linur = {}
    for lina in texti:gmatch("[^\n]+") do
      if lina:match("%S") then
        table.insert(linur, lina)
      end
    end
    if #linur < 2 then
      return pandoc.Para({ pandoc.Emph({ pandoc.Str("Upplýsingar koma hér.") }) })
    end

    local _, semikommur = linur[1]:gsub(";", "")
    local _, kommur = linur[1]:gsub(",", "")
    local skil = semikommur > kommur and ";" or ","

    local haus, stilling, breidd = {}, {}, {}
    for _, nafn in ipairs(lesa_linu(linur[1], skil)) do
      table.insert(haus, reitur(nafn))
      table.insert(stilling, pandoc.AlignDefault)
      table.insert(breidd, 0)
    end

    local radir = {}
    for n = 2, #linur do
      local rod = {}
      for _, gildi in ipairs(lesa_linu(linur[n], skil)) do
        table.insert(rod, reitur(gildi))
      end
      table.insert(radir, rod)
    end

    return pandoc.utils.from_simple_table(
      pandoc.SimpleTable({}, stilling, breidd, haus, radir))
  end,
}
