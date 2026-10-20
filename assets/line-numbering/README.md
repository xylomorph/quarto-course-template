# Reusable Visual Line Numbering (Quarto)

This module provides visual line numbering for fenced divs marked with `.line-number` across:

- HTML (website/docs)
- reveal.js slides
- PDF (LaTeX)

It counts rendered (wrapped) lines, not just paragraph blocks.

## Markup Contract

Use this in any `.qmd` file:

```markdown
::: {.line-number}
Your long text here. Wrapped lines are counted.
:::
```

## Assets in this Module

- `line-number.css`: shared styles for gutter + numbers (HTML/reveal)
- `line-number-script.html`: browser logic to compute rendered line boxes
- `line-number-pdf.lua`: wraps `.line-number` blocks for LaTeX
- `line-numbering.tex`: `lineno` setup for wrapped-line numbering in PDF

## Root Project Wiring (example)

```yaml
format:
  html:
    include-after-body:
      - assets/line-numbering/line-number-script.html
    css:
      - assets/line-numbering/line-number.css
  pdf:
    include-in-header:
      - assets/line-numbering/line-numbering.tex

filters:
  - assets/line-numbering/line-number-pdf.lua
```

## Subproject Wiring (example)

For nested Quarto subprojects, use relative paths from that subproject YAML, e.g.:

```yaml
format:
  html:
    include-after-body:
      - ../../assets/line-numbering/line-number-script.html
    css:
      - ../../assets/line-numbering/line-number.css
  pdf:
    include-in-header:
      - ../../assets/line-numbering/line-numbering.tex

filters:
  - ../../assets/line-numbering/line-number-pdf.lua
```

## Reuse in Other Projects

1. Copy `assets/line-numbering/` into the target project.
2. Add the YAML wiring shown above.
3. Use `::: {.line-number}` where needed.
