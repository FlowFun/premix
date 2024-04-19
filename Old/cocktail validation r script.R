library(readxl)
library(ggplot2)
library(reshape2)
library(nlme)
library(tidyverse)
library(ggpubr)
library(kableExtra)
library(rstatix)

setwd("~/R/premix")
Ab <- "CD57"

A = as.data.frame(read_excel("stab_premix_at.xlsx", sheet = 9, col_names = TRUE))
rownames(A) = A[, 1]
A = A[, -1]

B = A[grep(Ab, rownames(A)), ]
df = data.frame(melt(B), as.factor(rep(1:5, 9)))
colnames(df) = c("Time", Ab, "id")

p <- ggplot(data = df, aes(x = Time, y = CD57)) +
  geom_violin(trim = FALSE, alpha = 0.2, aes(fill = Time)) +
  geom_boxplot(alpha = 0.2, show.legend = FALSE, width = 0.3) +
  geom_line(linetype = "dashed", linewidth = .6, aes(group = id), color = "gray20") +
  geom_point(aes(colour = Time), alpha = 1, size = 2) +
  xlab("time") + ylab("CD57") + theme_bw()
p

tapply(df$CD57, df$Time, mean)

aov_out = aov(CD57~Time, data = df)
summary(aov_out)

tukey_out = TukeyHSD(aov_out)
print(tukey_out)

kruskal_out = kruskal.test(CD57~Time, data = df)
print(kruskal_out)

aov_out_repeated = aov(CD57 ~ Time + Error(id), data = df)
summary(aov_out_repeated)

pwc <- df %>%
  pairwise_t_test(
    CD57 ~ Time, paired = TRUE,
    p.adjust.method = "bonferroni"
  )
kable(as.data.frame(pwc))

friedman.test(as.matrix(B))

pwc <- df %>%
  wilcox_test(
    CD57 ~ Time, paired = TRUE,
    p.adjust.method = "bonferroni"
  )
kable(as.data.frame(pwc))
