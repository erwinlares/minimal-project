## flowchart LR
##   A[load the libraries <br>and data] --> B[Prepare <br>the data]
##   B --> C[Perform Calculations]
##   C --> D[Print tabular results]
##   C --> E[Render visualizations]
##   D -->F[Save tabular results as .csv<br>Save plot as .png]
##   E -->F

## ---------------------------------------
library(tidyverse)
library(palmerpenguins)
library(gt)

# Check if the script is running interactively
is_interactive <- interactive()

if (is_interactive) {
  # Use hardcoded path for local development/testing
  data_file <- "data/data.csv"
} else {
  # Use command-line arguments when running via Rscript
  args <- commandArgs(trailingOnly = TRUE)
  if (length(args) < 1) {
    stop("Missing required argument: data_file path")
  }
  data_file <- args[1]
}

data <- read.csv(data_file)


## ---------------------------------------
#| label: tbl-mot
#| tbl-cap: "Measures of tendency for 3 penguin species"

moft_bm <- data |>
    group_by(species) |>
    summarize(min_fl = min(flipper_length_mm, na.rm = TRUE),
              max_fl = max(flipper_length_mm, na.rm = TRUE),
              mean_fl = mean(flipper_length_mm, na.rm = TRUE),
              sd_fl = sd(flipper_length_mm, na.rm = TRUE))

moft_bm |> 
  gt() |> 
  fmt_number(decimals = 0) |> 
  tab_header(
    title = "Measures of Tendency",
    subtitle = "Flipper Length in mm"
  )


## ---------------------------------------
#| label: fig-boxplot
#| fig-cap: "Flipper length in mm"

data |> 
    ggplot() +
    aes(x = flipper_length_mm, color = species) +
    geom_boxplot() + 
    labs(title = "Flipper length in mm") +
    theme_bw()


## ---------------------------------------

moft_bm |> write_csv("results-folder/moft-bm.csv")

ggsave("results-folder/fl-mm-plot.png")


## ---------------------------------------
#| eval: false

# # rstudioapi::documentPath() |>
# #      basename() |> #makes it a relative path to the                       project directory
#     knitr::purl("analysis.qmd", documentation = 1)


