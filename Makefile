.PHONY: all website slides handouts assignments clean clean-all

# Render the course website (HTML)
website:
	quarto render

# Render slides (reveal.js + Beamer PDF)
slides:
	quarto render content/slides/

# Render handouts (PDF)
handouts:
	quarto render content/handouts/

# Render assignments (HTML + PDF)
assignments:
	quarto render content/assignments/

# Render everything
all: website slides

# Delete rendered output
clean:
	rm -rf docs/

# !! CAUTION — DEV USE ONLY !!
# Removes ALL generated stub files. Any content you added will be lost.
# Regenerate stubs afterwards with: quarto-coursegen generate
clean-all: clean
	rm -f index.qmd _quarto.yml _quarto-nav.yml
	rm -f content/syllabus.qmd
	rm -f content/modules/*.qmd
	rm -f content/slides/*.qmd  content/slides/_quarto.yml
	rm -f content/handouts/*.qmd content/handouts/_quarto.yml
	rm -f content/notes/*.qmd
	rm -f content/assignments/*.qmd content/assignments/_quarto.yml
