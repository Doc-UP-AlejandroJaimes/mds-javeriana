# install.packages("magrittr")
# install.packages("knitr")
# install.packages("kableExtra")

# 1. Set libraries
library(magrittr)
library(knitr)
library(kableExtra)

# 2. Create Dataframe

x <- c(12, 45, 9, 12, 09)
m = matrix(x, ncol = 2) %>%
  addmargins()
colnames(m) = c("Urbana", "Rural", "Total")
rownames(m) = c("Bueno", "Regular", "Malo", "Total")

# 3. Print table
m %>%
  kable("html") %>%
  kable_styling("striped", full_width = FALSE)