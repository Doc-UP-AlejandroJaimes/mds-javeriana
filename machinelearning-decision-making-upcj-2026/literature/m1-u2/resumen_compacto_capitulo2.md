Cap 2 - Data Mining: Concepts and Techniques (Han & Kamber). Getting to Know Your Data.
Idea central: Antes de minar datos hay que conocerlos: identificar el tipo de cada atributo, describirlo estadísticamente (centralidad y dispersión), visualizarlo gráficamente y medir la similitud/disimilitud entre objetos. Este conocimiento previo es la base indispensable del preprocesamiento de datos (Capítulo 3) y de cualquier tarea posterior de minería (clustering, clasificación, detección de outliers).

## 1. Tipos de atributos

- Nominal: categorías sin orden (color de cabello, ocupación). Solo admite moda.
- Binario: nominal con 2 estados. Simétrico (mismo peso, ej. género) o asimétrico (un estado más relevante, ej. resultado de prueba médica).
- Ordinal: orden significativo sin magnitud conocida (calificaciones, tamaños S/M/L). Admite moda y mediana, no media.
- Numérico: interval-scaled (sin cero verdadero, ej. °C) o ratio-scaled (con cero verdadero, ej. peso, salario). Admite media, mediana y moda.
- Clasificación alternativa: discreto vs. continuo.
- Nominal + binario + ordinal = cualitativos. Numérico = cuantitativo.

## 2. Descripciones estadísticas básicas

- Tendencia central: media (sensible a outliers), mediana (robusta), moda (única válida para nominales).
- Dispersión: rango, cuartiles (Q1, Q3), IQR = Q3 - Q1, resumen de 5 números (min, Q1, mediana, Q3, max) que forma el boxplot.
- Regla de outlier: valores fuera de 1.5 x IQR desde Q1 o Q3.
- Varianza y desviación estándar miden dispersión respecto a la media.
- Scatter plot revela correlación positiva, negativa o nula entre dos atributos numéricos.

## 3. Visualización de datos

- Basada en píxeles: cada valor es un píxel coloreado por magnitud.
- Proyección geométrica: scatter plots, matriz de scatter plots, coordenadas paralelas.
- Basada en íconos: Chernoff faces (hasta 18 dimensiones como rasgos faciales), stick figures.
- Jerárquica: Worlds-within-Worlds (n-Vision), tree-maps (rectángulos anidados).

[Insertar aquí figura de ejemplo de Chernoff faces o tree-map, si se desea]

## 4. Medidas de similitud y disimilitud

- Numéricos: distancia Euclidiana, Manhattan, Minkowski (generaliza a las anteriores), suprema (Chebyshev).
- Nominales: coeficiente de coincidencia simple.
- Binarios: coincidencia simple (simétricos) o Jaccard, que ignora coincidencias en "0" (asimétricos).
- Ordinales: convertir a rango normalizado z = (r-1)/(M-1), luego aplicar distancia numérica.
- Datos mixtos: combinar todo en una sola matriz de disimilitud normalizada y ponderada por tipo de atributo.

---

Cap 2 (Sección 2.3) - Introduction to Data Mining (Tan, Steinbach & Kumar). Data Preprocessing.
Idea central: El preprocesamiento transforma los datos crudos en una forma más adecuada para la minería, ya sea reduciendo objetos/atributos (agregación, muestreo, reducción de dimensionalidad, selección de atributos) o creando/transformando atributos (creación de features, discretización, transformación de variables), siempre buscando mejorar tiempo, costo y calidad del análisis posterior.

## 2.3.1 Aggregation

- Combinar dos o más objetos en uno solo. Cuantitativos se agregan por suma/promedio; cualitativos se omiten o resumen en categoría superior.
- Vista como array multidimensional: agregar = eliminar una dimensión o reducir sus valores posibles (base de OLAP).
- Motivaciones: menos memoria/tiempo de procesamiento, cambio de escala (vista de alto nivel), mayor estabilidad estadística de los agregados frente a objetos individuales.
- Desventaja: pérdida de detalle. Ejemplo Australia: precipitación anual (agregada) tiene menor variabilidad que la mensual.

## 2.3.2 Sampling

- Seleccionar un subconjunto de objetos. En minería de datos la motivación es el costo computacional (memoria/tiempo), no el costo de recolectar los datos.
- Principio clave: una muestra funciona casi tan bien como todo el dataset si es representativa.
- Muestreo aleatorio simple: con o sin reemplazo. Falla con clases poco frecuentes.
- Muestreo estratificado: soluciona ese problema tomando cantidades fijas o proporcionales de cada grupo predefinido.
- Trade-off de tamaño: muestras grandes son más representativas pero reducen el ahorro computacional; muestras pequeñas pueden perder o inventar patrones.
- Muestreo progresivo/adaptativo: empieza pequeño y crece hasta que la mejora en precisión se estabiliza (leveling-off point).

## 2.3.3 Dimensionality Reduction

- Datasets con miles de atributos (vectores de frecuencia de palabras, series de tiempo financieras).
- Beneficios: mejor desempeño de algoritmos, modelos más comprensibles, visualización más fácil, menos tiempo/memoria.
- "Dimensionality reduction" = crear nuevos atributos combinando los originales (a diferencia de feature subset selection, que selecciona sin combinar).
- Curse of dimensionality: a mayor dimensionalidad, los datos se vuelven más dispersos (sparse); las diferencias de densidad y distancia pierden significado, afectando clustering y clasificación.
- Técnicas de álgebra lineal: PCA (componentes principales: combinaciones lineales, ortogonales, que capturan la máxima variación) y SVD (técnica relacionada).

## 2.3.4 Feature Subset Selection

- Reducir dimensionalidad usando un subconjunto de atributos, sin perder información si hay atributos redundantes (duplican información, ej. precio y su impuesto) o irrelevantes (ej. ID de estudiante para predecir su GPA).
- Enfoque ideal (probar los 2^n subconjuntos) es impráctico; se usan 3 enfoques alternativos:
  - Embedded: la selección ocurre dentro del propio algoritmo (ej. árboles de decisión).
  - Filter: se seleccionan atributos antes del algoritmo, de forma independiente (ej. baja correlación entre pares).
  - Wrapper: usa el algoritmo objetivo como caja negra para evaluar subconjuntos, sin enumerarlos todos.
- Arquitectura común (filter y wrapper): medida de evaluación, estrategia de búsqueda, criterio de parada, procedimiento de validación. Difieren solo en cómo evalúan el subconjunto.

[Insertar aquí Figura 2.11: flowchart del proceso de selección de subconjunto de atributos]

- Feature weighting: alternativa a mantener/eliminar atributos; se asignan pesos de importancia (por dominio o automáticamente, ej. SVM, o la normalización usada en similitud coseno).

## 2.3.5 Feature Creation

- Crear un nuevo conjunto de atributos que capture mejor la información, idealmente en menor número que los originales.
- Feature extraction: construir atributos de alto nivel a partir de datos crudos (ej. bordes en imágenes para detectar rostros). Suele ser específico del dominio.
  - Ejemplo densidad: densidad = masa / volumen permite clasificar artefactos por material de forma directa.
- Mapping the data to a new space: cambiar de representación revela patrones ocultos. Ejemplo clásico: transformada de Fourier sobre series de tiempo ruidosas, que expone las frecuencias reales pese al ruido. La transformada wavelet es otra alternativa útil.

[Insertar aquí Figura 2.12: aplicación de la transformada de Fourier (series puras, serie ruidosa, power spectrum)]

## Pendiente

- 2.3.6 Discretization and binarization
- 2.3.7 Variable transformation
