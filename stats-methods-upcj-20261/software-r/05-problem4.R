# Library
library(paqueteMETODOS)
library(summarytools)
library(ggplot2)
# Step 1. Load Data
data("CarreraLuz22")

# Step 2. Load in DataFrame
df <- CarreraLuz22

# Step3. Show Dataframe
head(df,5)
nrow(df)
ncol(df)
dim(df)

# Step 4. Function to convert time_run_sg to time_run_min
sec_to_mins <-function(timerun) {
  return (timerun / 60)
}

df$timerun_min <-sec_to_mins(df$timerun)
head(df,5)

# Step 5. Describe dataset
descr(df)

# step 6. Convert to factor each category
df$categoria <- as.factor(df$categoria)
df$sex <- as.factor(df$sex)
levels(df$categoria)
levels(df$sex)

# Step 7. Agregate data
resumen_categorias <- aggregate(timerun_min ~ categoria + sex, 
                                data = df, FUN = mean)
resumen_categorias
# Step 8. Plot data
ggplot(resumen_categorias, aes(x = categoria, y = timerun_min, fill = sex)) +
  geom_bar(stat = "identity", position = "dodge") +
  scale_fill_manual(values = c("steelblue", "salmon")) +
  labs(title = "Tiempo promedio por categoría y sexo",
       x = "Categoría", 
       y = "Tiempo promedio (min)",
       fill = "Sexo") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))