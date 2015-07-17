LATEX = lualatex
PKG = directory-tree

all: ${PKG}.sty ${PKG}.pdf

%.sty: %.ins %.dtx
	${LATEX} $<

%.pdf: %.dtx %.sty
	${LATEX} $<
	makeindex -s gglo.ist -o $*.gls $*.glo
	makeindex -s gind.ist -o $*.ind $*.idx
	${LATEX} $<
