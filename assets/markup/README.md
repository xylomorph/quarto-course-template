# Markup Annotations

This folder provides reusable semantic markup classes for Quarto content.

Files:
- `annotations.css`: HTML and RevealJS styles for annotation classes.
- `annotation-spans-pdf.lua`: maps annotation spans to LaTeX macros for PDF output.
- `markup.tex`: LaTeX macro definitions used by PDF output.

## What this feature does

You can annotate text in Quarto using semantic classes:
- `.ann-highlight`
- `.ann-premise`
- `.ann-conclusion`
- `.ann-key`
- `.ann-doubt`
- `.ann-marginal` (supports `data-note`)

These classes are styled in HTML/RevealJS via CSS and converted for PDF via the Lua filter and LaTeX macros.

## Project configuration

Ensure your project config includes:

1. HTML CSS include:

```yaml
format:
  html:
    css:
      - assets/markup/annotations.css
```

2. PDF header include:

```yaml
format:
  pdf:
    include-in-header:
      - assets/markup/markup.tex
```

3. Lua filter:

```yaml
filters:
  - assets/markup/annotation-spans-pdf.lua
```

In this template, these are already configured in `_quarto-format.yml`.

## Usage: Inline span annotations (recommended)

Use bracket-span syntax in `.qmd` files:

```markdown
[This is a premise.]{.ann-premise}
[This is a tentative conclusion.]{.ann-conclusion}
[Important term]{.ann-key}
[Highlight this phrase]{.ann-highlight}
[Potential objection here]{.ann-doubt}
[Check source quality]{.ann-marginal data-note="Exam hint"}
```

This inline syntax is the recommended cross-format approach, because PDF mapping currently targets spans.

## Usage: Block Div annotations (HTML/RevealJS styling)

You can also apply classes to Div blocks:

```markdown
::: {.ann-highlight}
This full block is highlighted.
:::

::: {.ann-doubt}
This block marks a skeptical section.
:::

::: {.ann-marginal data-note="Discuss in class"}
This block carries a marginal note in HTML.
:::
```

Note:
- CSS styling works for Divs in HTML/RevealJS.
- PDF conversion logic currently maps inline span classes. Div-specific PDF behavior is not yet implemented in the Lua filter.

## Small combined example

```markdown
The argument starts with [an observed regularity]{.ann-premise} and emphasizes
[a key concept]{.ann-key}. [A counterpoint]{.ann-doubt} is then raised,
followed by [a provisional conclusion]{.ann-conclusion}. [Review assumption B]{.ann-marginal data-note="Revisit"}
```
