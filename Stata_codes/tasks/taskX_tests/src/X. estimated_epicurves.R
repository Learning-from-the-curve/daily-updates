install.packages("devtools")
devtools::install_github("reconhub/incidence")
devtools::install_github("reconhub/outbreaks")
install.packages("incidence")
install.packages("outbreaks")

devtools::install_github("reconhub/outbreaks")


#vignette("overview", package="incidence")
#vignette("customize_plot", package="incidence")
#vignette("incidence_class", package="incidence")
#vignette("incidence_fit_class", package="incidence")
#vignette("conversions", package="incidence")

library(ggplot2)
library(incidence)
library(outbreaks)

dat1 <- ebola_sim_clean$linelist
str(dat1, strict.width = "cut", width = 76)