## test de scrpit pour rapport % et MFI couplés

test <- rbind(df_mfi[[1]], df_pct[[1]])

template_file <- here("src", "Premix_stability_unique.Rmd")
rmarkdown::render(input = template_file,
                  output_file = output_file,
                  params = list(df = test, mark = mark))


