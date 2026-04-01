params <-
list(data_file = "data/data.csv")

## flowchart LR
##   A[load the libraries <br>and data] --> B[Prepare <br>the data]
##   B --> C[Perform Calculations]
##   C --> D[Print tabular results]
##   C --> E[Render visualizations]
##   D -->F[Save tabular results as .csv<br>Save plot as .png]
##   E -->F

## -------------------------------------------------------------------
library(tidyverse)
library(gt)

data_file <- if (!is.null(params$data_file)) {
  # Quarto render context: params are defined
  params$data_file
} else if (interactive()) {
  # Interactive session: hardcoded path for development
  "data/data.csv"
} else {
  # Rscript context: read from command-line arguments
  args <- commandArgs(trailingOnly = FALSE)
  if (length(args) < 1) stop("Missing required argument: data_file path")
  args[1]
}

data <- read.csv(data_file)


## -------------------------------------------------------------------
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


## -------------------------------------------------------------------
#| label: fig-boxplot
#| fig-cap: "Flipper length in mm"

data |> 
    ggplot() +
    aes(x = flipper_length_mm, color = species) +
    geom_boxplot() + 
    labs(title = "Flipper length in mm") +
    theme_bw()


## -------------------------------------------------------------------

moft_bm |> write_csv("results-folder/moft-bm.csv")

ggsave("results-folder/fl-mm-plot.png")


## -------------------------------------------------------------------
#| eval: false

# # rstudioapi::documentPath() |>
# #      basename() |> #makes it a relative path to the                       project directory
#     knitr::purl("analysis.qmd", documentation = 1)


## -------------------------------------------------------------------
#| eval: false

# 
# 
# # choosing the grouping variable manually, in the package version this will be passed as an
# # argument
# 
# grouping_variable <- data$species
# 
# 
# # Split the data df into a list of subsets based on the a grouping variable contained in data
# subsets <- split(data, grouping_variable)
# 
# #helper function that takes as an argument a named list and writes a .csv with the contents of each list and names used the naming convention <named-list.csv>
# 
# savesublists <- function(df, name){
#   write_csv(df, paste0("data/", name, ".csv"))
# }
# 
# 
# # Use walk() to write each sublist to a .csv file with the same name as the named_list
# walk2(subsets, names(subsets), savesublists)
# 
# 
# #subdatasets holds the names of the created subsets.csv
# 
# # write.csv(tibble(glue::glue("{names(subsets)}.csv")),
# #           "data/subdatasets.csv",
# #           row.names = FALSE)
# 
# file_list <- tibble(filename = glue::glue("{names(subsets)}.csv"))
# write_csv(file_list, "data/subdatasets.csv", col_names = FALSE)
# 
# 

