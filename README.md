# Saga Selsvallar

Bókin er skrifuð í [Quarto](https://quarto.org) og birtist sjálfkrafa á
**https://arnitom.github.io/fludir-golf/** í hvert sinn sem breyting er sett á `main`.

- **Höfundur texta:** Árni Tómasson ([@arnitom](https://github.com/arnitom))
- **Tæknileg uppsetning:** Helga Ingimundardóttir ([@tungufoss](https://github.com/tungufoss))

## Uppsetning á nýrri tölvu (Windows)

**1. Settu upp forritin.** Opnaðu **PowerShell** (Start > skrifa „PowerShell“) og límdu inn:

```
winget install -e --id Git.Git; winget install -e --id Posit.Quarto; winget install -e --id Microsoft.VisualStudioCode; winget install -e --id Python.Python.3.13
```

Eða sæktu þau hvert fyrir sig:
[Git](https://git-scm.com/install/windows) ·
[Quarto](https://quarto.org/docs/download/) ·
[VS Code](https://apps.microsoft.com/detail/xp9khm4bk9fz7q) ·
[Python](https://apps.microsoft.com/detail/9pnrbtzxmb4z)

**2. Endurræstu tölvuna.**

**3. Opnaðu VS Code**, svo skipanalínu (Terminal > New Terminal), og keyrðu:

```
git clone https://github.com/arnitom/fludir-golf.git
cd fludir-golf
python bok.py install
```

`install` setur upp allt annað sem þarf (Python-pakka, LaTeX fyrir PDF og viðbætur í VS Code)
og spyr um nafn og netfang ef þarf. Opnaðu svo möppuna `fludir-golf` í VS Code (File > Open Folder).

## Daglegar skipanir

Keyrðu þær í skipanalínunni í VS Code, í möppunni `fludir-golf`:

| Skipun | Hvað gerist |
|--------|-------------|
| `python bok.py view` | Bókin opnast í vafra og uppfærist þegar þú vistar skrá |
| `python bok.py push` | Minnkar myndir, athugar að bókin smíðist, vistar og sendir á GitHub. Vefurinn uppfærist eftir nokkrar mínútur. |
| `python bok.py render` | Minnkar myndir og smíðar vefinn í `_book/` (án þess að senda) |

`push` sendir texta (`.qmd`), myndir og CSV-gögn. Ef bókin smíðast ekki er ekkert sent.
Í fyrsta sinn sem þú sendir biður Git þig að skrá þig inn á GitHub í vafra.

Þetta verkefni notar aðeins Python-skipanirnar hér að ofan. `make` er ekki nauðsynlegt og er ekki notað í verkefninu.

## Uppbygging

```
_quarto.yml        Stillingar: titill, höfundur og röð kafla og viðauka
index.qmd          Formáli (fyrsta síðan)
kaflar/            Eitt skjal fyrir hvern kafla
vidaukar/          Eitt skjal fyrir hvern viðauka
gogn/              CSV-töflur sem uppfærast reglulega
myndir/            Allar myndir; merki klúbbsins í myndir/merki/
gf.scss            Litir og letur (útlit vefsins)
_lua/              Lítil forrit sem lesa CSV-töflur o.fl. (þarf sjaldan að snerta)
bok.py             Daglegu skipanirnar (install, view, render, push)
```

## Hvernig bæti ég við efni?

- **Breyta kafla:** opnaðu skjal í `kaflar/` og skrifaðu. Hægt er að gera það beint á GitHub (blýantstáknið).
- **Nýr kafli:** búðu til nýtt skjal í `kaflar/`, t.d. `07-nyr-kafli.qmd`, og bættu því í listann `chapters` í `_quarto.yml`.
  Efst í skjalið fer titill vafraflipans: `pagetitle: "Saga Selsvallar | Heiti kaflans"` (milli `---` lína, sjá hina kaflana).
- **Mynd eða tafla:** sjá Markdown-yfirlitið hér fyrir neðan.

## Markdown: stutt yfirlit

Kaflarnir eru skrifaðir í Markdown: venjulegur texti með nokkrum táknum fyrir útlit.
Mundu: **auð lína á milli málsgreina.** Ein lína niður (Enter einu sinni) sameinar línurnar í eina málsgrein.

**Texti**

```
## Fyrirsögn
### Undirfyrirsögn

**feitletrað**  og  *skáletrað*

- punktur í lista
1. númeraður liður

> Tilvitnun, t.d. úr bréfi eða samningi.

[texti tengils](https://www.gsi.is)
[viðauka](../vidaukar/stjorn.qmd)        ← tengill á aðra síðu í bókinni
```

**Myndir** (minnkaðu þær fyrst, sjá næsta kafla)

```
![Myndatexti sem birtist undir myndinni.](../myndir/heiti.jpg)

![Minni mynd, 60% af breiddinni.](../myndir/heiti.jpg){width="60%"}
```

`../` þýðir „einni möppu ofar“, því kaflarnir eru í `kaflar/` en myndirnar í `myndir/`.

**Litlar töflur** (sem breytast sjaldan)

```
| Ár   | Nafn              |
|------|-------------------|
| 2024 | Jón Jónsson       |
| 2025 | Anna Sigurðardóttir |
```

Línurnar þurfa ekki að standast nákvæmlega á. Stórar töflur eða töflur sem uppfærast
á hverju ári fara í CSV-skrá (sjá kaflann um CSV hér fyrir neðan).

**Hægrijafnaður texti**, t.d. undirskrift

```
::: {.text-end}
Árni Tómasson, september 2026
:::
```

## Myndir eru minnkaðar sjálfkrafa

Settu nýjar myndir í `myndir/`. `python bok.py push` (og `render`) minnkar þær allar á sama hátt
svo vefurinn verði hraður: mest 1600 px, um 200–400 KB. Geymdu frumritin í fullri upplausn
annars staðar, því minnkaða myndin kemur í stað frumritsins í möppunni.

## Töflur sem uppfærast reglulega (CSV)

Töflur sem stækka á hverju ári, og langir listar, eru geymdar sem CSV-skrár í möppunni `gogn/`:

| Skrá | Hvar í bókinni |
|------|----------------|
| `gogn/timalina.csv` | Tímalína (gagnvirkt graf og tafla) |
| `gogn/klubbmeistarar.csv` | Viðauki um umferð, mót og klúbbmeistara |
| `gogn/fjarfestingar.csv` | Viðauki um ársreikninga og fjárfestingar |
| `gogn/kaupendur.csv` | Viðauki um þá sem lögðu fé í kaup á Selsvelli |

**Svona uppfærir þú töflu:** opnaðu CSV-skrána í Excel, bættu við línu og vistaðu með
**Vista sem > „CSV UTF-8“** (annars skemmast íslensku stafirnir). Fyrsta línan er fyrirsögn töflunnar.
Einnig er hægt að breyta skránni beint á GitHub.

**Tímalínan** hefur þrjá dálka: `Ár;Flokkur;Atburður`. Flokkarnir eru **Félagið**, **Völlurinn**
og **Samningar** og hver þeirra hefur sinn lit í grafinu. Notaðu bara þessa þrjá flokka.

Í texta er CSV-tafla sett inn svona: `{{< csv-tafla gogn/heiti.csv >}}`

Litlar töflur sem breytast sjaldan eru skrifaðar beint í textann.

## PDF-útgáfa

Bókin er líka smíðuð sem PDF, og lesendur geta sótt hana með hnappi efst í valmyndinni.
PDF-ið er alltaf búið til úr sömu `.qmd`-skrám og vefurinn, svo það þarf ekki að viðhalda því sérstaklega.
Til að smíða líka PDF á eigin tölvu: `quarto render` (LaTeX er sett upp með `python bok.py install`).
