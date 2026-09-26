"""Minnkar myndir í myndir/ svo vefurinn verði hraður.

Keyrsla:  python minnka-myndir.py

- Lengsta hlið verður mest 1600 px (JPEG gæði 80).
- Myndum er snúið rétt (símamyndir) og lýsigögn (m.a. GPS-staðsetning) fjarlægð.
- Myndir sem eru þegar nógu litlar eru ekki snertar, svo óhætt er að keyra oft.
"""
import pathlib
from PIL import Image, ImageOps

HAMARK = 1600
GAEDI = 80
MAPPA = pathlib.Path(__file__).parent / "myndir"

for skra in sorted(MAPPA.iterdir()):
    if skra.suffix.lower() not in {".jpg", ".jpeg", ".png"}:
        continue
    with Image.open(skra) as mynd:
        if max(mynd.size) <= HAMARK:
            continue
        adur = skra.stat().st_size
        mynd = ImageOps.exif_transpose(mynd)
        mynd.thumbnail((HAMARK, HAMARK), Image.LANCZOS)
        if skra.suffix.lower() == ".png":
            mynd.save(skra, optimize=True)
        else:
            mynd.convert("RGB").save(skra, quality=GAEDI, optimize=True, progressive=True)
    print(f"{skra.name}: {adur // 1024} KB -> {skra.stat().st_size // 1024} KB")
