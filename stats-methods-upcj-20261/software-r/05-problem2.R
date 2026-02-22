# Library
library(paqueteMETODOS)
library(summarytools)
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

# step 6. Filter by groups
# Filtrar grupos
veteranos_a <- df[df$sex == "Hombre" & df$categoria == "3. Veteranos A", ]
abierta_mujeres <- df[df$sex == "Mujer" & df$categoria == "2. Abierta", ]

head(veteranos_a)
head(abierta_mujeres)

# Create Groups
groups_compare <- list( group_Veteranos_a = veteranos_a$timerun_min, 
                        group_abierta_mujeres = abierta_mujeres$timerun_min 
                  )

means_compare <- sapply(groups_compare, mean)
means_compare
