# Pregunta Problema

¿Es posible predecir, a partir de la información de un cliente de telecomunicaciones (datos demográficos, contrato, servicios contratados y cargos), si este cancelará sus servicios (Churn) o continuará con ellos (No Churn), mediante un modelo de clasificación automática binaria?


## Trabajo a Realizar
Cada equipo propondrá cuatro hipótesis de solución del problema, las cuales deberán ser compartidas a través del debate “Hipótesis para revisión” de la unidad. Para acceder al debate, haz clic aquí.

Posteriormente, cada equipo recibirá retroalimentación específica sobre las hipótesis compartidas y tendrán la posibilidad de hacer ajustes de acuerdo con las observaciones recibidas. Las hipótesis ajustadas deberán ser enviadas y serán calificadas. Para entregar la hipótesis en su versión final, haz clic aquí.

## Ejemplos de Hipótesis

### Ejemplo 1

- Para detectar enfermedades de plantas mediante el análisis de una foto de una hoja, se puede utilizar una red convolucional profunda, dado que esta técnica es particularmente apropiada para el procesamiento de imágenes y se cuenta con una base de datos de un millón de imágenes etiquetadas con la enfermedad que adolece la planta.

> Esta hipótesis considera las fortalezas de la técnica y toma en cuenta que la cantidad de datos disponibles sea suficiente para que ella pueda desplegar todo su potencial.


### Ejemplo 2

- Se puede utilizar la técnica random forest para clasificar un hongo como venenoso o comestible a partir de un conjunto de características físicas como la altura, el diámetro de la copa, el color y la forma, entre otros. Dado que la base de datos no es particularmente grande (200 ejemplos) se debe utilizar validación cruzada para la evaluación del modelo.

> Esta hipótesis considera la capacidad de la técnica random forest para procesar tanto atributos categóricos como numéricos y no hace requerimientos especiales sobre la cantidad de datos disponibles. También toma en cuenta que no hay muchos datos al considerar la forma de evaluar el desempeño del modelo.


### Ejemplo 3

- Para predecir si una persona tiene sobrepeso u obesidad a partir de las características de su alimentación, se puede usar un perceptrón multicapa. Para tratar el desbalance del conjunto de datos que ilustra de manera escasa la clase de las personas que están bajas de peso, se deben aplicar técnicas de aumento de datos. Para poder usar la técnica será necesario convertir a numéricos los atributos categóricos presentes en la base de datos.

> Esta hipótesis propone la técnica a utilizar y anticipa la necesidad de atender el desbalance de los datos. También anticipa la necesidad de cambiar la representación de los atributos categóricos.


## Hipótesis realizadas por compañeros

### G14: Hipótesis Solución
Buen día compañeros.

Compartimos con ustedes las hipótesis que proponemos como primera parte de la actividad de este módulo. 

Quedamos atentos a sus comentarios y sugerencias. 

Consideraciones Metodológicas Generales

Previo al modelamiento, se realizará limpieza y preparación de datos, incluyendo tratamiento de valores faltantes, depuración de inconsistencias y análisis de outliers. Se evaluará la colinealidad entre variables independientes mediante análisis de correlación, con el fin de evitar problemas de multicolinealidad que afecten la estabilidad, especialmente en modelos lineales.

Todos los modelos recibirán como entrada un conjunto de variables predictoras (X) asociadas a características del cliente, y producirán como salida la probabilidad estimada de churn o su clasificación binaria. Entiéndase como churn igual a 1 como clientes en fuga.  

Adicionalmente, se establecerá como criterio mínimo de desempeño alcanzar un accuracy superior al 75% y un recall igual o superior al 75% para la clase churn (y=1). Se prioriza el recall debido a que el objetivo estratégico del modelo es reducir los falsos negativos, es decir, minimizar la cantidad de clientes en riesgo que no sean identificados oportunamente. 


Hipótesis 1 – Regresión Logística 
Se plantea que la Regresión Logística permitirá estimar la probabilidad de churn (y=1) a partir de variables del cliente (X), ofreciendo un modelo interpretable y competitivo en métricas como accuracy, recall, F1-score y ROC-AUC, buscando superar el umbral mínimo definido (75%). 
Se evaluará overfitting mediante validación cruzada y comparación train vs test. En caso de desbalance, se analizará el uso de SMOTE o ajuste de pesos para mejorar la sensibilidad hacia clientes en riesgo. 


