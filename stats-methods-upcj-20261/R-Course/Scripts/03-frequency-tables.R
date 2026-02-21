library(formattable)

# Data
continents <- c("Asia", "Africa", "America", "Europe", "Ocean", "Antartic")
populations <- c(4753500631, 1440353360, 1046571635, 747089798, 44284912, 4490)
frequency <- round(population  / sum(population)*100, 2) #fq relative to %
df = data.frame(continents,
                populations,
                frequency)
head(df, 2)

# rename columns
colnames(df) <- c("Continent", "FABS", "FR (%)")
head(df)

# Formatiing table
table_03_fq = formattable(df, align = c("l", "r", "r"), list(
  `FABS` = color_tile("white", "orange"),
  `FR (%)` = color_bar("lightblue")
))
#show
table_03_fq