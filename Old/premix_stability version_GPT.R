library(here)
library(kableExtra)
library(lubridate)
library(reshape2)
library(rstatix)
library(tidyverse)

# Read and split datasets by marker
df_pct <- read_csv(here("data", "stab_premix_pct.csv"), show_col_types = FALSE) %>% 
  mutate(Source="PCT") %>%
  group_split(Marker)
df_mfi <- read_csv(here("data", "stab_premix_mfi.csv"), show_col_types = FALSE) %>% 
  mutate(Source="MFI") %>%
  group_split(Marker)

# Summarize results for each dataset
results_df <- bind_rows(df_pct, df_mfi) %>% 
  rowwise() %>%
  summarise(
    Patient = Patient,
    Marker = Marker,
    Source =  Source,
    Mean = mean(c_across(contains("day"))),
    SD = sd(c_across(contains("day"))),
    CV = SD / Mean,
    .groups = 'drop'
  )

# Compute overall summary statistics 
result_summary <- results_df %>%
  group_by(Marker, Source) %>%
  summarise(
    MeanOfMeans = mean(Mean),
    SDOfMeans = sd(Mean),
    CVOfMeans = SDOfMeans / MeanOfMeans,
    .groups = 'drop'
  )

# Generate reports for each marker and metric
anova_df <- data.frame()
template_file <- here("src", "Premix_stability.Rmd")
for (metric in c("pct", "mfi")) {
  df_list <- if (metric == "pct") df_pct else df_mfi
  walk(df_list, ~{
    mark <- .$Marker[[1]]
    df <- .x %>% mutate(Source = NULL)
    output_file <- here("results", paste0("report_", mark, metric, ".html"))
    rmarkdown::render(input = template_file,
                      output_file = output_file,
                      params = list(df = df, mark = mark, metric_type = metric))
  })
}

# Save summaries to CSV
write_csv(results_df, here("results", "descriptive_long.csv"))
write_csv(result_summary, here("results", "summary.csv"))
