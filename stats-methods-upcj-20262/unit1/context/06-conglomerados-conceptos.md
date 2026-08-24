# 06 · Análisis de Conglomerados — Conceptos

**Curso:** Modelos Estadísticos para la toma de decisiones
**Fuente original:** `analiconglomerados01.txt` — "Análisis De conglomerados - 01"

---

## Introducción

El análisis de conglomerados, también conocido como clustering, es un método estadístico usado para agrupar objetos similares en función de sus características. Mediante este análisis se logra identificar grupos muy parecidos (homogéneos) de objetos o individuos. Dentro de cada grupo los objetos son más similares entre sí que con los de otros grupos. El análisis de conglomerados implica la selección de un conjunto de variables para medir las características de los objetos o individuos, y luego aplicar un algoritmo de agrupamiento para clasificarlos en conglomerados. Los algoritmos de agrupamiento utilizados pueden ser jerárquicos o no jerárquicos, dependiendo de si los grupos se construyen de forma iterativa a partir de subgrupos más pequeños.

## Supuestos y requisitos

El análisis de conglomerados se basa en calcular distancias entre los individuos a partir de la matriz de datos $X$. Una vez encontrados los conglomerados o grupos, se procede a representarlos en un plano factorial. Supone por tanto el conocimiento previo de la presencia de conglomerados, o por lo menos sospecha de presencia de grupos, aunque no se tenga claramente una distribución a priori.

## Conceptos asociados

### Estandarización

Debido a las diferencias en las escalas de las variables empleadas en el análisis, es necesario colocarlas en una sola escala, para lo cual a cada variable se le resta el valor de su media y el resultado se divide por su desviación estándar. El producto de esta transformación es una variable con media 0 y varianza 1.

$$z = \frac{x - \bar{x}}{\sigma}$$

### Distancia

La distancia entre dos observaciones es una medida de sus diferencias. El AC (Análisis de Conglomerados) emplea varias medidas de distancias como:

**Distancia euclidiana**

$$D_{ij} = \sqrt{\sum_{p=1}^{k}(x_{ip}-x_{jp})^2}$$

**Distancia de Manhattan**

$$D_{ij} = \sum_{p=1}^{k}\left|x_{ip}-x_{jp}\right|$$

**Distancia de Minkowski**

$$D_{ij} = \left[\left|x_{ip}-x_{jp}\right|^{n}\right]^{1/n}$$

### Agrupamiento

Mediante este procedimiento son asignadas las observaciones a los grupos o conglomerados.

### Criterios de calidad

Utilizados para evaluar la bondad del agrupamiento resultante del análisis. Algunos de los criterios más comunes incluyen:

- **Suma de cuadrados dentro del cluster ($SSC$):** mide cuánto varían las observaciones dentro de cada conglomerado, y se mide sumando las distancias entre cada observación y el centroide de su conglomerado.

- **Suma de cuadrados entre clusters ($SSB$):** mide la variabilidad entre los conglomerados, permitiendo valorar la calidad del agrupamiento.

- **Índice de Rand ajustado:** corresponde a un indicador para evaluar la calidad del agrupamiento. Este índice varía entre $-1$ y $1$. Valores cercanos a $1$ indican alta similitud entre los grupos, mientras que valores cercanos a $-1$ indican que los grupos o conglomerados formados son muy diferentes. Valores cercanos a $0$ indican que los agrupamientos pueden ser producto del azar.

### Centros del conglomerado

Es la media de los valores de las variables de todos los objetos o casos de cada uno de los conglomerados.

### Dendograma

Corresponde a la representación gráfica de los resultados obtenidos en el AC, en un plano donde el eje vertical indica las distancias en las que se unen o separan los conglomerados y en el eje horizontal los objetos o individuos.

### Matriz de coeficientes de semejanza y distancias

Corresponde a una matriz diagonal inferior que contiene las distancias entre pares de objetos o casos.

---

## Modelo

Existen dos tipos de clasificación automática: los métodos no jerárquicos, los cuales se basan en encontrar la mejor partición del conjunto de individuos en $q$ clases, en donde sus centros de gravedad se eligen en un inicio de forma aleatoria. Por otra parte están los métodos jerárquicos, en los cuales se construye un dendograma en el cual se forman los grupos de individuos más parecidos; esto permite determinar el número de clases que se usarán en el método no jerárquico.

Mediante el análisis de conglomerados se desea clasificar a los distintos individuos u observaciones en grupos muy homogéneos, pero heterogéneos entre ellos. Para realizar este objetivo se utilizan métricas que permiten calcular el grado de asociación (similitud o disimilitud) entre dos observaciones, dentro de las más usadas está la distancia euclidiana entre los dos puntos, la cual está dada por:

$$d(x_i, x_j) = \sqrt{\sum_{p=1}^{m}(x_{ip}-x_{jp})^2}$$

En donde $x_i$ y $x_j$ son individuos con $m$ variables. De esta forma podremos obtener los dos primeros individuos que más se parezcan entre sí, los cuales formarán el primer grupo. Sean entonces $h = \{x_i, x_j\}$ un grupo y $x_k$ un individuo, con los que se puede calcular la distancia entre el grupo y el individuo de la forma:

$$d(h, x_k) = \min\{d(x_i,x_k),\, d(x_j,x_k)\}$$

Además del método descrito, hay otras formas de medir la proximidad entre elementos, como pueden ser el salto mínimo (*single linkage*), salto máximo, salto promedio y agregación de Ward.