Hipótesis 2 – Árbol de Decisión 
Se propone que el Árbol de Decisión capturará relaciones no lineales entre las variables del cliente y la probabilidad de churn, generando reglas de segmentación claras. 
Se evaluará con accuracy, recall, F1-score y ROC-AUC, procurando alcanzar o superar el 75% en accuracy y recall. Se controlará el sobreajuste mediante poda y validación cruzada. En escenarios desbalanceados, se analizará el efecto del muestreo en la identificación correcta de clientes con alta probabilidad de abandono. 


Hipótesis 3 – Balanced Bagging Classifier 
Se plantea que un modelo de Balanced Bagging mejorará la capacidad de detección del churn al entrenar múltiples clasificadores base sobre subconjuntos balanceados de la muestra, reduciendo el sesgo hacia la clase mayoritaria. 
Como entrada recibirá las variables predictoras del cliente (X) y como salida generará la probabilidad o clase estimada de churn. Se evaluará mediante accuracy, recall, F1-score y ROC-AUC, priorizando especialmente un recall ≥ 75% para fortalecer la identificación de clientes en riesgo. Se controlará el overfitting mediante validación cruzada. 


Hipótesis 4 – XGBoost 
Se propone que XGBoost alcanzará el mejor desempeño global debido a su capacidad para modelar relaciones complejas y optimizar iterativamente el error. 
El modelo recibirá como entrada las variables del cliente (X) y producirá como salida la probabilidad estimada de churn. Se evaluará con accuracy, recall, F1-score, ROC-AUC y log-loss, buscando superar el 75% en accuracy y recall. Se controlará el sobreajuste mediante early stopping. En caso de desbalance, se ajustará el parámetro scale_pos_weight y se comparará con 
técnicas de muestreo.

#### Respuesta Docente
Un saludo Grupo 14. 

En general considero que las hipótesis están bien planteadas.

Un aspecto a tener en cuenta es que hay justificación para los umbrales de rendimiento que plantearon. 

¿Estos umbrales se definieron a partir del conocimiento del negocio o de una búsqueda en la literatura? 

### G7: Hipótesis Solución
Estimado profesor y compañeros,

A continuación, presentamos la propuesta de hipótesis del equipo para abordar el problema de clasificación automática de cancelación de servicios en el sector de telecomunicaciones.

Después de realizar la exploración inicial de la base de datos Telco Customer Churn, identificamos dos factores clave que orientan la selección de las técnicas supervisadas la naturaleza mixta y dimensionalidad y por otro lado el desbalance de clases. El dataset cuenta con variables numéricas continuas (tenure, MonthlyCharges, TotalCharges) y múltiples características categóricas (tipo de contrato, método de pago, servicios suscritos). El desbalance de clases se observa una proporción aproximada de 73.5% para la clase de permanencia (No Churn) frente a un 26.5% para la clase de fuga (Churn). Con base en estas condiciones, proponemos cuatro posibles formas de abordar la solución para su posterior verificación y comparación.

Propuesta de las Cuatro Hipótesis Planteadas:

Hipótesis 1 (Bosque Aleatorio / Random Forest):Para predecir la probabilidad de fuga de clientes a partir de variables demográficas y de servicio (como antigüedad, tipo de contrato y cargos mensuales), se puede utilizar un modelo Random Forest, esta técnica es ideal debido a su capacidad para manejar datos categóricos y numéricos sin asumir linealidad; además, para mitigar el desbalance entre la clase Churn y No Churn, se emplearán técnicas de re-muestreo (como SMOTE) o ajuste de pesos en el entrenamiento.

Hipótesis 2 (Máquinas de Vectores de Soporte / SVM):Se puede implementar una Máquina de Vectores de Soporte (SVM) con un kernel RBF para clasificar a los usuarios en riesgo de cancelación. Dado que SVM requiere entradas numéricas y es sensible a la escala, se aplicará codificación One-Hot Encoding a las variables categóricas (ej. tipo de servicio de internet) y escalado StandardScaler a los costos continuos, optimizando el hiperparámetro de margen para maximizar la sensibilidad (recall) sobre la clase de clientes que cancelan.

Hipótesis 3 (Perceptrón Multicapa / MLP):Considerando que los perfiles de clientes que cancelan y los que permanecen se solapan en rangos intermedios de antigüedad y facturación, se puede proyectar la matriz de características a un espacio de mayor dimensión mediante una Máquina de Vectores de Soporte con kernel. La maximización del margen de separación sobre las entradas continuas estandarizadas permitirá trazar una frontera de decisión óptima para aislar los casos atípicos de fuga, optimizando los hiperparámetros mediante validación cruzada..

