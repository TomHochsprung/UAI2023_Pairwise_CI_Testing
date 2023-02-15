library(ggplot2)
library(dplyr)
library(tidyr)
library(ggpubr)
library(latex2exp)


# contains code to generate plots based on stored csv-files

# first some data cleaning
rejection_rate_df <- read.csv("gcm_rejection_rate_df_dist_corr_tau00.csv")
x_names <- c(
  `2` = "(d_X, d_Y) = (2, 2)",
  `3` = "(d_X, d_Y) = (3, 3)",
  `5` = "(d_X, d_Y) = (5, 5)",
  `7` = "(d_X, d_Y) = (7, 7)",
  `216` = "n = 216",
  `432` = "n = 432",
  `864` = "n = 864",
  `1728` = "n = 1728"
)
rejection_rate_df <- rejection_rate_df %>% filter(dim_X %in% c(2, 3, 5, 7)) %>% filter(n %in% c(216, 432, 864))

# plotting
p0 <- ggplot(rejection_rate_df, aes(x = rho, y = mean_rejection_rate, color = alg)) +
  geom_line(size = 1.5) +
  geom_errorbar(aes(ymin = mean_rejection_rate - se_rejection_rate, ymax = mean_rejection_rate + se_rejection_rate), width = .003, size = 1) +
  labs(color = "Algorithm", y = "Power", x = TeX("$\\rho$")) +
  facet_grid(vars(dim_X), vars(n), switch = "y", labeller = as_labeller(x_names)) + 
  theme(legend.position = "top", text = element_text(size = 25), axis.text=element_text(size=20), panel.spacing = unit(1.5, "lines"), plot.margin = unit(c(5.5, 5.5, 5.5, 5.5), "pt")) +
  scale_color_manual(values=c("#999999", "#E69F00", "#56B4E9", "#009E73","#F0E442"))

# if several different taus are plotted, these plots can be plotted together:
# ggarrange(p0, p1, p2, common.legend = TRUE, legend = "top", nrow = 3)

