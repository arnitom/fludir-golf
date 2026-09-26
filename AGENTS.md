# Leiðbeiningar fyrir gervigreind (AI-aðstoðarmenn)

Þetta skjal segir aðstoðarmönnum eins og Claude hvernig á að vinna í þessu verkefni.
Það er skrifað á íslensku svo eigandinn geti lesið það og breytt því sjálfur.

## Um verkefnið

Bók um sögu Golfklúbbsins Flúða (GF), skrifuð í [Quarto](https://quarto.org).
Höfundur er **Árni Tómasson**. Bókin birtist á GitHub Pages þegar breytingar fara á `main` á GitHub.

## Samskipti við notandann

- Notandinn er **ekki mjög tæknilegur**. Útskýrðu á einföldu, skýru máli og forðastu tæknihugtök.
  Ef tæknihugtak er nauðsynlegt, útskýrðu það í stuttu máli.
- Svaraðu á **íslensku** nema notandinn skrifi á öðru máli.
- Segðu alltaf í lokin **hvað var gert** og **hvort notandinn þurfi að gera eitthvað**.
- Spyrðu áður en þú gerir eitthvað sem erfitt er að afturkalla.
- Skráðu atriði sem notandinn þarf að **taka ákvörðun um** í `TODO.md` í rót verkefnisins
  (einfalt mál, gátreitir `- [ ]`). Sú skrá er hunsuð í git og fer ekki á vefinn.
  **Taktu atriði út úr skránni um leið og það hefur verið afgreitt.**

## Git og commit

- **Commit-skilaboð eru alltaf á íslensku** og lýsandi:
  - Fyrsta lína: stutt fyrirsögn sem segir hvað var gert, t.d. `Bæta við kafla um mótin`.
  - Síðan auð lína og nokkrar setningar um **hvað** breyttist og **af hverju**.
- Gerðu commit eftir hvert afmarkað verk, ekki allt í einum hrærigraut.
- **Aldrei `git push` nema notandinn biðji um það.** Push á `main` birtir vefinn opinberlega.
- Ekki setja þetta í git: `.odt` handrit, `_book/`, `.quarto/`, `.idea/`.

## Uppbygging

```
_quarto.yml          Titill, höfundur og röð kafla (listinn `chapters`)
index.qmd            Formáli
kaflar/NN-heiti.qmd  Einn kafli í hverju skjali
vidaukar/heiti.qmd   Viðaukar (listinn `appendices` í `_quarto.yml`)
gogn/heiti.csv       Töflur sem uppfærast reglulega og langir listar
_lua/csv-tafla.lua   Les CSV-skrá inn sem töflu: {{< csv-tafla gogn/heiti.csv >}}
myndir/              Myndir (minnkaðar, sjá að neðan)
minnka-myndir.py     Minnkar myndir
requirements.txt     Python-pakkar (bara Pillow)
```

Nýr kafli þarf líka að fara í listann `chapters` í `_quarto.yml`.

**Viðaukar:** listar, töflur og nafnaskrár eiga heima í viðaukum, ekki í köflunum,
svo kaflarnir haldist hreinir. Á vef eru engar blaðsíður, svo í stað „sjá viðauka á bls. 36“
er tengill á rétta síðu: `[viðauka](../vidaukar/stjorn.qmd)`.

**Töflur (ákvörðun eiganda):** litlar töflur eru skrifaðar beint í `.qmd`. CSV í `gogn/` er
aðeins notað þegar ljóst er að taflan verði uppfærð reglulega (t.d. á hverju ári) eða hún er stór
(t.d. 165 nöfn). CSV-skrár eru UTF-8 með semíkommu sem skilum, eins og Excel á íslensku.
Ekki bæta R eða Python við birtinguna fyrir töflur; `_lua/csv-tafla.lua` sér um það.

## Texti höfundar

- Ekki breyta orðalagi höfundar nema beðið sé um það. Leiðréttingar á augljósum
  innsláttarvillum eru í lagi ef notandinn samþykkir.
- Staðir merktir `xx` eða `Xx` eru óklárir í handritinu. Láttu þá vera en bentu á þá.
- **Kennitölur einstaklinga eru aldrei birtar** í bókinni og mega aldrei fara í git-söguna
  (ákvörðun eiganda). Kennitölur félaga, t.d. Kaffi-Sels ehf., eru í lagi.
  Vektu líka athygli á símanúmerum, heimilisföngum o.þ.h. áður en þau fara á vefinn,
  því hann er opinn öllum.

## Myndir

- Allar myndir eru minnkaðar eins: mest 1600 px, JPEG gæði 80, GPS og önnur lýsigögn fjarlægð.
- Keyrðu `python minnka-myndir.py` **áður en** myndir fara í commit.
  Uppsetning í fyrsta sinn: `pip install -r requirements.txt`.
- Frumrit í fullri upplausn eru geymd annars staðar, ekki í git.
- Mynd í texta: `![Myndatexti](../myndir/heiti.jpg)`

## Forskoða bókina

- Keyrðu `quarto preview --port 4200 --no-browser`. Bókin er þá á http://localhost:4200/
- Athugaðu fyrst hvort þjónn sé þegar í gangi og stöðvaðu hann ef svo er.
- Ekki stöðva þjóninn í miðri keyrslu, það getur skemmt skyndiminni Quarto.
- **Stöðvaðu þjóninn áður en mörgum skrám er breytt í einu** (t.d. með skriftu) og ræstu hann
  aftur á eftir. Annars reynir hann að smíða margar síður samtímis og skyndiminnið skemmist.
- Ef breyting sést ekki í forskoðun (ritillinn vistar stundum í gegnum WSL og þjónninn
  tekur ekki eftir því): endurræstu þjóninn.
- Villan **„Bad resource ID“** þýðir skemmt skyndiminni: stöðvaðu þjóninn, eyddu
  `.quarto/`, `_book/` og `%LOCALAPPDATA%\quarto\sass` og ræstu hann aftur.
