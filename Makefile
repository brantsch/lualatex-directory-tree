LATEX = lualatex
PKG = directory-tree

all: ${PKG}.sty ${PKG}.pdf

%.sty: %.ins %.dtx
	${LATEX} $<

%.pdf: %.dtx %.sty
	${LATEX} $<
