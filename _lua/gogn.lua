-- Les CSV-skrár úr gogn/ inn í bókina. Slóðir eru miðaðar við rót verkefnisins
-- og fyrsta línan er fyrirsögn. Skilur bæði kommu og semíkommu (Excel á íslensku).
--
--   {{< csv-tafla gogn/kaupendur.csv >}}   tafla
--   {{< timalina gogn/timalina.csv >}}     gagnvirk tímalína (dálkar: Ár;Flokkur;Atburður)

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

-- Skilar fyrirsögn og röðum CSV-skrár.
local function lesa_csv(args)
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
  if #linur == 0 then
    return {}, {}
  end

  local _, semikommur = linur[1]:gsub(";", "")
  local _, kommur = linur[1]:gsub(",", "")
  local skil = semikommur > kommur and ";" or ","

  local radir = {}
  for n = 2, #linur do
    table.insert(radir, lesa_linu(linur[n], skil))
  end
  return lesa_linu(linur[1], skil), radir
end

local function tomt()
  return pandoc.Para({ pandoc.Emph({ pandoc.Str("Upplýsingar koma hér.") }) })
end

local function reitur(texti)
  return { pandoc.Plain({ pandoc.Str(texti) }) }
end

local TIMALINA_HTML = [[
<p class="timalina-hjalp"><small>Farðu með músina yfir punkt til að sjá hvað gerðist.
Dragðu endana á stikunni fyrir neðan til að skoða styttra tímabil.</small></p>
<div id="timalina-graf" class="timalina-graf" role="img"
     aria-label="Gagnvirk tímalína. Sama efni er í töflunni fyrir neðan."></div>
<script src="https://cdn.jsdelivr.net/npm/plotly.js-basic-dist-min@2.35.2/plotly-basic.min.js"></script>
<script>
(function () {
  // Ef Plotly hleðst ekki (t.d. án nets) stendur taflan fyrir neðan ein eftir.
  if (typeof Plotly === "undefined") {
    document.querySelectorAll(".timalina-graf, .timalina-hjalp").forEach(e => e.remove());
    return;
  }
  const atburdir = GOGN;
  // Litir úr prófaðri litapallettu; fylgja flokki (í röð fyrstu komu), aldrei röðun.
  const litir = ["#2a78d6", "#eb6834", "#1baf7a"];
  const flokkar = [...new Set(atburdir.map(a => a.flokkur))];

  // Atburðir sama árs raðast hver ofan á annan.
  const hvert_ar = {};
  atburdir.forEach(a => { a.h = hvert_ar[a.ar] = (hvert_ar[a.ar] ?? -1) + 1; });
  const haesta = Math.max(0, ...atburdir.map(a => a.h));

  const hreinsa = s => s.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
  const brjota = s => s.replace(/(.{1,42})(\s+|$)/g, "$1<br>").replace(/<br>$/, "");

  const stil = getComputedStyle(document.body);
  const ferlar = flokkar.map((flokkur, i) => {
    const hans = atburdir.filter(a => a.flokkur === flokkur);
    return {
      type: "scatter", mode: "markers", name: flokkur,
      x: hans.map(a => a.ar), y: hans.map(a => a.h),
      customdata: hans.map(a => brjota(hreinsa(a.texti))),
      marker: { size: 13, color: litir[i % litir.length], line: { width: 2, color: "#ffffff" } },
      hovertemplate: "<b>%{x}</b> · " + hreinsa(flokkur) + "<br>%{customdata}<extra></extra>",
      hoverlabel: { bgcolor: "#ffffff", bordercolor: litir[i % litir.length],
                    font: { color: "#0b0b0b", family: stil.fontFamily, size: 13 } },
    };
  });

  const arin = atburdir.map(a => a.ar);
  Plotly.newPlot("timalina-graf", ferlar, {
    height: 300,
    margin: { l: 10, r: 10, t: 10, b: 40 },
    font: { family: stil.fontFamily, color: "#52514e", size: 13 },
    paper_bgcolor: "rgba(0,0,0,0)", plot_bgcolor: "rgba(0,0,0,0)",
    showlegend: flokkar.length > 1,
    legend: { orientation: "h", x: 0, y: 1.12, font: { color: "#0b0b0b" } },
    hovermode: "closest", hoverdistance: 24, dragmode: false,
    xaxis: {
      range: [Math.min(...arin) - 2, Math.max(...arin) + 2],
      tickformat: "d", dtick: 5, showgrid: true, gridcolor: "#ecebe8", zeroline: false,
      showline: true, linecolor: "#c9c8c2",
      rangeslider: { visible: true, thickness: 0.1, bgcolor: "#f5f5f3", bordercolor: "#c9c8c2" },
    },
    yaxis: { visible: false, fixedrange: true, range: [-0.8, haesta + 0.8] },
  }, { responsive: true, displayModeBar: false });
})();
</script>
]]

return {
  ["csv-tafla"] = function(args)
    local haus, radir = lesa_csv(args)
    if #radir == 0 then
      return tomt()
    end
    local haus_reitir, stilling, breidd = {}, {}, {}
    for _, nafn in ipairs(haus) do
      table.insert(haus_reitir, reitur(nafn))
      table.insert(stilling, pandoc.AlignDefault)
      table.insert(breidd, 0)
    end
    local rod_reitir = {}
    for _, rod in ipairs(radir) do
      local r = {}
      for _, gildi in ipairs(rod) do
        table.insert(r, reitur(gildi))
      end
      table.insert(rod_reitir, r)
    end
    return pandoc.utils.from_simple_table(
      pandoc.SimpleTable({}, stilling, breidd, haus_reitir, rod_reitir))
  end,

  ["timalina"] = function(args)
    local _, radir = lesa_csv(args)
    local atburdir = {}
    for _, rod in ipairs(radir) do
      local ar = tonumber(rod[1])
      if ar then
        table.insert(atburdir, { ar = ar, flokkur = rod[2] or "", texti = rod[3] or "" })
      end
    end
    if #atburdir == 0 then
      return tomt()
    end
    local gogn = pandoc.json.encode(atburdir):gsub("</", "<\\/")
    return pandoc.RawBlock("html", (TIMALINA_HTML:gsub("GOGN", function() return gogn end)))
  end,
}
