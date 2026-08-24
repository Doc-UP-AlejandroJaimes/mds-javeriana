# 01 · Conceptos Generales — De lo univariado a lo multivariado

**Curso:** Modelos Estadísticos para la toma de decisiones
**Fuente original:** `conceptosgenerales01.txt` — "CONCEPTOS GENERALES - 1 / Introducción"

---

Por lo general en el aprendizaje de la Estadística se trabaja con datos en una sola dimensión (univariado), se revisan tanto indicadores como la representación gráfica de las variables una a una. En ocasiones se pasa a estudiar grupos de variables de manera bivariada. Para ello se construyen tablas cruzadas y se construye una gráfica de las dos variables en un plano, de tal forma que permite identificar relaciones entre ellas.

En esta unidad trataremos el caso multivariado que consiste en tomar la información contenida en un grupo de variables (m > 2) que permita dar valor a un conjunto de variables y registros, pudiendo identificar patrones y realizar agrupaciones.

Para hacernos una idea empezaremos por lo univariado y avanzaremos a lo multivariado.

---

## Análisis estadístico univariado

Supongamos que tenemos información de un grupo de 1000 viviendas de las cuales contamos con su valor comercial. A partir de esta información podemos realizar un análisis univariado como se presentó en el curso anterior, mostrándonos de manera parcial el comportamiento de los precios de las viviendas.

**Descriptive Statistics — `vivienda1$preciom`**

N: 1000

| Estadístico | Valor |
|---|---|
| Mean | 457.38 |
| Std.Dev | 348.37 |
| Min | 65.00 |
| Q1 | 220.00 |
| Median | 340.00 |
| Q3 | 580.00 |
| Max | 1950.00 |
| MAD | 237.22 |
| IQR | 360.00 |
| CV | 0.76 |
| Skewness | 1.67 |
| SE.Skewness | 0.08 |
| Kurtosis | 2.72 |
| N.Valid | 1000.00 |
| Pct.Valid | 100.00 |

Es posible que este análisis se quede corto para entender el comportamiento de los precios de la vivienda, su alta variación y asimetría.

---

## Análisis estadístico bivariado

Una segunda opción es la de analizar dos variables al tiempo (análisis bivariado) y medir la relación que puede existir entre ellas, presentándose las siguientes posibilidades:

### 1. Cualitativa – Cualitativa

En este caso se emplean las tablas de contingencia o de doble entrada, las cuales se pueden representar mediante un diagrama de barras. Para determinar si existe relación o no entre las dos variables se utiliza una prueba de hipótesis Chi-cuadrado para tablas de contingencia.

| | Apart. | Casa |
|---|---|---|
| Zona Centro | 3 | 6 |
| Zona Norte | 118 | 90 |
| Zona Oeste | 135 | 19 |
| Zona Oriente | 7 | 39 |
| Zona Sur | 348 | 235 |

```r
tabla <- table(vivienda1$tipo, vivienda1$zona)
t(tabla)
```

```
    Pearson's Chi-squared test

data:  tabla
X-squared = 91.536, df = 4, p-value < 2.2e-16
```

El resultado obtenido (p-value: 0.000), indica que las variables no son independientes.

### 2. Cualitativa – Cuantitativa

En este caso se puede realizar un análisis calculando los indicadores estadísticos (media, mediana, varianza…) de la variable cuantitativa para los diferentes grupos o categorías que conforman la variable cualitativa. Y también representarlas mediante un diagrama de cajas.

**Descriptive statistics by group**

*group: Apartamento*

| vars | n | mean | sd | median | trimmed | mad | min | max | range | skew | kurtosis | se |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| precio | 611 | 384.51 | 312.28 | 290 | 321.24 | 185.32 | 65 | 1950 | 1885 | 2.08 | 4.67 | 12.63 |

*group: Casa*

| vars | n | mean | sd | median | trimmed | mad | min | max | range | skew | kurtosis | se |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| precio | 389 | 571.82 | 371.03 | 470 | 518.36 | 281.69 | 80 | 1900 | 1820 | 1.32 | 1.44 | 18.81 |

Los resultados muestran una leve diferencia entre los dos grupos en cuanto a su media que puede ser confirmada mediante una prueba de hipótesis t.student para la comparación de medias.

```
    Welch Two Sample t-test

data:  vivienda1$preciom by vivienda1$tipo
t = -8.2658, df = 723.33, p-value = 6.623e-16
alternative hypothesis: true difference in means between group Apartamento and group Casa is not equal to 0
95 percent confidence interval:
 -231.7959 -142.8197
sample estimates:
mean in group Apartamento        mean in group Casa 
                 384.5123                  571.8201 
```

Los resultados indican que existen diferencias significativas entre los valores medios de las casas comparados con los valores medios de los apartamentos.

### 3. Cuantitativa – Cuantitativa

Cuando tenemos dos variables cuantitativas se pueden medir indicadores conjuntos como son la covarianza y la correlación, esta última mide la fuerza de la relación lineal entre las dos variables.

- Cov(precio, área construida) = 35898.43
- Cor(precio, área construida) = 0.6725091

Los resultados indican una leve relación lineal positiva entre el área construida de la vivienda y su valor comercial (a mayor área de construcción de la vivienda, mayor precio).

---

## Análisis estadístico multivariado

Aunque este análisis es más amplio que los anteriores, está menos difundido y utilizado que los dos anteriores.

Los métodos multivariados pueden tener diferentes propósitos como:

- Resumir un conjunto de datos con muchas variables en unas pocas: **Análisis de Componentes Principales**.
- Visualizar patrones - clasificar: **Análisis de Conglomerados**.
- Realizar predicciones: **Regresión Lineal**.
- Asociación entre variables: **Análisis de Correspondencia**.

En esta unidad se tratan algunos de estos métodos.
