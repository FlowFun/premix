library(ggplot2)
library(reshape2)
library(nlme)
library(tidyverse)
library(ggpubr)
library(kableExtra)
library(rstatix)
library(here)

## R Markdown file that generate a report per Marker
template_file <- "src/Premix_stability.Rmd"

## -----------------------------------------------##

## Percentage of positive cells (PCT) analysis dataset
df_pct <- read_csv(here("data", "stab_premix_pct.csv"), show_col_types = FALSE)
df_pct_split <- df_pct %>% 
  group_split(Marker) 

## Median Fluorescence Intensity (MFI) analysis dataset
df_mfi <- read_csv(here("data", "stab_premix_mfi.csv"), show_col_types = FALSE)
df_mfi_split <- df_mfi %>% 
  group_split(Marker) 

## Make a df wich summarize results
results_df <- data.frame()
results_df <- df_pct %>% 
  rowwise() %>% 
  summarise(
    Patient = Patient,
    Marker = Marker,
    mean = mean(c_across(contains("day"))),
    sd = sd(c_across(contains("day"))),
    cv = sd / mean)


result_summary <- results_df %>%
  group_by(Marker) %>%
  summarise(
    mean_of_means=mean(mean),
    sd_of_means = sd(mean),
    cv_of_means = sd_of_means / mean_of_means
  )

anova_df <- data.frame()

## Build reports with a loop through all markers as PCT and MFI
metric_type <- c("pct", "mfi")
for (metric in metric_type) {
  if (metric == "pct") {df_list <- df_pct_split}
  if (metric == "mfi") {df_list <- df_mfi_split}
  for (df in df_list) {
    mark <- df$Marker[[1]] 

    # output name definition
    output_file <- paste0(here("results"), "/rapport_", mark, metric, ".docx")
  
    # Use rmarkdown::render pour generate report
    rmarkdown::render(input = template_file,
                      output_file = output_file,
                      params = list(df = df, mark = mark, metric_type = metric, anova_df = anova_df))
  }
}

# Save summary of the datas to a csv file

write.csv(results_df, here("results", "descriptive_long.csv"))
write.csv(result_summary, here("results", "summary.csv"))
