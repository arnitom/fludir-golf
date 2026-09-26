# Saga Golfklúbbsins á Flúðum

Bókin er skrifuð í [Quarto](https://quarto.org) og birtist sjálfkrafa á
**https://tungufoss.github.io/fludir-golf/** í hvert sinn sem breyting er sett á `main`.

## Uppbygging

```
_quarto.yml        Stillingar: titill, höfundur og röð kafla
index.qmd          Formáli (fyrsta síðan)
kaflar/            Einn skjal fyrir hvern kafla
myndir/            Allar myndir
```

## Hvernig bæti ég við efni?

- **Breyta kafla:** opnaðu skjal í `kaflar/` og skrifaðu. Hægt er að gera það beint á GitHub (blýantstáknið).
- **Nýr kafli:** búðu til nýtt skjal í `kaflar/`, t.d. `06-nyr-kafli.qmd`, og bættu því í listann `chapters` í `_quarto.yml`.
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
quarto preview
```
