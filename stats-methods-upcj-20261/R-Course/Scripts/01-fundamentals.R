# Comments in R are same that in Python

# Basic operations

age <- 2026 - 2000
pow <- 2^8
mod_opr <- 10 %% 2
name <- "Alejandro"

# Data types

## numeric, integer, character, logical, factor (categorical), N/A

class(age)
class(name)

## conversion data types
str_number <- "43.25"
float_number <- as.numeric(str_number)

# data structures

## arays
ages <-c(10, 25, 26, 29, 30, 12)
names <-c("Patrick", "Jhonny", "Isa", "Sara", "Alejo", "Gislaine")
status <-c(TRUE, FALSE, FALSE, TRUE, TRUE, TRUE)
salaries <-c(123300.89, 424440.89, 12123.113, 98758.526, 244241.89, 789.589)
### arrays operations

### sum, multiply and filter
ages + 5
ages * 2
ages[ages > 25]

# DataFrames
customers <- data.frame(
  names,
  ages,
  salaries,
  status
)

## Explore dataframe
head(customers, 2)
tail(customers, 3)
str(customers) # data types and structures
dim(customers) # shape
nrow(customers) # number of rows
ncol(customers) # number of cols
names(customers) # columns

## Accesing
customers$names # acces to column
customers[1:2, "ages"] # equivalent to iloc



