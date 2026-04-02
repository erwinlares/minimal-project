# Minimal R Project: From Quarto Document to R Script

A basic data science project that demonstrates how to start with a human-friendly
Quarto document and automatically derive machine-ready artifacts from it — with
no manual syncing and no risk of code drift.

## The Core Idea

Most research projects start as code. This one starts as a **document**.

By writing the analysis in a Quarto (`.qmd`) file first, you are forced to
articulate *what* you are doing and *why*, not just *how*. The prose, the code,
and the outputs all live in one place and evolve together. This is not just a
style preference — it is a strategy for keeping your work understandable,
reproducible, and easy to hand off.

The machine-readable `.R` script is a **derived artifact** of the `.qmd`. It is
generated automatically on every render via a post-render hook, so it is always
up to date. You maintain a single source of truth and never have to remember to
keep two files in sync.

The long-term goal is to show that a project can start as a mostly human-focused
document and, through deliberate automation, make a clean transition to
machine-friendly scripts — **without code drift as the project evolves**.

---

## Project Structure

```
.
├── analysis.qmd          # Single source of truth — human-friendly document
├── analysis.R            # Derived artifact — auto-generated from analysis.qmd
├── analysis.html         # Rendered output
├── purl.R                # Post-render script that extracts R code from .qmd
├── _quarto.yml           # Quarto project config; triggers purl.R post-render
├── renv.lock             # renv lockfile for reproducible package environment
└── minimal-project.Rproj # RStudio project file
```

---

## How It Works

### 1. Write in Quarto
`analysis.qmd` is the primary document. It combines prose, diagrams (Mermaid),
and R code chunks into a single readable narrative. The analysis uses the
Palmer Penguins dataset as a toy example, computing summary statistics and
producing a boxplot.

### 2. Auto-generate the R Script (Preventing Code Drift)
`_quarto.yml` registers `purl.R` as a post-render script:

```yaml
project:
  post-render:
    - purl.R
```

Every time `analysis.qmd` is rendered, `knitr::purl()` automatically extracts
all R code chunks and writes them to `analysis.R`. This means:

- There is **one source of truth**: the `.qmd`
- `analysis.R` is always in sync — you never edit it directly
- Code drift between the document and the script is structurally impossible

---

## Getting Started

### Prerequisites
- R (>= 4.x) with `renv` installed
- Quarto CLI

### Running the Project

```r
# Restore package environment
renv::restore()

# Render the document (also regenerates analysis.R)
quarto::quarto_render("analysis.qmd")

# Or run the extracted R script directly
Rscript analysis.R data/data.csv
```

---

## Package Management

This project uses [`renv`](https://rstudio.github.io/renv/) for reproducible
package management.

- Install new packages with `renv::install()` rather than `install.packages()`
- After installing, update the lockfile with `renv::snapshot()`

---

## Special Considerations

- The data file path is resolved in order of context: interactive RStudio session
  → command-line argument (`Rscript analysis.R <file>`) → Quarto params fallback.
  This makes the same code work across all three execution contexts without
  modification.
- Plot rendering is suppressed when running as `Rscript` to avoid generating a
  stray `Rplots.pdf`.
- Results are saved to `results-folder/` as a `.csv` and `.png`.
