# 07 · Análisis de Conglomerados — Ejemplo

**Curso:** Modelos Estadísticos para la toma de decisiones
**Fuente original:** `analiconglomerados02.txt` — "Análisis De conglomerados - 02"

---

| id | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |
|---|---|---|---|---|---|---|---|---|
| inv.pub | 16 | 12 | 10 | 12 | 45 | 50 | 45 | 50 |
| ventas | 10 | 14 | 22 | 25 | 10 | 15 | 25 | 27 |

```r
id= 1:8
empresa =data.frame(inv.pub = c(16,12,10,12,45,50,45,50),
ventas =c(10,14,22,25,10,14,25,27) )
rownames(empresa) = c("E1","E2","E3","E4","E5","E6","E7", "E8")
```

Dado que los rangos de las variables son diferentes, y con el fin de que estas diferencias en las dimensiones de las variables no afecten los cálculos de las distancias, se aconseja estandarizar las variables (restar la media y dividir el resultado por la desviación estándar) antes de generar los cálculos de las distancias.

$$z = \frac{x - \mu}{\sigma}$$

```r
empresa_z =scale(empresa)
empresa_z = as.data.frame(empresa_z)
empresa_z
```

```
      inv.pub     ventas
E1 -0.7417009 -1.1779013
E2 -0.9536155 -0.6153216
E3 -1.0595728  0.5098379
E4 -0.9536155  0.9317727
E5  0.7946796 -1.1779013
E6  1.0595728 -0.6153216
E7  0.7946796  0.9317727
E8  1.0595728  1.2130625
```

Las distancias correspondientes a los valores estandarizados serán:

## Distancias euclidianas

```r
dist(empresa_z, method = "euclidean")
```

```
          E1        E2        E3        E4        E5        E6        E7
E2 0.6011686                                                            
E3 1.7174126 1.1301375                                                  
E4 2.1202905 1.5470942 0.4350355                                        
E5 1.5363805 1.8365815 2.5073323 2.7399379                              
E6 1.8870832 2.0131883 2.3993252 2.5389816 0.6218234                    
E7 2.6098255 2.3345313 1.9016521 1.7482951 2.1096739 1.5696079          
E8 2.9935422 2.7195432 2.2327792 2.0327447 2.4055927 1.8283841 0.3863837
```

## Distancias de Manhattan

```r
dist(empresa_z, method = "manhattan")
```

```
          E1        E2        E3        E4        E5        E6        E7
E2 0.7744943                                                            
E3 2.0056110 1.2311167                                                  
E4 2.3215885 1.5470942 0.5278921                                        
E5 1.5363805 2.3108748 3.5419915 3.8579690                              
E6 2.3638534 2.0131883 3.2443050 3.5602825 0.8274729                    
E7 3.6460545 3.2953893 2.2761871 1.7482951 2.1096739 1.8119874          
E8 4.1922375 3.8415724 2.8223702 2.2944781 2.6558570 1.8283841 0.5461831
```

## Distancias de Minkowski

```r
dist(empresa_z, method = "minkowski")
```

```
          E1        E2        E3        E4        E5        E6        E7
E2 0.6011686                                                            
E3 1.7174126 1.1301375                                                  
E4 2.1202905 1.5470942 0.4350355                                        
E5 1.5363805 1.8365815 2.5073323 2.7399379                              
E6 1.8870832 2.0131883 2.3993252 2.5389816 0.6218234                    
E7 2.6098255 2.3345313 1.9016521 1.7482951 2.1096739 1.5696079          
E8 2.9935422 2.7195432 2.2327792 2.0327447 2.4055927 1.8283841 0.3863837
```

---

## Distribución de los individuos por distancias

```r
library(tidyverse)
# distancia euclidiana
dist_emp <- dist(empresa_z, method = 'euclidean')

# Clúster jerárquico con el método complete
hc_emp <- hclust(dist_emp, method = 'complete')

# Determinamos a dónde pertenece cada observación
cluster_assigments <- cutree(hc_emp, k = 4)

# asignamos los clusters
assigned_cluster <- empresa_z %>% mutate(cluster = as.factor(cluster_assigments))


# gráfico de puntos
ggplot(assigned_cluster, aes(x = inv.pub, y = ventas, color = cluster)) +
geom_point(size = 4) +
geom_text(aes(label = cluster), vjust = -.8) + # Agregar etiquetas del clúster
theme_classic()
```

```r
plot(hc_emp, cex = 0.6, main = "Dendograma de Empresas", las=1,
ylab = "Distancia euclidiana", xlab = "Grupos")
rect.hclust(hc_emp, k = 2, border = 2:5)
```

En este diagrama se observa que al inicio los individuos que más se parecen (menor distancia euclidiana) son los individuos E7, E8, E3 y E4 (d(E7, E8) = 0.3863837; d(E3, E4) = 0.4350355), conformando estas cuatro empresas un primer clúster y el resto un segundo grupo o clúster a una distancia de 2.5.

En el caso de tener hipótesis de la existencia de 4 grupos, podemos reducir la distancia a 1.0 y se obtienen cuatro conglomerados.

---

## Clasificación de las empresas

```r
dendograma <- hclust(dist_emp, method = "average")
grp <- cutree(dendograma, k = 4)
grp
```

```
E1 E2 E3 E4 E5 E6 E7 E8 
 1  1  2  2  3  3  4  4 
```

---

## Elección del número de conglomerados

Elegir el número óptimo de clusters o grupos es una decisión subjetiva; sin embargo, puede tomarse el criterio del mayor salto de nodo a nodo de las distancias euclidianas. Observando el dendograma vemos que el mayor incremento de las distancias se dio en 1, por lo que si trazamos una línea se hará un corte y tendremos cuatro nodos, el conformado por (E1,E2), (E5, E6), (E7, E8) y (E3, E4).

```r
library(factoextra)

dist_emp <- dist(empresa_z, method = "euclidean")
dendograma <- hclust(dist_emp, method = "average")
# plot(dendograma, cex = 0.6, hang = -1) 
barplot(sort(dendograma$height, decreasing = TRUE), horiz = TRUE, 
main = "Agregaciones (distancias euclidianas)",
col = "lightblue", ylab = "Nodo", xlab = "Peso", xlim = c(0, 2.5))
```

Por último se mide el índice de Silhouette promedio con el fin de valorar la mejor alternativa para la elección del número de conglomerados.

```r
library(tidyverse)
library(cluster)
# distancia euclidiana
dist_emp <- dist(empresa_z, method = 'euclidean')

# Clúster jerárquico con el método complete
hc_emp <- hclust(dist_emp, method = 'complete')

# Determinamos a dónde pertenece cada observación
cluster_assigments <- cutree(hc_emp, k = 4)

# Calcular el coeficiente de Silhouette
sil <- silhouette(cluster_assigments, dist(empresa_z))
sil_avg <- mean(sil[,3])

# Imprimir el coeficiente de Silhouette promedio
cat("Coeficiente de Silhouette promedio k=4 : ", sil_avg)
```

```
Coeficiente de Silhouette promedio k=4 :  0.690995
```

Estos resultados indican una mejor agrupación cuando se eligen k=4 conglomerados (valores más cercanos a 1 indican un agrupamiento más coherente).

---

## Reto

Para las variables contenidas en la base de datos `rotacion` de `paqueteMODELOS`, determine si puede existir una forma de agrupar a los empleados de la empresa que permita identificar segmentos.

```r
library(paqueteMODELOS)
data(rotacion)
```
