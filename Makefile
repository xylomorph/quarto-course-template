.PHONY: all generate generate-force website slides slides-pdf handouts assignments clean clean-all

# Generate stubs and config files from course.yaml
generate:
	quarto-coursegen generate

# Force regenerate all stubs (overwrites existing content)
generate-force:
	quarto-coursegen generate --force

# Render the course website (HTML)
website:
	quarto render

# Render slides (reveal.js + Beamer PDF via Quarto)
slides:
	quarto render content/slides/

# Export slides to PDF using Decktape (requires decktape installed globally).
# Decktape requires a newer Node.js than @argdown (which needs <=20).
# If you use nvm, set DECKTAPE_NODE to the version where decktape is installed:
#   make slides-pdf DECKTAPE_NODE=lts/krypton
DECKTAPE_NODE ?= lts/krypton
slides-pdf: slides
	. $(NVM_DIR)/nvm.sh && nvm use $(DECKTAPE_NODE) && \
	for f in docs/content/slides/*.html; do \
		decktape reveal "$$f" "$${f%.html}.pdf"; \
	done

# Render handouts (PDF)
handouts:
	quarto render content/handouts/

# Render assignments (HTML + PDF)
assignments:
	quarto render content/assignments/

# Render everything
all: website slides slides-pdf

# Delete rendered output
clean:
	rm -rf docs/

# !! CAUTION — DEV USE ONLY !!
# Removes ALL generated files: rendered output AND generated stubs.
# Any content you have added to the stubs will be lost.
# Run 'make generate' afterwards to recreate stubs from course.yaml.
clean-all: clean
	rm -f index.qmd _quarto.yml _quarto-nav.yml
	rm -f content/syllabus.qmd
	rm -f content/modules/*.qmd
	rm -f content/slides/*.qmd  content/slides/_quarto.yml
	rm -f content/handouts/*.qmd content/handouts/_quarto.yml
	rm -f content/notes/*.qmd
	rm -f content/assignments/*.qmd content/assignments/_quarto.yml
