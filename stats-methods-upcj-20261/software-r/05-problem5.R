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

# Step 7. Show differences
summary(df) # Summary by variable, show calss, mean and quartiles
descr(df) # Describe statistical descript about numeric columns
psych::describe(df) # Describe more complete with skew kurtosis and se by each variable
