# 05 · Análisis de Componentes Principales — Ejemplo

**Curso:** Modelos Estadísticos para la toma de decisiones
**Fuente original:** `acp02.txt` — "ACP - 02 / Ejemplo"

---

La siguiente base de datos corresponde a información relacionada con el comportamiento crediticio de un grupo de 780 clientes de un banco.

Se requiere resumir las variables cuantitativas (antigüedad, edad, cuota e ingresos) en por lo menos dos variables (componentes principales) y poder así adicionar elementos al análisis.

```r
library(paqueteMODELOS)
data("creditos")                # base de datos
creditosZ= scale(creditos)      # datos estandarizados

summary(creditos)
cat("-----------------------------------------------------------------------", "\n")
summary(creditosZ)
```

```
     default       antiguedad           edad           cuota            ingresos       
 Min.   :0.00   Min.   : 0.2548   Min.   :26.61   Min.   :    387   Min.   :  633825  
 1st Qu.:0.00   1st Qu.: 7.3767   1st Qu.:48.18   1st Qu.: 328516   1st Qu.: 3583324  
 Median :0.00   Median :15.1192   Median :57.92   Median : 694460   Median : 5038962  
 Mean   :0.05   Mean   :18.0353   Mean   :56.99   Mean   : 885206   Mean   : 5366430  
 3rd Qu.:0.00   3rd Qu.:30.6637   3rd Qu.:66.19   3rd Qu.:1244126   3rd Qu.: 6844098  
 Max.   :1.00   Max.   :37.3178   Max.   :92.43   Max.   :6664588   Max.   :22197021  
----------------------------------------------------------------------- 
    default          antiguedad           edad             cuota            ingresos      
 Min.   :-0.2293   Min.   :-1.4892   Min.   :-2.4287   Min.   :-1.1954   Min.   :-1.7844  
 1st Qu.:-0.2293   1st Qu.:-0.8927   1st Qu.:-0.7038   1st Qu.:-0.7521   1st Qu.:-0.6723  
 Median :-0.2293   Median :-0.2442   Median : 0.0747   Median :-0.2577   Median :-0.1235  
 Mean   : 0.0000   Mean   : 0.0000   Mean   : 0.0000   Mean   : 0.0000   Mean   : 0.0000  
 3rd Qu.:-0.2293   3rd Qu.: 1.0577   3rd Qu.: 0.7364   3rd Qu.: 0.4849   3rd Qu.: 0.5572  
 Max.   : 4.3561   Max.   : 1.6150   Max.   : 2.8346   Max.   : 7.8077   Max.   : 6.3459  
```

Inicialmente revisemos si existen datos faltantes.

```r
library(mice)
md.pattern(creditos)
```

La gráfica indica que no se presentan datos faltantes.

Con el fin de evitar que las variables que tienen una escala con valores más grandes afecten las estimaciones realizadas (sesgos), se realiza la estandarización de las variables antes de proceder a realizar el proceso de estimación de los componentes principales.

```r
creditosZ= scale(creditos[,2:5])
head(creditosZ) # primeros 6 registros
```

```r
prcomp(creditosZ)
```

```
Standard deviations (1, .., p=4):
[1] 1.4956195 0.9783699 0.7576046 0.4816118

Rotation (n x k) = (4 x 4):
                  PC1        PC2        PC3         PC4
antiguedad -0.5926455  0.2777622  0.1520487 -0.74060831
edad       -0.5454793  0.4553210  0.2485578  0.65829634
cuota      -0.3367282 -0.7905281  0.5057479  0.07680159
ingresos   -0.4876861 -0.3009920 -0.8119848  0.11066515
```

---

## Elección del número de componentes principales

```r
library(paqueteMODELOS)
data("creditos")
creditosZ= scale(creditos[,2:5]) 
res.pca <- prcomp(creditosZ)
fviz_eig(res.pca, addlabels = TRUE)
```

En este caso el primer componente principal explica el 55.9% de la variabilidad contenida en la base de datos, y entre los dos primeros se casi el 80% de los datos (79.8), lo cual indicaría que con solo una variable (CP1), que se obtiene mediante una combinación lineal de las variables, se puede resumir gran parte de la variabilidad que contiene la base de datos.

