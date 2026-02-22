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
# Step 6. Center Indicators
# MEAN
mean(df$timerun_min)
# MEDIAN
median(df$timerun_min)
# MEAN TRUNCATED
mean(df$timerun_min, trim=10/100)

# MODE
moda <- function(x) {
  as.numeric(names(sort(table(x), decreasing=TRUE)[1]))
}
moda(df$timerun_min)

#  RANGE
range_timerun <- max(df$timerun_min) - min(df$timerun_min)
range_timerun