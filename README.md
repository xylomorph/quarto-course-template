# quarto-course-template

A GitHub repository template for building Quarto-based course websites with strong support for [Argdown](https://argdown.org/) argument mapping and visualization.

Based on the [`quarto-coursegen`](https://github.com/xylomorph/quarto-coursegen) scaffolding generator.

## Features

- **Course website** — Quarto website with navigation generated from `course.yaml`
- **Slides** — Reveal.js HTML slides + optional Beamer PDF, exported to PDF via Decktape
- **Handouts & notes** — PDF output with custom HHU-style header/footer via LaTeX partials
- **Assignments** — HTML + PDF artifacts
- **Argdown integration** — live argument maps and highlighted source blocks in slides (web-component) and PDF outputs (inline SVG)
- **Custom annotation CSS** — `.ann-premise`, `.ann-conclusion`, `.ann-key`, `.ann-doubt`, `.ann-marginal` span classes for slide markup
- **Argdown syntax highlighting** in PDF via a custom `.xml` syntax definition and `.theme` file

---

## Prerequisites

| Tool | Purpose | Install |
|------|---------|---------|
| [Quarto](https://quarto.org) ≥ 1.5 | Rendering | [quarto.org/docs/get-started](https://quarto.org/docs/get-started/) |
| Python ≥ 3.11 | Generator CLI | system or [uv](https://docs.astral.sh/uv/) |
| `quarto-coursegen` | Stub generator | `uv tool install quarto-coursegen` or `pip install quarto-coursegen` |
| Node.js ≤ 20 | Argdown pandoc filter | `nvm install 20` |
| `@argdown/pandoc-filter` | Argdown rendering | `npm install` (see below) |
| [Inkscape](https://inkscape.org) | SVG→PDF conversion for argdown maps in PDF | system package |
| [Decktape](https://github.com/astefanutti/decktape) | Slide PDF export | `npm install -g decktape` (needs newer Node) |

> **Node version note:** `@argdown/pandoc-filter` requires Node ≤ 20. Decktape works best with a newer LTS (e.g. `lts/krypton` / Node 24). If you use [nvm](https://github.com/nvm-sh/nvm), pin the project to Node 20 via the included `.nvmrc` and install Decktape globally under a newer version.

---

## Getting Started

### 1. Create your course repo

Click **"Use this template"** on GitHub to create a new repository, then clone it locally.

### 2. Install the FontAwesome Quarto extension

The generated module pages use FontAwesome icons. Install the extension once in the project root:

```bash
quarto add quarto-ext/fontawesome
```

### 3. Install Python dependencies

```bash
# Using uv (recommended)
uv sync        # creates .venv and installs quarto-coursegen
source .venv/bin/activate

# Or pip
pip install quarto-coursegen
```

### 4. Install Node dependencies (Argdown)

```bash
nvm use        # switches to Node 20 (from .nvmrc)
npm install    # installs @argdown/cli, @argdown/pandoc-filter, @argdown/image-export
```

Install Decktape globally under a newer Node version (for slide PDF export):

```bash
nvm install lts/krypton   # or your preferred newer LTS
nvm use lts/krypton
npm install -g decktape
nvm use 20   # switch back for argdown work
```

### 5. Install system dependencies

- **Inkscape** — required for Quarto's two-step PDF pipeline with inline SVG argdown maps
  - Ubuntu/Debian: `sudo apt install inkscape`
  - macOS: `brew install --cask inkscape`
- **LuaLaTeX** — required for PDF handouts (included with TeX Live / MiKTeX)
  - Ubuntu: `sudo apt install texlive-full`
  - macOS: install [MacTeX](https://www.tug.org/mactex/)

Also install the LaTeX `svg` and `mdframed` packages if not included with your TeX distribution.

### 6. Configure your course

Edit `course.yaml` to define your course metadata, modules, and artifacts. This is the single source of truth — all stubs and navigation are generated from it.

Key fields:

```yaml
course:
  id: my-course
  title: "My Course Title"
  subtitle: "Optional subtitle"
  semester: "WS 2026"
  language: "en"   # en | de
  instructors:
    - name: "Prof. Jane Smith"
      email: "jane@university.edu"
  organization:
    institution: "My University"
    department: "Department of X"
    institute: "Institute of Y"

modules:
  - id: intro
    title: "Introduction"
    date: 2026-10-01
    artifacts:
      - id: intro-slides
        type: slides
        output_formats: [revealjs, beamer]
      - id: intro-handout
        type: handout
        output_formats: [website, pdf]
```

### 7. Generate stubs

```bash
make generate        # safe: skips existing stubs
make generate-force  # overwrites all stubs
```

This creates `content/slides/*.qmd`, `content/handouts/*.qmd`, `index.qmd`, `_quarto.yml`, etc.

### 8. Add your content

Edit the generated `.qmd` stubs. See [Argdown usage](#argdown-usage) below.

### 9. Render

```bash
make website        # Quarto website (HTML)
make slides         # Reveal.js slides
make slides-pdf     # Export slides to PDF via Decktape
make handouts       # PDF handouts
make all            # Everything
```

---

## Project Structure

```
.
├── course.yaml               # Single source of truth
├── argdown.config.json       # Global Argdown defaults (auto-discovered by filter)
├── package.json              # Node dependencies (@argdown/*)
├── pyproject.toml            # Python dependency (quarto-coursegen)
├── .nvmrc                    # Node version pin (20) for @argdown
├── Makefile                  # All build targets
├── assets/
│   ├── images/               # Logo files (replace with your institution's logo)
│   ├── latex/                # LaTeX partials for PDF output
│   │   ├── _handout-packages.tex   # Handout packages: geometry, fancyhdr, fontspec, mdframed
│   │   ├── _beamer-packages.tex    # Beamer-safe subset: mdframed Shaded environment only
│   │   └── before-body.tex         # fancyhdr header/footer template (handouts only)
│   ├── pandoc/               # Argdown syntax highlighting for PDF
│   │   ├── argdown.xml             # Pandoc syntax definition
│   │   └── argdown.theme           # Custom highlight theme
│   ├── partials/
│   │   └── title-block.html  # Removes date/author from HTML title block
│   └── styles/
│       ├── custom.scss       # Website theme overrides
│       └── slides.scss       # Reveal.js theme (HHU colours + annotation classes)
├── templates/                # Jinja2 stub templates (used by quarto-coursegen)
│   ├── slides.qmd.j2
│   ├── handout.qmd.j2
│   ├── notes.qmd.j2
│   └── ...
├── lang/
│   ├── en.yaml               # English i18n strings
│   └── de.yaml               # German i18n strings
└── content/                  # Generated stubs (do not commit _quarto.yml files)
    ├── slides/
    ├── handouts/
    ├── modules/
    ├── notes/
    └── assignments/
```

---

## Argdown Usage

### Slides (Reveal.js)

Generated slide stubs include the Argdown filter and web-component configuration out of the box. Use `argdown` fenced blocks for inline source display and `argdown-map` for interactive argument maps:

````markdown
```argdown
===
webComponent:
    withoutHeader: true
    views:
        source: true
        map: false
sourceHighlighter:
    removeFrontMatter: true
===

(1) All humans are mortal.
(2) Socrates is a human.
--
(3) Socrates is mortal.
```
````

````markdown
```argdown-map
[Claim]
    <- <Counterargument>
    <- <Objection>
```
````

The `argdown.config.json` at the project root sets global defaults (no header, show source, hide map by default). Individual blocks can override these with inline `===...===` YAML front matter.

> **`embed-resources` note:** Reveal.js web components require external scripts — `embed-resources: true` is incompatible with Argdown web-component mode.

### Handouts and Notes (PDF)

Generated handout stubs are pre-configured for PDF output with:
- `mode: inline` + `format: svg` — argdown-map blocks render as inline SVG (converted to PDF by Inkscape via the `svg` LaTeX package and `shell-escape`)
- `syntax-definitions` + `syntax-highlighting` — argdown source blocks receive syntax highlighting in PDF

If you don't use Argdown in a particular handout, the filter and settings are harmless (no-op when no `argdown` blocks are present).

### Argdown in Beamer slides

Beamer (PDF) slides include `syntax-definitions` for argdown source block highlighting. However, `argdown-map` blocks with `mode: web-component` are silently dropped in PDF output. For Beamer documents that need argument maps, replace argdown-map blocks with equivalent images or use a separate handout artifact. See `misc/argdown_hints.md` in the HHU example course for the full technical background.

---

## Customization

### Logos

Replace the placeholder image `logo.png` in `assets/images/` used as Reveal.js slide logo in the PDF handout header.

Update the filenames referenced in:
- `assets/latex/before-body.tex` (handout header, `\includegraphics{...}`)
- `templates/slides.qmd.j2` (`logo:` key)

### Colours and fonts

- Slide theme: edit `assets/styles/slides.scss` (SCSS variables and rules)
- Website theme: edit `assets/styles/custom.scss`
- Handout font / geometry: edit `assets/latex/_handout-packages.tex`
- Handout header colour: edit `\definecolor{handoutline}{...}` in `assets/latex/before-body.tex`

### Bibliography

Add a `.bib` file to `assets/` and reference it in each document's YAML frontmatter:

```yaml
bibliography: ../../assets/references.bib
```

### Language

Set `language:` in `course.yaml` (`en` or `de`). The generator picks i18n strings from `lang/en.yaml` or `lang/de.yaml` for section headings in generated stubs.

---

## Make Targets

| Target | Description |
|--------|-------------|
| `make generate` | Generate stubs (skip existing) |
| `make generate-force` | Regenerate all stubs (overwrites content!) |
| `make website` | Render full Quarto website |
| `make slides` | Render Reveal.js slides |
| `make slides-pdf` | Export slides to PDF via Decktape |
| `make handouts` | Render PDF handouts |
| `make assignments` | Render assignments |
| `make all` | `website` + `slides` + `slides-pdf` |
| `make clean` | Delete `docs/` |
| `make clean-all` | Delete `docs/` and all generated stubs |

---

## Argdown Filter: Key Caveats

See [argdown_hints.md](https://github.com/xylomorph/quarto-coursegen) (or the `misc/argdown_hints.md` in any course generated with this template) for a detailed reference on:

- Why both `mode` and `sourceHighlighter` must be set for web-component rendering
- How nested settings are configured via `argdown.config.json`
- Why `mode: inline` + `format: svg` is required for PDF output
- Why `-shell-escape` is required for Quarto's two-step PDF pipeline
- How `syntax-definitions` and `syntax-highlighting` are forwarded to pandoc by Quarto
- Direct `pandoc` vs. `quarto render` differences

---

## License

MIT
