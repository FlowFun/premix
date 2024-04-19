library(readxl)
library(ggplot2)
library(reshape2)
library(nlme)
library(tidyverse)
library(ggpubr)
library(kableExtra)
library(rstatix)

## fichier R Markdown
template_file <- "src/Premix_stability.Rmd"

## -----------------------------------------------##

## Percentage analysis dataset
df_pct <- read_excel("data/stab_premix_pct.xlsx", sheet = "AT")
df_pct_split <- df_pct %>% 
  group_by(Marker) %>% 
  group_split()

## MFI analysis dataset
df_MFI <- read_excel("data/stab_premix_MFI.xlsx", sheet = "AT")
df_MFI_split <- df_MFI %>% 
  group_by(Marker) %>% 
  group_split()

results_df <- data.frame()
results_df <- df_pct %>% 
  rowwise() %>% 
  mutate(
    mean = mean(c_across(`day 1`:`day 29`)),
    sd = sd(c_across(`day 1`:`day 29`)),
    cv = sd / mean) %>%
  ungroup() %>%
  select(Marker, mean, cv) %>%  # Assuming you want to keep Marker for grouping
  group_by(Marker) %>%
  summarise(
    mean_of_mean = mean(mean, na.rm = TRUE),
    mean_of_cv = mean(cv, na.rm = TRUE),
    sd_of_cv = sd(cv, na.rm = TRUE)
  )

results_df <-cbind(df_pct[,1:2], results_df)
    

anova_df <- data.frame()

##Loop through all markers as percentage of expression
metric_type <- c("pct", "MFI")
for (metric in metric_type) {
  if (metric == "pct") {df_list <- df_pct_split}
  if (metric == "MFI") {df_list <- df_MFI_split}
  for (df in df_list) {
    mark <- df$Marker[[1]] 

    # output name definition
    output_file <- paste0("C:/Users/mimouna/Documents/R/premix/results/", "rapport_", mark, metric, ".docx")
  
    # Use rmarkdown::render pour generate report
    rmarkdown::render(input = template_file,
                      output_file = output_file,
                      params = list(df = df, mark = mark, metric_type = metric, anova_df = anova_df))
    print(getwd())
  }
}

# Save summary of the datas to a csv file

write.csv(results_df, "results/mean_cv.csv", row.names = FALSE)
