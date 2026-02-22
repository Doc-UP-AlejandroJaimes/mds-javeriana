# Library
library(paqueteMETODOS)
library(summarytools)
library(moments)
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

# step 6. Filter by womens
womens <- df[df$sex == "Mujer", ]
head(womens)

# Step 7. indicators
mean(womens$edad)
median(womens$edad)

# Step 8. Check skewness
skewness(womens$edad)
# = 0 → simétrica
# > 0 → asimetría positiva (cola derecha)
# < 0 → asimetría negativa (cola izquierda)
hist(womens$edad, main="Distribución de edades - Mujeres", 
     xlab="Edad", col="lightblue")
boxplot(womens$edad, main="Boxplot edades - Mujeres", col="lightblue")