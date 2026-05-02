# =============================================================================
# ACTIVIDAD 3 - Métodos y Simulación Estadística · 20261
# Autor: Juan Alejandro Carrillo Jaimes
# Script 01: Análisis Exploratorio y Selección de Variable Predictora
# =============================================================================
# Propósito: Explorar los datos de MAT y POR, calcular correlaciones entre
# variables cuantitativas y G3, y seleccionar la mejor variable predictora
# para usar en el modelo de regresión lineal simple.
#
# NOTA: Las variables G1 y G2 se EXCLUYEN de las candidatas, siguiendo el
# criterio del ejemplo de clase (se busca una variable explicativa externa
# a las notas de período).
# =============================================================================


# -----------------------------------------------------------------------------
# 0. LIBRERÍAS
# -----------------------------------------------------------------------------
# Instala las que no tengas con: install.packages("nombre")
library(tidyverse)    # manipulación y visualización
library(corrplot)     # matriz de correlaciones
library(gridExtra)    # múltiples gráficos en un panel
library(moments)      # asimetría y curtosis (skewness, kurtosis)
library(nortest)      # prueba de normalidad Lilliefors


# -----------------------------------------------------------------------------
# 1. CARGA DE DATOS
# -----------------------------------------------------------------------------
# Los archivos student-mat.csv y student-por.csv deben estar en el directorio
# de trabajo. Verifica con getwd() y ajusta con setwd("ruta/carpeta") si es
# necesario.

mat <- read.csv("student-mat.csv", sep = ";", header = TRUE)
por <- read.csv("student-por.csv", sep = ";", header = TRUE)

cat("=== Dimensiones ===\n")
cat("MAT:", nrow(mat), "filas x", ncol(mat), "columnas\n")
cat("POR:", nrow(por), "filas x", ncol(por), "columnas\n\n")


# -----------------------------------------------------------------------------
# 2. VARIABLES CANDIDATAS (sin G1, G2, G3)
# -----------------------------------------------------------------------------
# Se excluyen G1 y G2 porque son también notas de período (variables respuesta
# intermedia), y G3 porque es la variable que queremos predecir.
# El objetivo es encontrar la variable EXTERNA con mayor poder explicativo.

candidatas <- c("age", "Medu", "Fedu", "traveltime", "studytime",
                "failures", "famrel", "freetime", "goout",
                "Dalc", "Walc", "health", "absences")

cat("Variables candidatas como predictoras:\n")
cat(paste(candidatas, collapse = ", "), "\n\n")


# -----------------------------------------------------------------------------
# 3. CORRELACIONES DE PEARSON CON G3
# -----------------------------------------------------------------------------

# Correlación de cada candidata con G3 (con signo)
corr_mat <- sapply(candidatas, function(v) cor(mat[[v]], mat$G3))
corr_por <- sapply(candidatas, function(v) cor(por[[v]], por$G3))

# Ordenar por valor absoluto de mayor a menor
corr_mat_ord <- sort(abs(corr_mat), decreasing = TRUE)
corr_por_ord <- sort(abs(corr_por), decreasing = TRUE)

cat("=== MAT - Correlaciones absolutas con G3 (ordenadas) ===\n")
print(round(corr_mat_ord, 4))

cat("\n=== POR - Correlaciones absolutas con G3 (ordenadas) ===\n")
print(round(corr_por_ord, 4))

cat("\n=== MAT - Correlaciones con signo ===\n")
print(round(sort(corr_mat, decreasing = TRUE), 4))

cat("\n=== POR - Correlaciones con signo ===\n")
print(round(sort(corr_por, decreasing = TRUE), 4))

# Top 3 predictores para cada materia
cat("\n=== TOP 3 PREDICTORES para G3 - MAT ===\n")
print(round(head(corr_mat_ord, 3), 4))

cat("\n=== TOP 3 PREDICTORES para G3 - POR ===\n")
print(round(head(corr_por_ord, 3), 4))


# -----------------------------------------------------------------------------
# 4. ESTADÍSTICAS DESCRIPTIVAS DE G3
# -----------------------------------------------------------------------------

