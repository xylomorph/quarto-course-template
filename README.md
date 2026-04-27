# quarto-course-template

<div align="center">
  <p align="center">
  🔗 <a href="https://sebastiancacean.de/quarto-course-template">Generated Course Website (Illustration)</a>
  ⚙️ <a href="https://github.com/xylomorph/quarto-coursegen">Quarto Course Generator</a>
 </p>
</div>
<br/>


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

> [!NOTE]
> There are two ways to customize this template to your needs: You can use the [`quarto-coursgen` CLI](https://github.com/xylomorph/quarto-coursegen) to generate stubs for Quarto files (Steps 6 & 7) or you can create and modify Quarto files without using the `quarto-coursgen` CLI. In this case, simply skip Step 3, 6 and 7.



### 1. Create your course repo

Click **"Use this template"** on GitHub to create a new repository, then clone it locally.

### 2. Install the FontAwesome Quarto extension

The generated module pages use FontAwesome icons. Install the extension once in the project root:

```bash
quarto add quarto-ext/fontawesome
```

### 3. Install Python dependencies (`quarto-coursegen`)

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

Edit the generated `.qmd` stubs. If you don't use the [`quarto-coursgen` CLI](https://github.com/xylomorph/quarto-coursegen), create and modify `.qmd` files as you wish.

See [Argdown usage](#argdown-usage) below for details about using Argdown.

### 9. Render

Local rendering:

```bash
make website        # Quarto website (HTML)
make slides         # Reveal.js slides
make slides-pdf     # Export slides to PDF via Decktape
make handouts       # PDF handouts
make all            # Everything
```

🚧 Server-side rendering: 

#TODO: Provide server-side rendering via Github workflow 


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

🚧 TODO: currently a `bibliography.bib` is placed in the root dir and referenced in the example content.

### Language

Set `language:` in `course.yaml` (`en` or `de`). The generator picks i18n strings from `lang/en.yaml` or `lang/de.yaml` for section headings in generated stubs.


## Make Targets

| Target | Description |
|--------|-------------|
| `make website` | Render full Quarto website |
| `make slides` | Render Reveal.js slides |
| `make slides-pdf` | Export slides to PDF via Decktape |
| `make handouts` | Render PDF handouts |
| `make assignments` | Render assignments |
| `make all` | `website` + `slides` + `slides-pdf` |
| `make clean` | Delete `docs/` |
| `make clean-all` | Delete `docs/` and all generated stubs |


## Argdown Usage

### Slides (Reveal.js)

Generated slide stubs include the Argdown filter and web-component configuration out of the box (since the default template will define the usage of a Argdown configuration file via the YAML header). Use `argdown` fenced blocks for inline source display and `argdown-map` for interactive argument maps:

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

The `argdown.config.json` at the project root sets global defaults (no header, show source, hide map by default). Individual blocks can override these with inline `===...===` YAML front matter. (You can also remove the usage of these global settings via the YAML header of each `qmd` file.)

> **`embed-resources` note:** Reveal.js web components require external scripts — `embed-resources: true` is incompatible with Argdown web-component mode.

### Handouts and Notes (PDF)

Generated handout stubs are pre-configured for PDF output with:
- `mode: inline` + `format: svg` — argdown-map blocks render as inline SVG (converted to PDF by Inkscape via the `svg` LaTeX package and `shell-escape`)
- `syntax-definitions` + `syntax-highlighting` — argdown source blocks receive syntax highlighting in PDF

If you don't use Argdown in a particular handout, the filter and settings are harmless (no-op when no `argdown` blocks are present).

### Argdown in Beamer slides

Beamer (PDF) slides include `syntax-definitions` for argdown source block highlighting. However, `argdown-map` blocks with `mode: web-component` are silently dropped in PDF output. For Beamer documents that need argument maps, replace argdown-map blocks with equivalent images or use a separate handout artifact. ( 🚧 #TODO: There should be a better solution.)


## Argdown Filter: Hints & Key Caveats

The following sections provide some background information and explain:

- Why both `mode` and `sourceHighlighter` must be set for web-component rendering
- How nested settings are configured via `argdown.config.json`
- Why `mode: inline` + `format: svg` is required for PDF output
- Why `-shell-escape` is required for Quarto's two-step PDF pipeline
- How `syntax-definitions` and `syntax-highlighting` are forwarded to pandoc by Quarto
- Direct `pandoc` vs. `quarto render` differences

### How the filter reads YAML metadata

The `@argdown/pandoc-filter` reads the `argdown:` key from the document YAML header, but **only flat string values** are parsed (type `MetaInlines`). Nested objects (type `MetaMap`) are silently ignored (at least, with `argdown<=1.8.1`).

This means only these three keys can be set via YAML:

```yaml
argdown:
  mode: web-component           # controls argdown-map blocks
  sourceHighlighter: web-component  # activates web-component rendering for argdown blocks
  config: path/to/argdown.config.json  # path to external config file
```

### Why both `mode` and `sourceHighlighter` are required

- `sourceHighlighter: web-component` — routes `argdown` (source) blocks into the web-component code path
- `mode: web-component` — makes the internal `getProcess()` function include the `highlight-source` and `export-web-component` steps so that output is actually produced

Omitting either one results in either a generic code block (no `sourceHighlighter`) or empty output (no `mode`).

### Nested settings: three approaches

Settings like `webComponent.withoutHeader`, `webComponent.views`, and `sourceHighlighter.removeFrontMatter` cannot be set via the document YAML header. There are three ways to apply them:

#### Option A: Inline `===...===` front matter per code block

Each `argdown` block can carry its own settings as a YAML front matter section delimited by `===`:

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

(1) First premise.
(2) Second premise.
--
(3) Conclusion.
```
````

**Pro:** self-contained, no external files needed.  
**Con:** verbose; must be repeated in every code block.

#### Option B: `argdown.config.json` with explicit `config` path

Place an `argdown.config.json` at the project root and point to it from the document YAML header:

```yaml
argdown:
  mode: web-component
  sourceHighlighter: web-component
  config: ../../argdown.config.json
```

**Important:** the filter resolves the config path relative to `process.cwd()`, which for pandoc/quarto is the **directory of the file being rendered** (e.g. `content/slides/`), not the project root. The `config` key is the only way to reliably reference a project-root config from a subdirectory.

#### `argdown.config.json` (project root)

```json
{
  "webComponent": {
    "withoutHeader": true,
    "views": {
      "source": true,
      "map": false
    }
  },
  "sourceHighlighter": {
    "removeFrontMatter": true
  }
}
```

**Pro:** settings defined once, apply to all blocks across all slide files.  
**Con:** requires the `config` path to be correct in every file's YAML header.

#### Option C: Place `argdown.config.json` in `content/slides/`

The filter auto-discovers `argdown.config.json` in the working directory. Placing it in `content/slides/` means no `config:` key is needed in the YAML header.

**Pro:** no `config:` path needed.  
**Con:** if you have multiple render subdirectories, each needs its own copy (or symlink).

### Rendering to PDF: `mode: inline` required

#### Problem

`mode: web-component` outputs `RawBlock("html", ...)` elements. Pandoc **silently drops** raw HTML blocks when the target format is PDF/LaTeX — no error, no warning, the blocks simply disappear.

#### Solution: `mode: inline` + `format: svg`

Use `mode: inline` with `format: svg`. The filter renders each `argdown-map` block as a base64-encoded inline SVG data URI.

For documents that are rendered to **both** HTML and PDF, split the configuration: keep `mode: web-component` for the HTML format via Quarto's format-specific metadata, and set `mode: inline` at the top level so direct `pandoc -t pdf` calls and Quarto's PDF render both pick it up:

```yaml
format:
  html:
    argdown:
      mode: web-component
      sourceHighlighter: web-component
      config: ../../argdown.config.json
  pdf:
    documentclass: article
    papersize: a4
    pdf-engine-opt: "-shell-escape"  # see below
    # ... other pdf options ...
filters:
  - ../../node_modules/.bin/argdown-filter
argdown:
  mode: inline
  format: svg
  config: ../../argdown.config.json
```

**Key points:**
- Top-level `argdown:` is what the filter reads when running pandoc directly (`pandoc -t pdf --filter argdown-filter`). Set it to `mode: inline` for PDF compatibility.
- Quarto merges format-specific metadata into the top-level keys when rendering a specific format, so `format.html.argdown:` overrides the top-level `argdown:` for HTML output.
- `argdown` (source) blocks with `sourceHighlighter: web-component` are also dropped silently in PDF. They are simply omitted from the PDF output (no fallback plain-text rendering).

#### Why `-shell-escape` is required for Quarto PDF

Direct `pandoc -t pdf` and `quarto render` handle SVG data URIs differently:

| | `pandoc -t pdf` (single-step) | `quarto render` (two-step) |
|---|---|---|
| **Pipeline** | pandoc compiles directly to PDF | pandoc → `.tex`, then `lualatex` separately |
| **SVG handling** | pandoc converts data URIs to raster via `rsvg-convert` before calling lualatex | SVG data URI written to a mediabag `.svg` file; LaTeX source uses `\includesvg{}` from the `svg` package |
| **Conversion tool** | `rsvg-convert` (no shell-escape needed) | `svg` package calls **Inkscape** at compile time via shell-escape |

The `svg` LaTeX package needs shell-escape enabled (`-shell-escape`) in order to invoke Inkscape for the SVG→PDF conversion. Without it, lualatex fails with a missing `.pdf` error.

**Required:** Inkscape must be installed. `rsvg-convert` is still used by direct pandoc invocations.

**Setting it globally** in `_quarto.yml` avoids repeating it in every document's frontmatter:

```yaml
# _quarto.yml
format:
  html:
    # ... html options ...
  pdf:
    pdf-engine-opt: "-shell-escape"
```

Documents without any argdown-map blocks are unaffected by this setting.

### Complete working YAML header for slide files

```yaml
filters:
  - ../../node_modules/.bin/argdown-filter
argdown:
  mode: web-component
  sourceHighlighter: web-component
  config: ../../argdown.config.json
```

With this setup, individual `argdown` code blocks do **not** need `===...===` front matter — the config file provides the defaults globally.

### Highlighting argdown code blocks

When `argdown` source blocks are rendered as plain code blocks (i.e. not via the web-component), pandoc uses its built-in syntax highlighting. By default, pandoc does not know the argdown language, so the block is rendered without highlighting. A syntax definition file (`.xml`) and optionally a highlight theme (`.theme`) are needed.

#### What works in Quarto vs. direct pandoc

| Option | Direct `pandoc` | `quarto render` |
|---|---|---|
| `--syntax-definition=file.xml` (CLI flag) | ✅ | — |
| `--highlight-style=file.theme` (CLI flag) | ✅ | — |
| `pandoc-args:` at document top level | ✅ | ✗ silently dropped |
| `pandoc-args:` under `format.pdf:` | ✅ | ✗ silently dropped |
| `syntax-definitions:` under `format.pdf:` | — | ✅ forwarded to pandoc |
| `highlight-style:` with custom `.theme` path | — | ✗ silently dropped |
| `syntax-highlighting:` with custom `.theme` path | — | ✅ forwarded to pandoc |

**Note:** `highlight-style` and `syntax-highlighting` are different keys. Quarto forwards `syntax-highlighting` (with a file path) to pandoc but silently drops `highlight-style` when a file path is given.

#### Applying a syntax definition and custom theme in Quarto (PDF)

Use `syntax-definitions` and `syntax-highlighting` together under `format.pdf:` in the document frontmatter (paths relative to project root):

```yaml
format:
  pdf:
    syntax-definitions:
      - assets/pandoc/argdown.xml
    syntax-highlighting: assets/pandoc/argdown.theme
```

This causes pandoc to recognize `argdown` as a language and render token colours from the custom `.theme` file. The `argdown` blocks in the `.tex` output will contain `\NormalTok`, `\KeywordTok`, etc. with colours defined by the theme.

#### Applying a syntax definition in direct pandoc

```sh
pandoc input.md -f markdown -t pdf \
  --syntax-definition=./assets/pandoc/argdown.xml \
  --highlight-style=./assets/pandoc/argdown.theme \
  --filter ./node_modules/.bin/argdown-filter \
  -o output.pdf
```

#### Styling the code block frame in LaTeX/PDF

Pandoc wraps highlighted code blocks in a `Shaded` LaTeX environment. To replace the default appearance (a plain coloured box) with a custom framed style using `mdframed`, redefine `Shaded` in an `include-in-header` partial.

**Timing caveat:** `include-in-header` content is injected at the top of the preamble, but pandoc only emits `\newenvironment{Shaded}` later in the same preamble (conditionally, if any highlighted block exists). `\renewenvironment` requires the environment to already exist, so a direct redefinition fails with:

```
! \renewenvironment{Shaded} ... undefined
```

**Fix:** wrap the redefinition in `\AtBeginDocument{...}`, which runs after all preamble definitions are complete. Additionally, pandoc only emits `\newenvironment{Shaded}` when a document actually contains highlighted code blocks — documents without any (e.g. `index.qmd`) never get `Shaded` at all, causing `\renewenvironment` to fail with "Environment Shaded undefined". Use `\ifdefined` (e-TeX primitive, always available in LuaLaTeX) to handle both cases:

```latex
\AtBeginDocument{%
  \ifdefined\Shaded
    \renewenvironment{Shaded}{\centering \begin{mdframed}[style=codedefault]}{\end{mdframed}}%
  \else
    \newenvironment{Shaded}{\centering \begin{mdframed}[style=codedefault]}{\end{mdframed}}%
  \fi
}
```

**Why not `\@ifundefined`:** when `include-in-header` content is read, `@` may have catcode 12 (not a letter), causing `\@ifundefined` to tokenize as `\@` (a LaTeX internal that uses `\spacefactor`) followed by plain text — crashing with "You can't use `\spacefactor' in vertical mode". `\ifdefined` has no `@` and works unconditionally.

**Note:** `\renewenvironment` in a `template-partials` file (e.g. `before-body.tex`) would also work without `\AtBeginDocument`, because partials are inserted after `\begin{document}` where `Shaded` is already defined. However, keeping the style-related code together with the package declarations in `include-in-header` is preferable for cohesion.

## License

MIT
