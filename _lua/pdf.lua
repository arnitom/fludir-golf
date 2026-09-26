-- Lætur vefstillingar virka líka í PDF-útgáfunni.
-- ::: {.text-end} ... :::  (hægrijafnað á vef) verður hægrijafnað í PDF.

function Div(div)
  if div.classes:includes("text-end") and quarto.doc.is_format("pdf") then
    local blokkir = pandoc.Blocks({ pandoc.RawBlock("latex", [[\begin{flushright}]]) })
    blokkir:extend(div.content)
    blokkir:insert(pandoc.RawBlock("latex", [[\end{flushright}]]))
    return blokkir
  end
end
