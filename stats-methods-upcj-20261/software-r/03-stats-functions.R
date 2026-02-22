# FUNCTIONS: apply, lapply and sapply


# APPLY
# A continuación, se muestra cómo utilizar la función apply para:
#   
# Recorrer las filas de una matriz.
# 
# Calcular la suma de los elementos en cada fila.
# 
# Retornar un vector con las sumas correspondientes.

# Definición de la matriz
mi_matriz <- matrix(1:9, nrow = 3, byrow = TRUE) 

# Uso de apply para sumar los elementos de cada fila 
suma_filas <- apply(mi_matriz, MARGIN = 1, FUN = sum)
suma_filas
# 
# En este ejemplo se muestra cómo utilizar la función apply posterior a la creación de una función:
#   
#   Crear una función personalizada que:
#   
#   Toma el primer elemento de un conjunto de valores y lo multiplica por 2.
# 
# Suma este resultado con el promedio de todos los elementos.
# 
# Luego divide el total entre 4.
# 
# Aplicar esta función a las filas de un data frame que contiene solo valores numéricos.
# Definición del data frame 
df <- data.frame( A = c(2, 4, 6), B = c(8, 10, 12), C = c(1, 3, 5) ) 

# Definición de la función personalizada 
mi_funcion <- function(x) { 
  primer_elemento <- x[1] 
  promedio <- mean(x) 
  resultado <- (2 * primer_elemento + promedio) / 4 
  return(resultado) 
  } 

# Uso de apply para aplicar la función a las filas 
resultado_filas <- apply(df, MARGIN = 1, FUN = mi_funcion)
resultado_filas


# LAPPLY
# En este ejemplo se muestra cómo utilizar la función lapply posterior 
# a la creación de una función:
#   
# Crear una función personalizada que:
#   
# Reciba un vector numérico.
# 
# Calcule el cuadrado de cada elemento del vector.
# 
# Devuelva el vector de cuadrados.
# 
# Aplicar esta función a cada elemento de una lista que contiene vectores numéricos.

# Definición de la lista 
mi_lista <- list(grupo1 = c(1, 2, 3), grupo2 = c(4, 5), grupo3 = c(6, 7, 8, 9)) 
mi_lista

# Definición de la función personalizada 
cuadrados_vector <- function(x) { 
  return(x^2)
} 

# Uso de lapply para aplicar la función a cada elemento 
resultado_cuadrados <- lapply(mi_lista, cuadrados_vector) 
resultado_cuadrados


# SAPPLY
# A continuación, se muestra cómo utilizar la función sapply para:
#   
# Recorrer los elementos de una lista numérica.
# 
# Calcular el promedio (media) de cada elemento.
# 
# Retornar un vector con los promedios correspondientes.

# Definición de la lista 
mi_lista <- list(grupo1 = c(2, 4, 6), 
                 grupo2 = c(10, 12, 14), 
                 grupo3 = c(1, 3, 5, 7)) 
mi_lista
# Uso de sapply para calcular la media de cada 
medias <- sapply(mi_lista, mean)
medias


# En este ejemplo se muestra cómo utilizar la función sapply 
# posterior a la creación de una función:
#   
# Crear una función personalizada que:
#   
#  Calcula el máximo de un conjunto de valores.
# 
# Lo multiplica por el número de elementos del vector.
# 
# Luego divide este producto entre la varianza de los datos.
# 
# Aplicar esta función a los elementos de una lista que contiene 
# solo vectores numéricos.

# Definición de la lista 
mi_lista <- list( grupo1 = c(2, 4, 6), 
                  grupo2 = c(5, 7, 9, 11), 
                  grupo3 = c(1, 3)) 

# Definición de la función personalizada 
mi_funcion <- function(x) { 
  maximo <- max(x) 
  cantidad <- length(x) 
  varianza <- var(x) 
  resultado <- (maximo * cantidad) / varianza 
  return(resultado) 
} 

# Uso de sapply para aplicar la función a cada grupo 
resultado_lista <- sapply(mi_lista, mi_funcion)
resultado_lista