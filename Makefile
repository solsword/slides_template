SOURCES := $(shell find . -name "*.mkd" | sed -e "s/\.mkd$$/.html/g")

.PHONY: all
all: $(SOURCES)

.DEFAULT_GOAL := all

req/require.js:
	git clone https://github.com/hakimel/require.js req/require.js

%.html: %.mkd req/head.html req/foot.html req/main.css req/reveal-theme.css \
	      req/reveal.js
	pandoc $< --standalone --mathml --from=markdown+smart --include-in-header=req/head.html --include-after-body=req/foot.html --to=revealjs --variable=revealjs-url:req/reveal.js --output=$@

%-raw.pdf: %.html req/print.css
	wkhtmltopdf --user-style-sheet req/print.css --javascript-delay 1400 --grayscale --no-background -O Landscape file://`pwd`/$<?print-pdf $@

%-2x2.pdf: %-raw.pdf
	pdfnup --landscape --nup 2x2 --frame true -o $@ $<