desc_stat <- function(x, nombre) {
  cat("\n--- Estadísticas de G3 en", nombre, "---\n")
  cat("  N          :", length(x), "\n")
  cat("  Media      :", round(mean(x,     na.rm = TRUE), 3), "\n")
  cat("  Mediana    :", round(median(x,   na.rm = TRUE), 3), "\n")
  cat("  Desv. std  :", round(sd(x,       na.rm = TRUE), 3), "\n")
  cat("  Mínimo     :", min(x,  na.rm = TRUE), "\n")
  cat("  Q1         :", quantile(x, 0.25, na.rm = TRUE), "\n")
  cat("  Q3         :", quantile(x, 0.75, na.rm = TRUE), "\n")
  cat("  Máximo     :", max(x,  na.rm = TRUE), "\n")
  cat("  Asimetría  :", round(skewness(x, na.rm = TRUE), 3), "\n")
  cat("  Curtosis   :", round(kurtosis(x, na.rm = TRUE), 3), "\n")
}

desc_stat(mat$G3, "MAT")
desc_stat(por$G3, "POR")


# -----------------------------------------------------------------------------
# 5. DESCRIPTIVAS DE LAS VARIABLES CANDIDATAS
# -----------------------------------------------------------------------------

cat("\n\n=== Descriptivas de candidatas - MAT ===\n")
print(round(sapply(mat[, candidatas], function(x)
  c(Media = mean(x), SD = sd(x), Min = min(x), Max = max(x))), 3))

cat("\n=== Descriptivas de candidatas - POR ===\n")
print(round(sapply(por[, candidatas], function(x)
  c(Media = mean(x), SD = sd(x), Min = min(x), Max = max(x))), 3))


# -----------------------------------------------------------------------------
# 6. GRÁFICOS EXPLORATORIOS
# -----------------------------------------------------------------------------

# Paleta de colores institucional Javeriana
col_azul  <- "#2C5697"
col_amar  <- "#F8CD00"
col_gris  <- "#6c757d"
col_rojo  <- "#E24B4A"


# --- 6.1 Histogramas de G3 ---------------------------------------------------

p1 <- ggplot(mat, aes(x = G3)) +
  geom_histogram(binwidth = 1, fill = col_azul, color = "white", alpha = 0.87) +
  geom_vline(xintercept = mean(mat$G3), color = col_amar,
             linetype = "dashed", linewidth = 1) +
  annotate("text", x = mean(mat$G3) + 0.8, y = Inf,
           label = paste0("Media = ", round(mean(mat$G3), 1)),
           vjust = 2, color = col_amar, size = 3.5, fontface = "bold") +
  labs(title    = "Distribución de G3 — Matemáticas",
       subtitle = paste0("n = ", nrow(mat)),
       x = "Nota Final (G3)", y = "Frecuencia") +
  scale_x_continuous(breaks = 0:20) +
  theme_minimal(base_size = 12) +
  theme(plot.title    = element_text(color = col_azul, face = "bold"),
        plot.subtitle = element_text(color = col_gris))

p2 <- ggplot(por, aes(x = G3)) +
  geom_histogram(binwidth = 1, fill = col_gris, color = "white", alpha = 0.87) +
  geom_vline(xintercept = mean(por$G3), color = col_amar,
             linetype = "dashed", linewidth = 1) +
  annotate("text", x = mean(por$G3) + 0.8, y = Inf,
           label = paste0("Media = ", round(mean(por$G3), 1)),
           vjust = 2, color = col_amar, size = 3.5, fontface = "bold") +
  labs(title    = "Distribución de G3 — Portugués",
       subtitle = paste0("n = ", nrow(por)),
       x = "Nota Final (G3)", y = "Frecuencia") +
  scale_x_continuous(breaks = 0:20) +
  theme_minimal(base_size = 12) +
  theme(plot.title    = element_text(color = col_gris, face = "bold"),
        plot.subtitle = element_text(color = col_gris))

grid.arrange(p1, p2, ncol = 2,
             top = grid::textGrob(
               "Distribución de la Nota Final por Materia",
               gp = grid::gpar(fontface = "bold",
                               col = col_azul, fontsize = 14)))


# --- 6.2 Boxplot comparativo MAT vs POR -------------------------------------

