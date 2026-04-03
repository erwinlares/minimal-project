# Minimal R Project: From Quarto Document to R Script

> A reference pattern for R analysts who want reproducible, portable, and maintainable projects from day one.

Code: https://github.com/erwinlares/minimal-project

---

## What problem does this solve?

Most R projects start as a script. It works — until you need to share it, re-run it six months later, or move it to a cluster. At that point, paths are hardcoded, context assumptions are buried, and keeping a `.R` file in sync with a `.qmd` narrative becomes a manual chore.

This project demonstrates a pattern that avoids those problems by treating the Quarto document as the **single source of truth**. The `.R` script is derived from it automatically. The same code runs without modification in RStudio, via `quarto render`, and from the command line.

---

## Who is this for?

- R analysts who want a reproducible starting point they can adapt to real projects
- Researchers preparing work for execution on HTC/HPC clusters
- Anyone who has experienced `.R` and `.qmd` files drifting out of sync

---

## Quick Start

**Prerequisites:** R (>= 4.x), `renv`, Quarto CLI

```r
# 1. Restore the package environment
renv::restore()

# 2. Render the document — regenerates analysis.R via post-render hook
quarto::quarto_render("analysis.qmd")

# 3. Inspect the generated script
file.show("analysis.R")
```

```bash
# 4. Run the extracted script from the command line
Rscript analysis.R data/data.csv
```

---

## What files are generated?

| File | Type | Notes |
|---|---|---|
| `analysis.qmd` | source | Edit this — it is the single source of truth |
| `analysis.R` | generated | Auto-extracted on every render; do not edit directly |
| `analysis.html` | generated | Rendered HTML output |
| `results-folder/moft-bm.csv` | output | Summary statistics table |
| `results-folder/fl-mm-plot.png` | output | Boxplot figure |

Committed source files:

```
.
├── analysis.qmd          # single source of truth
├── purl.R                # post-render script; extracts R code from .qmd
├── _quarto.yml           # Quarto project config; triggers purl.R
├── renv.lock             # reproducible package environment
├── minimal-project.Rproj # RStudio project file
└── data/
    └── data.csv          # input data
```

---

## What should I edit first?

| If you want to… | Edit this |
|---|---|
| Adapt the analysis to your own data | `analysis.qmd` — replace the Palmer Penguins example |
| Change the default data path | The `params:` block in the `analysis.qmd` YAML header |
| Add packages | `renv::install()`, then `renv::snapshot()` to update the lockfile |
| Change when/how the `.R` file is generated | `purl.R` and `_quarto.yml` |

---

## How it works

### One source of truth

`_quarto.yml` registers `purl.R` as a post-render script:

```yaml
project:
  post-render:
    - purl.R
```

Every time `analysis.qmd` is rendered, `knitr::purl()` extracts all R code chunks and writes them to `analysis.R`. The script is always in sync with the document — you never edit it directly, and drift is strongly prevented by construction.

### Three execution contexts, one codebase

The same code resolves its data input correctly in all three contexts:

| Context | How the data path is resolved |
|---|---|
| Interactive (RStudio) | Hardcoded path for development |
| `quarto render` | Falls back to `params$data_file` in the YAML header |
| `Rscript` | Reads the path from a command-line argument |

This means the transition from interactive development to scripted execution is not a rewrite — it is just a change in how you invoke the code.

---

## Notes

- Plot rendering is suppressed under `Rscript` to avoid a stray `Rplots.pdf`. Plots render normally in RStudio and Quarto contexts.
- `results-folder/` is created programmatically at runtime if it does not exist.
- The analysis content (Palmer Penguins summary statistics and boxplot) is intentionally minimal. The pattern is the point, not the domain.