Hipótesis 4 (K-Vecinos Más Cercanos / KNN):Se puede aplicar el algoritmo de K-Vecinos Más Cercanos (KNN) para identificar si un cliente cancelará su servicio comparando su perfil con el de clientes históricos similares. Dado que KNN es altamente sensible a la escala y la dimensionalidad, se aplicará una reducción de dimensionalidad o selección de características priorizando variables de mayor impacto como antigüedad y contrato antes de determinar el parámetro óptimo mediante validación cruzada.

Quedamos atentos a sus observaciones. Muchas gracias.

#### Respuesta Docente
Un saludo equipo 7. 

Concuerdo con el comentario que les ha dejado la compañera Luisa en cuanto al planteamiento de la hipótesis 3. 

Además, para el momento de la crítica de la hipótesis, tener en cuenta que el modelo de KNN puede ser costoso desde la perspectiva computacional dado el tamaño de la base de datos. 


### G1: Hipótesis Solución
Buena tarde compañeros,

Como Grupo 1, les compartimos nuestras hipótesis a fin de obtener sus valiosos aportes.

Hipótesis 1, Regresión Logística: En primer lugar, planteamos la hipótesis basada en Regresión Logística. A partir del análisis exploratorio inicial observamos que los clientes que cancelan muestran en promedio la mitad de la antigüedad de quienes se quedan (18 meses frente a 37.6) y registran cargos mensuales sustancialmente más altos (74.4 frente a 61.3), con un 26.5% de cancelación en el conjunto de datos. Dado este comportamiento donde a menor permanencia y mayor costo aumenta la probabilidad de abandono, planteamos que una regresión logística con ajuste por desbalance de clases capturará adecuadamente esta tendencia general y permitirá identificar los factores con mayor peso en la decisión del cliente gracias a la transparencia de sus coeficientes, siguiendo los principios de modelado lineal y clasificación binaria expuestos por Hosmer et al. (2013).

Hipótesis 2, Random Forest: En segundo lugar, planteamos la hipótesis basada en Random Forest. Durante la exploración de datos notamos que la cancelación no depende de una sola variable, sino que suele concentrarse en un perfil específico que combina contratos mes a mes (42.7% de cancelación, frente a 2.8% en contratos de dos años), pagos por factura electrónica y ausencia de servicios adicionales como soporte técnico o seguridad. Planteamos que un ensamble de árboles de decisión capturará de forma efectiva estas interacciones no lineales y combinaciones entre servicios que un modelo lineal simple no logra identificar, fundamentándonos en la capacidad de generalización y reducción de varianza descrita por Breiman (2001) para este tipo de algoritmos.

Hipótesis 3, Gradient Boosting: En tercer lugar, planteamos la hipótesis basada en Gradient Boosting. El análisis previo sugiere que existen patrones difusos y casos límite entre los clientes de antigüedad intermedia (entre 9 y 55 meses) que hacen difícil definir una frontera clara de decisión. Planteamos que un esquema de aprendizaje secuencial, orientado a corregir de forma iterativa las clasificaciones erróneas de las etapas anteriores como proponen Friedman (2001) y Hastie et al. (2009), logrará refinar la frontera entre ambas clases con mayor dinamismo y ofrecerá el nivel de discriminación más preciso de todo el experimento para este conjunto de datos.

Hipótesis 4, Support Vector Machines: En cuarto lugar, planteamos la hipótesis basada en Support Vector Machines. Al examinar el comportamiento conjunto de los cargos, la antigüedad y los servicios contratados dentro del conjunto de datos Telco Customer Churn de IBM Cognos Analytics, encontramos que el método Electronic check concentra un 45.3% de cancelación frente a 15-17% en los pagos automáticos, lo que insinúa que los grupos de clientes que cancelan y que permanecen no son fácilmente separables mediante una línea o plano sencillo. Planteamos que proyectar las características a un espacio de mayor dimensión mediante una función de kernel RBF, basada en la teoría del margen máximo de Cortes y Vapnik (1995), permitirá encontrar un hiperplano óptimo para aislar a los clientes propensos al abandono, reduciendo los errores de clasificación a cambio de una menor explicabilidad directa hacia el negocio.

Cordial saludo,

Ana, Dayner, Edgar Orlando
#### Respuesta Docente
Un saludo. 

Las hipótesis cumplen todos los requisitos establecidos. 

### GX: Hipótesis Solución
Hola a todos!

Enviamos la propuesta de las hipótesis para revisión relacionadas con el caso de Telco Customer Churn. 

Gracias

Alejandro Diaz, Santiago Castañeda y Luisa F. Espinel.

 

