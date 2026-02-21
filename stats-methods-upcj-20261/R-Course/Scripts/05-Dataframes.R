library(magrittr)
library(knitr)
library(kableExtra)

# Dataframes

Nombre <-c("Diego Castro", "Diana Sanchéz", "Julián Diaz", "Simón Giraldo")
Edad <-c(27,39,22,48)
Genero <-c("Maculino", "Femenino","Masculino","Masculino")
Salario <-c(62100,47350,18250,76600)
Cargo <-c("Directivo","Técnico","Administrativo","Directivo")

df_context <- data.frame(
  Nombre,
  Edad,
  Genero,
  Salario,
  Cargo
)


df_context %>%
  kable("html") %>%
  kable_styling("striped", full_width = FALSE)