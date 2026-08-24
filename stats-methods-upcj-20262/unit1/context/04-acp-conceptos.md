# 04 · Análisis de Componentes Principales — Conceptos

**Curso:** Modelos Estadísticos para la toma de decisiones
**Fuente original:** `acp01.txt` — "ACP - 01 / Análisis de Componentes Principales"

---

## Introducción

Este análisis consiste en describir la variación producida por las observaciones de $p$ variables aleatorias, mediante un conjunto de nuevas variables que están correlacionadas entre sí, denominadas componentes y que están conformadas por combinación lineal de las variables originales.

Se utiliza como complemento de los análisis descriptivos y para contribución en modelos predictivos, reduciendo el número de variables empleadas en el modelo.

Las nuevas variables (llamadas componentes principales) se obtienen en orden de contribución a la variabilidad total de los datos, de tal forma que el primer componente describe la mayor cantidad de la variación total del conjunto de variables originales. El segundo componente principal se elige de tal forma que explique la mayor cantidad de la variación total del conjunto de datos que resta sin explicar por el primer componente, bajo la condición de ser independiente de la primera componente, y así sucesivamente.

---

## Conceptos

### Matriz de datos

Los datos conforman una matriz de dimensión $n \times p$ que contiene los datos originales, donde $n$ corresponde al número de observaciones y $p$ el número de variables.

### Matriz de Varianzas-Covarianzas

Matriz cuadrada de dimensión $p \times p$ que contiene las covarianzas entre pares de variables $Cov[X_i, X_j]$ y su diagonal está conformada por las varianzas de las variables $V[X_i]$.

### Autovalores y Autovectores

A partir de la matriz de varianza-covarianzas son calculados sus valores propios, que representan la cantidad de la varianza de la data explicada por cada componente principal, mientras que los vectores propios de la misma matriz indican la dirección y fuerza de la relación entre las variables y los componentes principales.

Con ellos se determina el porcentaje de la varianza de los datos que es explicado por cada uno de los componentes principales, los cuales tienen como condición la ortogonalidad entre ellos. Estadísticamente significa que son independientes unos de otros.

### Varianza explicada

Indica la cantidad de varianza en los datos originales que es explicada por cada componente principal. El total de la varianza explicada corresponde al 100% y abarca toda la varianza total de los datos originales.

Estos valores nos permiten evaluar la relevancia de cada uno de los componentes principales.

### Carga de las variables

Indica la contribución de cada variable a cada componente principal. Dependiendo su valor puede sugerir un nombre para el componente que facilite la interpretación de los resultados obtenidos. Es decir, se trata de los diferentes pesos que tiene cada variable original como una combinación lineal.

### Gráfico de dispersión

Representación visual de los datos transformados (componentes principales) en un nuevo espacio, por lo general de $\mathbb{R}^2$. Este gráfico permite identificar patrones o agrupaciones en los datos que pueden no haber sido evidentes en el espacio original de las variables.

---

## Notación de los componentes

Las componentes se pueden representar por $CP_1$, $CP_2$, $CP_3$, … construidas a partir de un conjunto de $p$ variables, de forma que:

$$V[CP_1] > V[CP_2] > V[CP_3] > \cdots > V[CP_p]$$

y

$$Cor[CP_i, CP_j] = 0 \quad \text{para todo par de componentes } i \neq j$$

El objetivo principal del ACP es poder ver si las dos o tres primeras componentes explican la mayor parte de la variación de las $p$ variables iniciales. Si es así, se pueden considerar estas dos componentes, reduciendo la dimensión de los datos a $\mathbb{R}^2$ y considerar su representación gráfica en el plano cartesiano.

### Supuesto

Las $p$ variables son una combinación lineal de una base que se desea encontrar.

---

## Los componentes principales (derivación matemática)

El primer componente tiene la forma:

$$CP_1 = \beta_{11}X_1 + \beta_{12}X_2 + \cdots + \beta_{1p}X_p = \sum_{i=1}^{p}\beta_{1i}X_i = b_1'X$$

Donde $b' = (\beta_{11}, \beta_{12}, \dots, \beta_{1p})$ es el vector de coeficientes a estimar y $X' = (X_1, X_2, \dots, X_p)$ el vector de variables que conforma la data.

Para determinar la porción de la varianza total de la data explicada por el componente se define $\Sigma$, la matriz de Varianzas-covarianzas, que está conformada por las varianzas de las variables originales en su diagonal principal y por fuera de ellas las covarianzas entre pares de variables.

$$\Sigma = \begin{pmatrix}
\sigma_1^2 & \sigma_{12} & \cdots & \sigma_{1p} \\
\sigma_{21} & \sigma_2^2 & \cdots & \sigma_{2p} \\
\vdots & \vdots & \ddots & \vdots \\
\sigma_{p1} & \sigma_{p2} & \cdots & \sigma_p^2
\end{pmatrix}$$

Entonces la varianza del primer componente será:

$$V[CP_1] = V[b_1'X] = b_1'\,\Sigma\, b_1$$

Bajo la restricción:

$$\beta_{11}^2 + \beta_{12}^2 + \cdots + \beta_{1p}^2 = b_1'b_1 = 1$$

La solución a este sistema se obtiene mediante el método matemático **Multiplicadores de Lagrange**, que maximiza el valor $\lambda_1$ para la siguiente función:

$$b_1'\,\Sigma\, b_1 - \lambda_1(b_1'b_1 - 1)$$

Dando como resultado:

$$CP_1 = b_1'X$$

El segundo componente estará determinado por una segunda ecuación de Lagrange, con la que se obtiene:

$$CP_2 = b_2'X$$

La varianza total de las $p$ variables está dada por:

$$\sum_{i=1}^{p}V[X_i] = \sum_{i=1}^{p}V[CP_i] = \sum_{i=1}^{p}\lambda_i$$

De tal forma que la contribución total por cada componente se estima como:

$$\frac{\lambda_i}{\sum_{i=1}^{p}\lambda_i}$$

Ahora, la contribución de los primeros tres componentes estará dada por:

$$\frac{\lambda_1 + \lambda_2 + \lambda_3}{\sum_{i=1}^{p}\lambda_i}$$

---

## Interpretación gráfica

Si los dos componentes principales explican un porcentaje grande de los datos, nos permite representar los registros de la data en un plano cartesiano, pudiendo de esta forma identificar relaciones y patrones en los datos.

Para darle sentido al gráfico obtenido, debemos analizar los pesos del grupo de variables en la combinación lineal que conforma cada componente principal, acompañado de la visualización de puntos extremos que ayudan a identificar sus principales características.