```r
fviz_pca_var(res.pca,
col.var = "contrib", # Color by contributions to the PC
gradient.cols = c("#FF7F00",  "#034D94"),
repel = TRUE     # Avoid text overlapping
)
```

Al visualizar las variables en el plano de los componentes principales, permite identificar el sentido y la caracterización de los componentes (característica capturada por los vectores propios de $\Sigma$). En este ejercicio el primer componente principal está asociado principalmente con las variables edad y antigüedad, mientras que el segundo componente se puede asociar a la variable cuota.

Para explicar el sentido de los ejes, se escogen cuatro casos extremos conformados por los siguientes clientes.

```r
datos<- rbind(creditos[98,], # ok
creditos[778,],
creditos[6,],
creditos[462,])

datos <- as.data.frame(datos)
rownames(datos) = c("Cliente 098","Cliente 778","Cliente 006","Cliente 462")
datos
```

```
            default antiguedad     edad   cuota ingresos
Cliente 098       0  27.358904 74.30685  170024 20924813
Cliente 778       0   1.517808 26.61370    9256  2473929
Cliente 006       1   6.605479 44.87945 3517756  2710736
Cliente 462       0  26.380822 73.40548   69483  2335189
```

```r
casos1 <- rbind(res.pca$x[98,1:2],res.pca$x[778,1:2]) # CP1
rownames(casos1) = c("98","299")
casos1 <- as.data.frame(casos1)

casos2 <- rbind(res.pca$x[6,1:2], res.pca$x[462,1:2]) # CP2
rownames(casos2) = c("6","190")
casos2 <- as.data.frame(casos2)

fviz_pca_ind(res.pca, col.ind = "#DEDEDE", gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07")) +
geom_point(data = casos1, aes(x = PC1, y = PC2), color = "red", size = 3) +
geom_point(data = casos2, aes(x = PC1, y = PC2), color = "blue", size = 3)
```

```
default   antiguedad       edad     cuota   ingresos
Cliente 098         0    27.358904   74.30685    170024   20924813
Cliente 778         0     1.517808   26.61370      9256    2473929

Cliente 006         1     6.605479   44.87945   3517756    2710736
Cliente 462         0    26.380822   73.40548     69483    2335189
```

El cliente 098 presenta altos ingresos ($20'924.813), mientras que el cliente 778, que se encuentra ubicado al otro extremo, presenta bajos ingresos ($2'473.929). Esto muestra el sentido en que aumentan los valores del primer componente principal (Dim1).

Aún más, dado que el primer componente no solo está conformado por la variable ingresos, sino que se trata de una combinación lineal de todas las variables donde se destaca (presenta mayor peso) los ingresos, se puede analizar que mientras el cliente 098 presenta una relación cuota/ingresos de $170.024/$20'924.813 = 0.008125473, el cliente 299, que se encuentra al otro extremo de la recta, presenta una relación $727.995 / 848.487 = 0.8579919.

Lo mismo ocurre al comparar el cliente 006 (cuota = $3'517.756) con el cliente 190 (cuota = $103.855).

```r
datos<- rbind(creditos[98,],
creditos[293,],
creditos[6,],
creditos[190,])
datos
```

```
# A tibble: 4 × 5
  default antiguedad  edad   cuota ingresos
    <dbl>      <dbl> <dbl>   <dbl>    <dbl>
1       0      27.4   74.3  170024 20924813
2       0       3.52  35.0  161412  3093808
3       1       6.61  44.9 3517756  2710736
4       0      27.8   54.0  103855 12303025
```

```r
fviz_pca_biplot(res.pca, 
repel = TRUE,
habillage = creditos$default,
col.var = "#034A94", # Variables color
col.ind = c("#DEDEDE", "#034A94")  # Individuals color
)
```

La representación gráfica de los dos primeros componentes principales nos permite observar la relación existente entre las variables: edad y antigüedad, formando un grupo que presenta un mayor efecto sobre el primer componente, mientras que la variable cuota presenta un mayor efecto sobre el segundo componente.

---

## Reto

Para las variables contenidas en la base de datos `rotacion` de `paqueteMODELOS`, determine si es posible construir dos variables (componentes principales) que permitan reducir un grupo de variables sin perder información.

```r
library(paqueteMODELOS)
data(rotacion)
```