df_box <- rbind(
  data.frame(G3 = mat$G3, Materia = "Matemáticas"),
  data.frame(G3 = por$G3, Materia = "Portugués")
)

ggplot(df_box, aes(x = Materia, y = G3, fill = Materia)) +
  geom_boxplot(alpha = 0.8, outlier.colour = col_rojo,
               outlier.shape = 16, outlier.size = 2) +
  scale_fill_manual(values = c("Matemáticas" = col_azul,
                               "Portugués"   = col_gris)) +
  labs(title    = "Distribución de la Nota Final por Materia",
       subtitle = "Los puntos rojos son valores atípicos",
       x = "", y = "Nota Final (G3)") +
  theme_minimal(base_size = 12) +
  theme(legend.position = "none",
        plot.title    = element_text(face = "bold", color = col_azul),
        plot.subtitle = element_text(color = col_gris))


# --- 6.3 Gráfico de barras: correlaciones con G3 ----------------------------

df_corr <- rbind(
  data.frame(variable = names(corr_mat),
             r        = as.numeric(corr_mat),
             materia  = "Matemáticas"),
  data.frame(variable = names(corr_por),
             r        = as.numeric(corr_por),
             materia  = "Portugués")
)

ggplot(df_corr, aes(x = reorder(variable, abs(r)), y = r,
                    fill = ifelse(r >= 0, "Positiva", "Negativa"))) +
  geom_col(alpha = 0.85) +
  geom_hline(yintercept = 0, color = "black", linewidth = 0.4) +
  coord_flip() +
  scale_fill_manual(values = c("Positiva" = col_azul, "Negativa" = col_rojo),
                    name   = "Dirección") +
  facet_wrap(~ materia) +
  labs(title    = "Correlación de Pearson con G3",
       subtitle = "Variables candidatas (sin G1 ni G2)",
       x = "", y = "r de Pearson") +
  theme_minimal(base_size = 12) +
  theme(plot.title      = element_text(face = "bold", color = col_azul),
        plot.subtitle   = element_text(color = col_gris),
        legend.position = "bottom")


# --- 6.4 Matriz de correlaciones — MAT (candidatas + G3) --------------------

vars_corr_mat <- cor(mat[, c(candidatas, "G3")], use = "complete.obs")

corrplot(vars_corr_mat,
         method      = "color",
         type        = "upper",
         tl.col      = "black",
         tl.srt      = 45,
         tl.cex      = 0.78,
         col         = colorRampPalette(c(col_rojo, "white", col_azul))(200),
         addCoef.col = "black",
         number.cex  = 0.55,
         title       = "Matriz de correlaciones — Matemáticas",
         mar         = c(0, 0, 1.5, 0))


# --- 6.5 Matriz de correlaciones — POR (candidatas + G3) --------------------

vars_corr_por <- cor(por[, c(candidatas, "G3")], use = "complete.obs")

corrplot(vars_corr_por,
         method      = "color",
         type        = "upper",
         tl.col      = "black",
         tl.srt      = 45,
         tl.cex      = 0.78,
         col         = colorRampPalette(c(col_rojo, "white", col_azul))(200),
         addCoef.col = "black",
         number.cex  = 0.55,
         title       = "Matriz de correlaciones — Portugués",
         mar         = c(0, 0, 1.5, 0))


# --- 6.6 Dispersión G3 vs mejor predictora (automático) ---------------------

X_MAT <- names(corr_mat_ord)[1]   # mejor predictora MAT
X_POR <- names(corr_por_ord)[1]   # mejor predictora POR

cat("\n>> Predictora seleccionada MAT:", X_MAT,
    " (|r| =", round(corr_mat_ord[1], 4), ")\n")
cat(">> Predictora seleccionada POR:", X_POR,
    " (|r| =", round(corr_por_ord[1], 4), ")\n")

p_mat <- ggplot(mat, aes_string(x = X_MAT, y = "G3")) +
  geom_point(color = col_azul, alpha = 0.45, size = 2) +
  geom_smooth(method = "lm", color = col_amar, se = TRUE,
              fill = col_amar, alpha = 0.15) +
  labs(title    = paste0("MAT: G3 vs ", X_MAT),
       subtitle = paste0("r = ", round(corr_mat[X_MAT], 4)),
       x = X_MAT, y = "Nota Final (G3)") +
  theme_minimal(base_size = 12) +
  theme(plot.title    = element_text(color = col_azul, face = "bold"),
        plot.subtitle = element_text(color = col_gris))

