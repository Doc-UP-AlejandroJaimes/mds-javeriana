Cap 10 (Sección 10.3) - Probability and Statistics for Computer Science (David Forsyth, 2018). Principal Components Analysis.
Idea central: PCA aprovecha que, tras centrar los datos en su media y rotarlos según los vectores propios de su matriz de covarianza, se pueden descartar las direcciones de menor varianza sin perder casi información. Esto permite representar cada dato de alta dimensión como la media más una combinación de un número pequeño de vectores (componentes principales), reduciendo la dimensionalidad y a la vez suprimiendo ruido.

Nota: la sección 10.3 se apoya directamente en 10.2 (media y covarianza en alta dimensión: transformaciones afines, vectores propios y diagonalización, diagonalizar la covarianza rotando el "blob" de datos, aproximar blobs). PCA es, en esencia, la aplicación práctica de esas ideas para construir una representación de menor dimensión.

## 10.3.1 The Low Dimensional Representation

- Punto de partida: un conjunto de datos de alta dimensión se puede ver como un "blob" (nube de puntos).
- Paso 1 - Centrar: trasladar los datos para que tengan media cero.
- Paso 2 - Rotar: aplicar la rotación dada por los vectores propios de la matriz de covarianza, de modo que en el nuevo sistema de coordenadas la covarianza queda diagonal (las nuevas componentes quedan no correlacionadas entre sí).
- Paso 3 - Truncar: en este sistema diagonal, los vectores propios se ordenan por su valor propio (varianza) de mayor a menor; se conservan solo los primeros (mayor varianza) y se ponen en cero los restantes. Este es el paso de compresión.
- Paso 4 - Deshacer: se revierte la rotación y la traslación, obteniendo un dataset en las coordenadas originales pero de menor dimensión efectiva, que aproxima bien al dataset original.
- Resultado clave: cada dato puede escribirse como el vector media más una suma ponderada de un pequeño conjunto de vectores (los componentes principales). Esto equivale a decir que el dataset "vive" sobre (o muy cerca de) un espacio de dimensión baja dentro del espacio original de alta dimensión.
- Es un hecho empírico que este modelo de baja dimensión suele ser preciso para datos reales de alta dimensión, lo que lo hace muy conveniente en la práctica.

## 10.3.2 The Error Caused by Reducing Dimension

- Descartar componentes introduce un error de aproximación, pero ese error se puede cuantificar exactamente: es la suma de los valores propios (varianzas) de las componentes descartadas.
- De forma equivalente, la varianza conservada al quedarse con las primeras k componentes es la suma de esos k valores propios.
- Esto permite calcular qué porcentaje de la varianza total se conserva al quedarse con k componentes: (suma de los k valores propios mayores) / (suma de todos los valores propios). Con ese porcentaje se decide cuántas componentes conservar (por ejemplo, para retener 90-95% de la variabilidad).
- Beneficio adicional: como el ruido tiende a repartirse de forma más o menos pareja entre todas las direcciones (con varianza baja), mientras que la señal real se concentra en pocas direcciones de varianza alta, descartar las componentes de menor varianza suele eliminar más ruido que información real, por lo que la representación reducida puede quedar incluso más cerca de los datos "verdaderos" que las mediciones originales.

## 10.3.3 Example: Representing Colors with Principal Components

- Aplica PCA a datos de color/reflectancia espectral, donde se miden muchas longitudes de onda (muchas dimensiones).
- Muestra que, en la práctica, un número muy pequeño de componentes principales (del orden de unas pocas) alcanza para explicar casi toda la varianza de los espectros de color reales.
- Este resultado se conecta con un hecho conocido: la percepción humana del color es aproximadamente tridimensional (tricromática), lo cual coincide con que pocos componentes principales capturan casi toda la variabilidad.

## 10.3.4 Example: Representing Faces with Principal Components

- Aplica PCA a un conjunto de imágenes de rostros, donde cada imagen es un vector de altísima dimensión (un valor por píxel).
- Se calcula la cara promedio y un conjunto moderado de componentes principales (imágenes conocidas como "eigenfaces").
- Cada rostro individual puede reconstruirse aproximadamente como la cara promedio más una combinación de un número reducido de esas eigenfaces.
- Ejemplo clásico y muy citado en visión por computador (asociado a Turk y Pentland): demuestra que, aunque el espacio original tiene miles de dimensiones (píxeles), el conjunto de rostros reales ocupa efectivamente un espacio de dimensión mucho menor, permitiendo comprimir cada imagen a solo unos pocos coeficientes.

## Para recordar (síntesis rápida)

1. PCA = centrar + rotar según vectores propios de la covarianza + quedarse con las direcciones de mayor varianza + deshacer la rotación/traslación.
2. Cada dato ≈ media + combinación ponderada de pocos componentes principales → el dataset vive en un subespacio de baja dimensión.
3. El error de truncar es exactamente la suma de los valores propios descartados; esto permite fijar cuánta varianza se quiere conservar.
4. Al concentrarse la señal en pocas direcciones y el ruido en muchas, PCA con pocos componentes también actúa como reductor de ruido.
5. Ejemplos del libro: colores (pocas componentes explican casi toda la variabilidad espectral) y rostros (eigenfaces: compresión drástica de imágenes de caras).
