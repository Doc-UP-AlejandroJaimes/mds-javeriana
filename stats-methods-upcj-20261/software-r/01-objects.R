# VECTOR

# Un vector en R es una estructura de datos unidimensional que almacena una 
# colección de elementos del mismo tipo (por ejemplo, todos numéricos, todos caracteres, todos lógicos, etc.). Los vectores constituyen la unidad básica de almacenamiento en R y son esenciales para manipular datos de forma eficiente.
# 
# A continuación se presenta un ejemplo que ilustra cómo crear vectores 
# y cómo verificar su tipo de datos asociado:

# Creación de vectores numéricos y de caracteres

# El vector 'a' contiene una secuencia de números enteros del 1 al 9
a <- c(1, 2, 3, 4, 5, 6, 7, 8, 9)
print(a)

# El vector 'b' contiene una secuencia de caracteres, desde "a" hasta "i"
b <- c("a", "b", "c", "d", "e", "f", "g", "h", "i")
print(b)

# Verificación del tipo de datos de cada vector
# La función 'class()' devuelve el tipo de dato de los objetos 'a' y 'b'
class(a)
class(b)


# FACTOR

# Un factor es un objeto diseñado para representar datos categóricos mediante 
# niveles o categorías específicas. Este tipo de estructura resulta especialmente 
# útil en el análisis y la manipulación de datos que requieren 
# clasificaciones discretas. 
# A continuación, se presenta un ejemplo de cómo convertir un vector denominado 
# b en factor y, posteriormente, verificar su clase:

# La función factor() convierte el vector 'b' en un objeto factor,
# el cual sirve para representar datos categóricos en R.
factor_sample <-c("ROJO","ROJO","BLANCO","AMARILLO","VERDE","VERDE")
b_factor <- factor(b)
colors_factor <-factor(factor_sample)
# Se muestra la clase del objeto recién creado. El resultado esperado es "factor".
class(b_factor)

# ARREGLO

# Un arreglo es una estructura de datos multidimensional 
# que almacena elementos de un mismo tipo. A continuación, 
# se muestra un ejemplo de la creación de un arreglo llamado ab, 
# con dimensiones de 2×3×4, y la verificación de su clase:
# Creación de un arreglo con los números del 1 al 24,
# especificando sus dimensiones como 2×3×4.
ab = array(1:24, dim = c(2, 3, 4))
print(ab)

# Verificación la clase del objeto 'ab'.
# El resultado esperado es "array".
class(ab)

# MATRIZ

# Una matriz es un arreglo bidimensional que contiene elementos de un mismo tipo. 
# A continuación, se presenta un ejemplo de cómo crear una matriz a partir 
# de un vector denominado a, especificando el número de filas y 
# el orden de llenado de datos. Luego, se muestra la matriz resultante 
# y se verifica su clase.

# Creación de un vector 'a' con los valores del 1 al 9.
a <- c(1, 2, 3, 4, 5, 6, 7, 8, 9)

# Convresión el vector 'a' en una matriz 'm' con 3 filas,
# rellenando los valores por filas (byrow = TRUE).
m = matrix(a, nrow = 3, byrow = TRUE)

# Visualizar la matriz resultante.
print(m)

# Conversión el vector 'a' en una matriz 'p' con 3 filas,
# rellenando los valores por columnas (byrow = FALSE).
p = matrix(a, nrow = 3, byrow = FALSE)

# Visualizar la matriz resultante.
print(m)
print(p)


# Verificación de la clase del objeto 'm'.
# El resultado esperado es "matrix".
class(m)
class(p)

# DATAFRAME

# Un data.frame es una estructura de datos en R con formato tabular, es decir, 
# organizada en filas y columnas. Cada columna puede contener datos 
# de un tipo distinto (numéricos, caracteres, lógicos, factores, etc.), 
# mientras que cada fila representa una observación o registro.
# 
# Esta flexibilidad lo convierte en una de las estructuras más utilizadas 
# en análisis de datos, ya que se asemeja a una hoja 
# de cálculo o una tabla de base de datos.

# Creación de vectores numéricos y de caracteres
# El vector 'a' contiene una secuencia de números enteros del 1 al 9.
a <- c(1, 2, 3, 4, 5, 6, 7, 8, 9)

# El vector 'b' contiene una secuencia de caracteres desde 'a' hasta 'i'.
b <- c("a", "b", "c", "d", "e", "f", "g", "h", "i")

# Creación de un data frame a partir de los vectores 'a' y 'b'.
df = data.frame(a, b)

# Visualizar el contenido del data frame.
df

# Verificación la clase del objeto 'df'.
class(df)

# Cuando se importa una base de datos desde un archivo externo, como un .csv, 
# .txt o una hoja de Excel, el resultado por defecto suele ser un objeto de 
# clase data.frame. Esto permite manipular, visualizar y analizar la información 
# de forma eficiente utilizando funciones como summary(), head(), subset(), 
# entre muchas otras.

# Lectura de datos
file <- "https://raw.githubusercontent.com/Centromagis/metodosySIM3_V2/refs/heads/main/datos_MetySim/dat_pueblos.txt"
datos <- read.table(file = file, header = TRUE)

class(datos)
head(datos,2)

# TS: Temporal Series

# El objeto ts se emplea para representar datos secuenciales en el tiempo es 
# la serie temporal o serie de tiempo. Este tipo de objeto facilita el análisis 
# y la modelación de fenómenos que evolucionan a lo largo de una dimensión 
# temporal. A continuación, se presenta un ejemplo en el que se crea una serie 
# de tiempo a partir de un vector x,
# indicando el año de inicio (start) y la frecuencia de muestreo (frequency).

# Creación del vector 'x' con valores enteros que van del 1 al 24.
x = 1:24

# GeneramosSe crea una serie temporal 't' a partir del vector 'x',
# especificando el año de inicio como 2000 y la frecuencia de 1,
# lo que indica una observación por periodo (p. ej., por año).
t = ts(x, start = 2000, frequency = 1)

# Visualizando el contenido de la serie temporal.
t

# Verificando la clase del objeto 't'.
# El resultado esperado es "ts".
class(t)


#LISTA

# Una lista es una colección ordenada y flexible que puede contener elementos 
# de distintos tipos. A continuación, se muestra un ejemplo de cómo 
# crear una lista denominada data_lista, así como la visualización 
# de su contenido y la verificación de su clase:


Sys.setlocale("LC_ALL", "es_ES.UTF-8")

data_lista = list(
  nombre = c("Juan", "Ana", "Harold", "Oscar", "Isabel"),
  edad = c(23,43,25,30,21),
  ciudad = c("Cali", "Bogotá", "Medellín", "Cartagena")
)
data_lista
class(data_lista)
data_lista$nombre
