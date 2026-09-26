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

## Skoða bókina á eigin tölvu

```
quarto preview
```
