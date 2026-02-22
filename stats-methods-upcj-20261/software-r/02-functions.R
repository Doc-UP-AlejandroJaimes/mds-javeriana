# SAMPLE FUNCTIONS
is_prime_number <- function(number) {
  
  if (number < 2) return(FALSE)
  if (number == 2) return(TRUE)
  
  count_prime <- 2
  for (i in seq(2, number - 1)) {
      if (number %% i == 0) {
        count_prime <- count_prime + 1
      }
  }
  return(ifelse(count_prime == 2, TRUE, FALSE))
}

is_prime_number(2)
is_prime_number(4)




# array FUNCTIONs
arr <- 2:12

for (number in arr) {
  if (is_prime_number(number)) {
    print(paste(number, "is prime"))
  } else {
    print(paste(number, "is not prime"))
  }
}

sum_divide <-function(arr) {
  first_element = arr[1]
  last_element = arr[length(arr)]
  sum_elements = first_element + last_element
  return( sum_elements / 4)
}

arr_2 <- c(5, 8, 12, 20)
sum_divide(arr_2)