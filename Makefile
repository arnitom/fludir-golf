# Einfaldar skipanir fyrir bókina. Allt verkið er í bok.py, svo það sama
# virkar án make:  python bok.py view | render | push
#
#   make install  Setja upp allt sem þarf (einu sinni á nýrri tölvu)
#   make view     Skoða bókina í vafra
#   make          Minnka myndir og smíða vefinn
#   make push     Minnka myndir, athuga smíði, vista og senda á GitHub

PYTHON ?= python

.PHONY: render install view push

render:
	$(PYTHON) bok.py render

install:
	$(PYTHON) bok.py install

view:
	$(PYTHON) bok.py view

push:
	$(PYTHON) bok.py push
