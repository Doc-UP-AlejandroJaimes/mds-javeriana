# 02 · Conceptos Generales — Tablas de Contingencia

**Curso:** Modelos Estadísticos para la toma de decisiones
**Fuente original:** `conceptosgenerales02.txt` — "CONCEPTOS GENERALES - 2 / Tablas de contingencia"

---

Están conformadas por un arreglo de datos correspondientes a las frecuencias absolutas que resultan al contar todos los posibles registros que contienen las características $(a_i, b_j)$ correspondientes a las dos variables, que son representadas por $n_{ij}$.

**Estructura de la tabla de contingencia (variable A en filas 1..a, variable B en columnas 1..b):**

| A \ B | 1 | 2 | 3 | … | j | … | b | Total fila |
|---|---|---|---|---|---|---|---|---|
| **1** | $n_{11}$ | $n_{12}$ | $n_{13}$ | … | $n_{1j}$ | … | $n_{1b}$ | $n_{1.}$ |
| **2** | $n_{21}$ | $n_{22}$ | $n_{23}$ | … | $n_{2j}$ | … | $n_{2b}$ | $n_{2.}$ |
| **3** | $n_{31}$ | $n_{32}$ | $n_{33}$ | … | $n_{3j}$ | … | $n_{3b}$ | $n_{3.}$ |
| ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ |
| **i** | $n_{i1}$ | $n_{i2}$ | $n_{i3}$ | … | $n_{ij}$ | … | $n_{ib}$ | $n_{i.}$ |
| ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ |
| **a** | $n_{a1}$ | $n_{a2}$ | $n_{a3}$ | … | $n_{aj}$ | … | $n_{ab}$ | $n_{a.}$ |
| **Total columna** | $n_{.1}$ | $n_{.2}$ | $n_{.3}$ | … | $n_{.j}$ | … | $n_{.b}$ | $n$ |

Los valores $n_{i.}$ representan el total marginal de la variable A, mientras que $n_{.j}$ representa el total por columnas que corresponden a la variable B. La suma de todos los valores $n_{ij}$ es $n$.

La función `table()` en R permite construir la tabla a partir de la información contenida en una base de datos: `table(data$A, data$B)`.

---

## Prueba chi-cuadrado de Pearson

Determina si las diferencias entre las frecuencias observadas en una tabla de contingencia y las frecuencias esperadas —suponiendo que las variables son independientes— son estadísticamente significativas. En caso de rechazarse $H_0$, se concluye que las variables NO son independientes; en caso contrario se asume que hay una relación entre ellas (dependencia).

> Nota: tal como está redactado en el material original — "En caso de rechazarse Ho, se concluye que las variables son independientes, en caso contrario se asume que hay una relación entre ellas (dependencia)" — hay una posible inconsistencia de redacción respecto a la convención estadística estándar (normalmente: si se rechaza $H_0$, se concluye que NO son independientes). Vale la pena confirmar con el docente cuál es la interpretación correcta que se usará en la evaluación.

**Pruebas (hipótesis):**

- $H_0$: la variable A es independiente de la variable B.
- $H_a$: la variable A es NO independiente de la variable B.

**Estadístico de prueba:**

$$\chi^2 = \sum \frac{(Obs - Esp)^2}{Esp} \sim \chi^2_{\nu:(r-1)(c-1)}$$

**Región de rechazo:**

```r
# install.packages('ggfortify')
library(ggfortify)
pRdeR = qchisq(c(0.025, 0.975), 9)
p = ggdistribution(dchisq, seq(0, 30, 0.1), df = 9, colour = 'blue')
p = ggdistribution(dchisq, seq(pRdeR[2], 30, 0.1), df = 9, colour = 'blue', fill = "blue", p = p) +
  ggtitle("Región de rechazo:   (19.0, Inf) ")
p
```

```
pRdeR
[1]  2.700389 19.022768
```

### Ejemplo

Para las variables:

```r
library(paqueteMODELOS)
data("vivienda")
t_est_zon = table(vivienda$estrato, vivienda$zona)
chisq.test(t_est_zon)
```

```
    Pearson's Chi-squared test

data:  t_est_zon
X-squared = 3830.4, df = 12, p-value < 2.2e-16
```

### Reto

Los resultados anteriores indican que hay o no relación entre las variables estrato y zona de ubicación de las viviendas en Cali.

---

## Uso

Las tablas de contingencia son empleadas en ciencia de datos y el análisis estadístico cuando se trabaja con variables categóricas (cualitativas — escala nominal u ordinal). Estas tablas resumen la distribución conjunta de dos o más variables categóricas, permitiendo analizar patrones, relaciones y asociaciones entre ellas.

**Análisis exploratorio de datos (EDA)**

Las tablas de contingencia son una parte esencial del análisis exploratorio de datos. Proporcionan una visión rápida y clara de cómo se distribuyen las variables categóricas en conjunto.

**Análisis de frecuencias**

Las tablas de contingencia resumen las frecuencias de ocurrencia conjunta de las categorías de dos o más variables. Esto es útil para entender la distribución y proporciones en los datos.

**Pruebas de independencia**

Se utilizan para realizar pruebas de independencia entre dos variables categóricas. Las pruebas de chi-cuadrado son comúnmente aplicadas en este contexto para evaluar si las dos variables son independientes o si hay alguna asociación significativa entre ellas.

**Visualización de asociaciones**

Puedes visualizar las asociaciones entre variables categóricas utilizando gráficos como gráficos de barras apiladas, mapas de calor (heatmap) o diagramas de mosaico, que muestran la proporción de observaciones en cada combinación de categorías.

**Análisis de subconjuntos**

Al dividir la tabla de contingencia en subconjuntos, puedes examinar las relaciones en segmentos específicos de los datos, lo que puede ser útil para entender patrones más detallados.

**Preprocesamiento de datos**

Las tablas de contingencia también son útiles durante el preprocesamiento de datos, especialmente cuando se trata de manejar valores faltantes o identificar posibles relaciones entre variables antes de aplicar modelos de aprendizaje automático.
