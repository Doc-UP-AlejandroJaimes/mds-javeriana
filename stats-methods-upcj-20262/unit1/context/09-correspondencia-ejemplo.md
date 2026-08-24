# 09 · Análisis de Correspondencia — Ejemplo

**Curso:** Modelos Estadísticos para la toma de decisiones
**Fuente original:** `analicorrespondencia02.txt` — "Análisis De Correspondencia - 02"

---

Para ilustrar los pasos para realizar un análisis de correspondencia se toma una muestra de la base de datos `vivienda` contenida en `paqueteMOD`.

Se toma una muestra de tamaño n=4000 de la base de datos `vivienda24` contenida en `paqueteMOD`.

```r
set.seed(1234)
vivienda.24 <- sample_n(vivienda24, 4000)
```

Se convierte en variable tipo factor la variable `vivienda$estrato`.

```r
vivienda.24$estrato <- as.factor(vivienda.24$estrato)
```

Se revisa si la base tiene datos faltantes (rectángulos de color rojo).

```r
library(mice)
md.pattern(vivienda.24, rotate.names = TRUE)
```

La muestra seleccionada contiene un registro con datos faltantes para ambas variables, de tal forma que se procede a eliminarlas. Posteriormente, para constatar que se han eliminado, se utiliza la función `md.pattern` del paquete `mice`.

```r
library(mice)
vivienda.24 <- na.omit(vivienda.24)
grafico <-md.pattern(vivienda.24, rotate.names = TRUE)
```

Se construye entonces una tabla cruzada con las variables involucradas en el análisis:

- **Zona:** Centro, Norte, Oeste, Oriente, Sur.
- **Estrato:** 3, 4, 5, 6.

```r
library(FactoMineR)
tabla <- table(vivienda.24$zona, vivienda.24$estrato)
colnames(tabla) <- c("Estrato3", "Estrato4", "Estrato5", "Estrato6" )
tabla
```

```
              
               Estrato3 Estrato4 Estrato5 Estrato6
  Zona Centro        50        8        3        0
  Zona Norte        265      168      393       82
  Zona Oeste         24       38      147      377
  Zona Oriente      170        0        1        0
  Zona Sur          180      776      809      508
```

```r
chisq.test(tabla)
```

```
    Pearson's Chi-squared test

data:  tabla
X-squared = 1933.4, df = 12, p-value < 2.2e-16
```

El resultado indica que se rechaza la hipótesis de independencia de las variables (p-value: 0.0000), indicando algún tipo de relación entre ellas.

Finalmente se procede a realizar el análisis de correspondencia que consiste en estimar las coordenadas para cada uno de los niveles de ambas variables y representarlas en un plano cartesiano.

```r
library(FactoMineR)
library(factoextra)
library(gridExtra)
resultados_ac <- CA(tabla)
```

El gráfico nos permite establecer relaciones y validarlas, como son:

- El estrato 6 se encuentra ubicado en la Zona Oeste.
- Los estratos 4 y 5 están ubicados principalmente en la Zona Sur y Norte.
- El estrato 3 está presente en las Zonas Oriente y Centro.

Para medir el grado de representatividad del proceso, calculamos los valores de la varianza acumulada, utilizando para ello los valores propios de la matriz de discrepancias.

```r
valores_prop <-resultados_ac$eig ; valores_prop
```

```
      eigenvalue percentage of variance cumulative percentage of variance
dim 1 0.33730884              69.767822                          69.76782
dim 2 0.12866848              26.613355                          96.38118
dim 3 0.01749605               3.618823                         100.00000
```

```r
fviz_screeplot(resultados_ac, addlabels = TRUE, ylim = c(0, 80))+ggtitle("")+
ylab("Porcentaje de varianza explicado") + xlab("Ejes")
```

Los resultados indican que la primera componente resume el 68.9% y los dos primeros componentes representados en el plano factorial, mientras que los dos primeros ejes resumen un 96.4% de los datos.

> Nota: tal como aparece en el material original, este párrafo mezcla dos cifras (68.9% mencionado en el texto vs. 69.8% que se lee directamente en la tabla `valores_prop` para la dimensión 1). Conviene verificar con el docente cuál es la cifra correcta a citar; la tabla de `eig` es la fuente numérica exacta: dim 1 = 69.77%, dim 1+2 acumulado = 96.38%.

---

## Código completo de referencia

```r
library(paqueteMODELOS)
data(vivienda)
vivienda.24 <- vivienda[, c(2,4)]

library(dplyr)
set.seed(1234)
vivienda.24 <- sample_n(vivienda.24, 4000) 
md.pattern(vivienda.24, rotate.names = TRUE)     zona estrato  


library(mice)
library(FactoMineR)
vivienda.24 <- na.omit(vivienda.24)
tabla <- table(vivienda.24$zona, vivienda.24$estrato)
resultados_ac <- CA(tabla)
valores_prop <-resultados_ac$eig 

library(factoextra)
fviz_screeplot(resultados_ac, addlabels = TRUE, ylim = c(0, 80))+ggtitle("")+
ylab("Porcentaje de varianza explicado") + xlab("Ejes")

library(paqueteMODELOS)
data(vivienda)
vivienda.24 <- vivienda[, c(2,4)]

library(dplyr)
set.seed(1234)
vivienda.24 <- sample_n(vivienda.24, 4000) 
md.pattern(vivienda.24, rotate.names = TRUE)

library(mice)
library(FactoMineR)
vivienda.24 <- na.omit(vivienda.24)
tabla <- table(vivienda.24$zona, vivienda.24$estrato)
resultados_ac <- CA(tabla)
valores_prop <-resultados.ac$eig 

library(factoextra)
fviz_screeplot(resultados_ac, addlabels = TRUE, ylim = c(0, 80))+ggtitle("")+
ylab("Porcentaje de varianza explicado") + xlab("Ejes")
```

> Nota: el material original repite este bloque de código dos veces casi de forma idéntica (aparenta ser un error de composición del documento fuente), y en la segunda repetición hay una inconsistencia de tipeo: `resultados.ac$eig` (con punto) en vez de `resultados_ac$eig` (con guion bajo), lo cual generaría un error en R ya que el objeto se llama `resultados_ac`. Se transcribe tal cual aparece en el original para no perder información, señalando el detalle para que se corrija al ejecutar el código.

---

## Reto

Para las variables contenidas en la base de datos `rotacion` de `paqueteMODELOS`, determine la asociación que puede existir entre los niveles de las siguientes variables:

- Educación – Departamento
- Satisfacción laboral – Equilibrio Trabajo-Vida

```r
library(paqueteMODELOS)
data(rotacion)
```
