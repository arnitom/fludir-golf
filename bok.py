"""Einfaldar skipanir fyrir bókina (líka hægt að nota make, sjá Makefile).

  python bok.py install  Setja upp allt sem þarf (einu sinni á nýrri tölvu)
  python bok.py view     Skoða bókina í vafra; uppfærist þegar skrár eru vistaðar
  python bok.py render   Minnka myndir og smíða vefinn í _book/
  python bok.py push     Minnka myndir, athuga að bókin smíðist, vista (commit)
                         og senda á GitHub
"""
import pathlib
import shutil
import subprocess
import sys

ROT = pathlib.Path(__file__).resolve().parent
EFNI = ["index.qmd", "kaflar", "vidaukar", "myndir", "gogn"]  # það sem push vistar
ORD = {"A": "Ný", "M": "Breytt", "D": "Eytt", "R": "Fært"}

for rás in (sys.stdout, sys.stderr):
    rás.reconfigure(encoding="utf-8", errors="replace")


def keyra(*skipun, athuga=True, ut=False):
    print("\n>", " ".join(skipun), flush=True)
    nidurstada = subprocess.run(skipun, cwd=ROT, text=True, encoding="utf-8",
                                capture_output=ut)
    if athuga and nidurstada.returncode != 0:
        sys.exit(f"\nSkipunin mistókst: {' '.join(skipun)}")
    return nidurstada


def install():
    keyra(sys.executable, "-m", "pip", "install", "-q", "-r", "requirements.txt")

    tol = keyra("quarto", "list", "tools", athuga=False, ut=True).stdout
    tinytex = next((l for l in tol.splitlines() if l.strip().startswith("tinytex")), "")
    if "Not installed" in tinytex or not tinytex:
        keyra("quarto", "install", "tinytex", "--no-prompt")
    else:
        print("\nTinyTeX (fyrir PDF) er þegar uppsett.")

    code = shutil.which("code")
    if code:
        for vidbot in ("quarto.quarto", "editorconfig.editorconfig"):
            keyra(code, "--install-extension", vidbot, athuga=False)
    else:
        print("\nVS Code fannst ekki; settu upp viðbótina Quarto handvirkt.")

    for stilling, spurning in (("user.name", "Nafnið þitt (t.d. Árni Tómasson): "),
                               ("user.email", "Netfangið þitt: ")):
        if not keyra("git", "config", stilling, athuga=False, ut=True).stdout.strip():
            gildi = input(spurning).strip()
            if gildi:
                keyra("git", "config", "--global", stilling, gildi)

    print("\nAllt tilbúið. Skoðaðu bókina með:  python bok.py view   (eða make view)")


def minnka():
    keyra(sys.executable, "minnka-myndir.py")


def render():
    minnka()
    keyra("quarto", "render", "--to", "html")
    print("\nBókin er tilbúin í _book/.")


def view():
    keyra("quarto", "preview", "--to", "html", athuga=False)


def push():
    minnka()
    if keyra("quarto", "render", "--to", "html", athuga=False).returncode != 0:
        sys.exit("\nBókin smíðast ekki og ekkert var sent. "
                 "Lagaðu villuna hér að ofan og reyndu aftur.")

    keyra("git", "add", "--", *EFNI)
    breytt = keyra("git", "diff", "--cached", "--name-status", ut=True).stdout.split("\n")
    breytt = [lina.split("\t") for lina in breytt if lina.strip()]
    if breytt:
        nafn = keyra("git", "config", "user.name", athuga=False, ut=True).stdout.strip()
        listi = "\n".join(f"- {ORD.get(l[0][0], l[0])}: {l[-1]}" for l in breytt)
        keyra("git", "commit", "-q", "-m",
              f"Sjálfvirkt commit frá {nafn or 'óþekktum'}\n\nBreyttar skrár:\n{listi}")
    else:
        print("\nEngar nýjar breytingar á texta, myndum eða gögnum.")

    if keyra("git", "pull", "--rebase", "--autostash", athuga=False).returncode != 0:
        sys.exit("\nÞínar breytingar rekast á breytingar sem aðrir hafa sent. Ekkert var sent.\n"
                 "Hafðu samband við Helgu (eða spurðu Claude) til að leysa úr þessu.")
    keyra("git", "push")

    annad = keyra("git", "status", "--porcelain", ut=True).stdout.strip()
    if annad:
        print("\nAthugið: þessar skrár breyttust en voru ekki sendar "
              "(aðeins texti, myndir og gögn eru send sjálfkrafa):\n" + annad)
    print("\nSent á GitHub. Vefurinn uppfærist eftir nokkrar mínútur.")


SKIPANIR = {"install": install, "view": view, "render": render, "push": push}

if __name__ == "__main__":
    if len(sys.argv) != 2 or sys.argv[1] not in SKIPANIR:
        sys.exit(__doc__)
    SKIPANIR[sys.argv[1]]()