p_por <- ggplot(por, aes_string(x = X_POR, y = "G3")) +
  geom_point(color = col_gris, alpha = 0.45, size = 2) +
  geom_smooth(method = "lm", color = col_amar, se = TRUE,
              fill = col_amar, alpha = 0.15) +
  labs(title    = paste0("POR: G3 vs ", X_POR),
       subtitle = paste0("r = ", round(corr_por[X_POR], 4)),
       x = X_POR, y = "Nota Final (G3)") +
  theme_minimal(base_size = 12) +
  theme(plot.title    = element_text(color = col_gris, face = "bold"),
        plot.subtitle = element_text(color = col_gris))

grid.arrange(p_mat, p_por, ncol = 2,
             top = grid::textGrob(
               "Dispersión G3 vs mejor predictora por materia",
               gp = grid::gpar(fontface = "bold",
                               col = col_azul, fontsize = 13)))


# --- 6.7 Dispersión G3 vs 2da mejor predictora ------------------------------

X_MAT2 <- names(corr_mat_ord)[2]
X_POR2 <- names(corr_por_ord)[2]

p_mat2 <- ggplot(mat, aes_string(x = X_MAT2, y = "G3")) +
  geom_point(color = col_azul, alpha = 0.45, size = 2) +
  geom_smooth(method = "lm", color = col_rojo, se = TRUE,
              fill = col_rojo, alpha = 0.15) +
  labs(title    = paste0("MAT: G3 vs ", X_MAT2, "  (2da)"),
       subtitle = paste0("r = ", round(corr_mat[X_MAT2], 4)),
       x = X_MAT2, y = "Nota Final (G3)") +
  theme_minimal(base_size = 12) +
  theme(plot.title    = element_text(color = col_azul, face = "bold"),
        plot.subtitle = element_text(color = col_gris))

p_por2 <- ggplot(por, aes_string(x = X_POR2, y = "G3")) +
  geom_point(color = col_gris, alpha = 0.45, size = 2) +
  geom_smooth(method = "lm", color = col_rojo, se = TRUE,
              fill = col_rojo, alpha = 0.15) +
  labs(title    = paste0("POR: G3 vs ", X_POR2, "  (2da)"),
       subtitle = paste0("r = ", round(corr_por[X_POR2], 4)),
       x = X_POR2, y = "Nota Final (G3)") +
  theme_minimal(base_size = 12) +
  theme(plot.title    = element_text(color = col_gris, face = "bold"),
        plot.subtitle = element_text(color = col_gris))

grid.arrange(p_mat2, p_por2, ncol = 2,
             top = grid::textGrob(
               "Dispersión G3 vs segunda mejor predictora",
               gp = grid::gpar(fontface = "bold",
                               col = col_azul, fontsize = 13)))


# -----------------------------------------------------------------------------
# 7. RESUMEN FINAL — PEGAR ESTA SALIDA EN EL CHAT
# -----------------------------------------------------------------------------

cat("\n\n")
cat("=============================================================\n")
cat("  RESUMEN FINAL — SELECCIÓN DE VARIABLE PREDICTORA\n")
cat("=============================================================\n")
cat("\n  MAT — Top 3 candidatas:\n")
for (i in 1:3) {
  cat(sprintf("    %d. %-12s  |r| = %.4f  (r = %+.4f)\n",
              i,
              names(corr_mat_ord)[i],
              corr_mat_ord[i],
              corr_mat[names(corr_mat_ord)[i]]))
}
cat("\n  POR — Top 3 candidatas:\n")
for (i in 1:3) {
  cat(sprintf("    %d. %-12s  |r| = %.4f  (r = %+.4f)\n",
              i,
              names(corr_por_ord)[i],
              corr_por_ord[i],
              corr_por[names(corr_por_ord)[i]]))
}
cat("\n  >> Predictora seleccionada MAT:", X_MAT, "\n")
cat("  >> Predictora seleccionada POR:", X_POR, "\n")
cat("=============================================================\n")