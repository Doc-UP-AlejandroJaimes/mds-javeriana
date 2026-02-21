library(ggplot2)
library(summarytools)


# Array equivalent to numpy array
x= c(51.35, 49.88, 49.35, 51.21, 51.24, 45.75, 48.42, 47.29, 48.98,
     50.06, 50.94, 45.41, 55.69, 48.90, 56.00, 44.72, 56.89, 46.61,
     53.25, 48.46, 49.74, 45.03, 63.02, 50.96, 50.43, 51.19, 53.45,
     52.10, 49.61, 45.89, 49.76, 42.30, 53.48, 54.71, 53.48, 56.67,
     44.38, 51.18, 51.06, 54.96, 64.44, 51.85, 45.33, 62.74, 43.84,
     51.32, 53.70, 51.00, 52.86, 43.06, 43.63, 51.24, 52.84, 49.19,
     49.56, 49.56, 51.49, 55.31, 46.74, 47.62, 51.85, 58.90, 50.80,
     43.39, 48.54, 52.72, 44.82, 52.49, 58.43, 52.91)

# Create DataFrame with names of athletes
atlethes_names <-c("Juan","Luis","Pedro","Fernanda","Antonia",
                   "Sara","Laura","Daniela","SantaMaria","Carlos")


df <- data.frame(
  names=rep(sample(atlethes_names, 3, replace=TRUE),70),
  values=x
)

df$names


# Describe dataset
descr(x)


# Plot graphic
plot <- ggplot(df, aes(x = values))
plot <- plot + geom_histogram(aes(y=..density..), 
                              color="black", 
                              fill = "#034A96", 
                              binwidth = 5, 
                              alpha = 0.5
                              ) + labs(title = "Tiempo de carrera  K10.5-2022") + ylab("densidad") + xlab("minutos")
plot