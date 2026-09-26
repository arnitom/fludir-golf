# Saga Selsvallar

Bókin er skrifuð í [Quarto](https://quarto.org) og birtist sjálfkrafa á
**https://arnitom.github.io/fludir-golf/** í hvert sinn sem breyting er sett á `main`.

- **Höfundur texta:** Árni Tómasson
- **Tæknileg uppsetning:** Helga Ingimundardóttir ([@tungufoss](https://github.com/tungufoss))

## Uppsetning á nýrri tölvu (Windows)

**1. Sæktu og settu upp þessi fjögur forrit:**

- [Git](https://git-scm.com/install/windows)
- [Quarto](https://quarto.org/docs/download/)
- [VS Code](https://apps.microsoft.com/detail/xp9khm4bk9fz7q) (Microsoft Store)
- [Python](https://apps.microsoft.com/detail/9pnrbtzxmb4z) (Microsoft Store)

**2. Endurræstu tölvuna.**

**3. Opnaðu VS Code** og settu upp viðbótina **Quarto** (Extensions, vinstra megin).

**4. Opnaðu skipanalínu í VS Code** (Terminal > New Terminal) og keyrðu:

```
git clone https://github.com/arnitom/fludir-golf.git
cd fludir-golf
pip install -r requirements.txt
quarto preview --to html
```

Bókin opnast í vafra. Í fyrsta sinn sem þú sendir breytingar á GitHub biður Git þig að skrá þig inn í vafra.

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
```

## Hvernig bæti ég við efni?

- **Breyta kafla:** opnaðu skjal í `kaflar/` og skrifaðu. Hægt er að gera það beint á GitHub (blýantstáknið).
- **Nýr kafli:** búðu til nýtt skjal í `kaflar/`, t.d. `07-nyr-kafli.qmd`, og bættu því í listann `chapters` í `_quarto.yml`.
  Efst í skjalið fer titill vafraflipans: `pagetitle: "Saga Selsvallar | Heiti kaflans"` (milli `---` lína, sjá hina kaflana).
- **Mynd:** settu myndina í `myndir/` og vísaðu í hana svona: `![Myndatexti](../myndir/mynd.jpg)`

## Myndir: minnka áður en þær eru vistaðar

Allar myndir eru minnkaðar á sama hátt svo vefurinn verði hraður (mest 1600 px, um 200–400 KB).
Settu nýjar myndir í `myndir/` og keyrðu **áður en þú vistar (commit)**:

```
python minnka-myndir.py
```

Fyrst þarf einu sinni að setja upp Pillow: `pip install -r requirements.txt`. Geymdu frumritin í fullri upplausn annars staðar, ekki í þessari möppu.

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

## Skoða bókina á eigin tölvu

```
quarto preview --to html
```

## PDF-útgáfa

Bókin er líka smíðuð sem PDF, og lesendur geta sótt hana með hnappi efst í valmyndinni.
PDF-ið er alltaf búið til úr sömu `.qmd`-skrám og vefurinn, svo það þarf ekki að viðhalda því sérstaklega.
Til að smíða bæði vef og PDF á eigin tölvu þarf LaTeX einu sinni: `quarto install tinytex`, svo `quarto render`.