Hipótesis 1. Regresión Logística

Para predecir si un cliente de telecomunicaciones cancelará o continuará con los servicios, dado que la variable de salida churm tiene únicamente dos categorías (Yes y No); así mismo, los coeficientes se interpretan como la razón de las posibilidades que permiten priorizar campañas de retención. Esta técnica permitirá estimar la probabilidad de fuga de cada cliente y ofrecer una solución interpretable para identificar las variables asociadas con un mayor o menor riesgo de cancelación. Debido a que la base contiene atributos categóricos y numéricos, será necesario convertir las variables categóricas mediante codificación one-hot, eliminar los niveles redundantes "No internet service" y "No phone service", que reproducen información ya contenida en InternetService y PhoneService, y descartar uno de los atributos numéricos por la dependencia TotalCharges ≈ tenure × MonthlyCharges, ya que la regresión logística es sensible a atributos linealmente dependientes. El modelo será evaluado mediante validación cruzada estratificada y una muestra de prueba independiente, utilizando principalmente las métricas ROC-AUC, recall, precision, F1 y PR-AUC.

Hipótesis 2. Random Forest          
Para clasificar a un cliente de telecomunicaciones como posible caso de fuga o permanencia, utilizando información como antigüedad, tipo de contrato, servicios adquiridos, forma de pago y cargos mensuales y totales, se puede emplear la técnica Random Forest balanceado, dado que este algoritmo permite identificar relaciones no lineales e interacciones entre múltiples características sin necesidad de establecerlas previamente. La base contiene 7,043 registros y una combinación de atributos categóricos y numéricos, cantidad suficiente para construir un conjunto de árboles y reducir la variabilidad que tendría un árbol de decisión individual. Para utilizar esta técnica será necesario convertir los atributos categóricos mediante codificación one-hot, transformar TotalCharges a formato numérico e imputar sus valores faltantes. Debido a que los clientes con churn representan una proporción menor de la base, se utilizará ponderación de clases para disminuir el sesgo hacia la categoría mayoritaria. El modelo será evaluado mediante validación cruzada estratificada y una muestra de prueba independiente, utilizando las mismas métricas y particiones aplicadas a la regresión logística para garantizar una comparación objetiva.

Hipótesis 3. Perceptrón Multicapa 

Para predecir el abandono capturando interacciones entre atributos que un modelo lineal no representa, se puede utilizar un perceptrón multicapa. Para ello será necesario convertir a numéricos los 16 atributos categóricos y estandarizar los tres numéricos, cuyas escalas difieren en dos órdenes de magnitud. Dado que solo el 26.5% de los registros ilustra la clase de los clientes que abandonan, se deben aplicar técnicas de sobremuestreo con SMOTE-NC, apropiada para conjuntos que mezclan atributos numéricos y categóricos, aplicada únicamente dentro de cada partición de entrenamiento para no contaminar la evaluación.

Hipótesis 4. Maquina de vectores de soporte

Para predecir si un cliente cancelará o continuará con los servicios de telecomunicaciones, a partir de sus características demográficas, contractuales, de facturación y de servicios contratados, se puede utilizar una máquina de vectores de soporte con kernel radial RBF, dado que esta técnica permite construir fronteras de clasificación no lineales cuando las categorías no pueden separarse adecuadamente mediante una relación lineal. Debido a que la técnica requiere entradas completamente numéricas y es sensible a las diferencias de escala, será necesario convertir las variables categóricas mediante codificación one-hot, transformar TotalCharges a formato numérico, imputar los valores faltantes y estandarizar las variables numéricas. También será necesario ponderar las clases para atender la menor representación de los clientes con churn. Los hiperparámetros C y gamma deberán estimarse mediante búsqueda de combinaciones y validación cruzada estratificada. Para obtener probabilidades comparables con las de los otros modelos, será necesario activar el cálculo de probabilidades o aplicar un procedimiento adicional de calibración.

#### Respuesta Docente
Un saludo para todos. 

En general, buenas hipótesis. Sin embargo, es necesario que sean un poco más específicos en los detalles de cada hipótesis; en particular, no es claro como llevarán a cabo la conversión de las variables categóricas. 



## Rúbrica de formulación de hipótesis



|Criterios|Si|No|Observaciones|
|-|-|-|-|
|Describe una manera de solucionar el problema.|-|-|
|Menciona requerimientos sobre los datos a utilizar.|-|-|
|Define claramente la técnica que se va a aplicar.|-|-|
|Es coherente la propuesta.|-|-|
