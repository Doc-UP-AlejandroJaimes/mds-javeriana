# Índice — Unidad 1: Modelos Estadísticos para la Toma de Decisiones

Curso: **Modelos Estadísticos para la toma de decisiones**
Unidad 1: Métodos descriptivos multivariados.

Este material fue dividido en un archivo por sesión/tema, siguiendo exactamente los documentos originales entregados, para conservar el 100% del contenido (texto, fórmulas, código en R, salidas y retos) con mejor contexto por separado.

## Archivos de la Unidad 1

1. **[00-introduccion.md](./00-introduccion.md)** — Experiencia, proceso de datos, modelos más utilizados, aplicaciones destacadas y contenido general de la unidad. *(fuente: `introduccion00.txt`)*
2. **[01-conceptos-generales-univariado-bivariado-multivariado.md](./01-conceptos-generales-univariado-bivariado-multivariado.md)** — De lo univariado a lo multivariado: ejemplos univariado, bivariado (cualitativa-cualitativa, cualitativa-cuantitativa, cuantitativa-cuantitativa) y multivariado. *(fuente: `conceptosgenerales01.txt`)*
3. **[02-tablas-de-contingencia.md](./02-tablas-de-contingencia.md)** — Tablas de contingencia, prueba chi-cuadrado de Pearson, ejemplo y usos en ciencia de datos. *(fuente: `conceptosgenerales02.txt`)*
4. **[03-matriz-varianza-covarianza-correlaciones.md](./03-matriz-varianza-covarianza-correlaciones.md)** — Matriz de varianzas-covarianzas ($\Sigma$) y matriz de correlaciones ($R$), usos, ejemplo con `rotacion`. *(fuente: `conceptosgenerales03.txt`)*
5. **[04-acp-conceptos.md](./04-acp-conceptos.md)** — Análisis de Componentes Principales: conceptos, notación, derivación matemática completa (Lagrange). *(fuente: `acp01.txt`)*
6. **[05-acp-ejemplo.md](./05-acp-ejemplo.md)** — ACP aplicado a la base `creditos` (780 clientes de un banco), interpretación de componentes y biplot. *(fuente: `acp02.txt`)*
7. **[06-conglomerados-conceptos.md](./06-conglomerados-conceptos.md)** — Análisis de Conglomerados: conceptos, distancias, criterios de calidad, métodos jerárquicos/no jerárquicos. *(fuente: `analiconglomerados01.txt`)*
8. **[07-conglomerados-ejemplo.md](./07-conglomerados-ejemplo.md)** — Clustering jerárquico aplicado a 8 empresas, dendograma, elección de k, índice de Silhouette. *(fuente: `analiconglomerados02.txt`)*
9. **[08-correspondencia-conceptos.md](./08-correspondencia-conceptos.md)** — Análisis de Correspondencia: chi-cuadrado, matriz de discrepancias, factorización SVD, coordenadas filas/columnas. *(fuente: `analicorrespondencia01.txt`)*
10. **[09-correspondencia-ejemplo.md](./09-correspondencia-ejemplo.md)** — Análisis de correspondencia aplicado a `zona` vs `estrato` (base `vivienda`), con `FactoMineR::CA()`. *(fuente: `analicorrespondencia02.txt`)*

## Retos pendientes de la unidad (todos sobre la base `rotacion` de `paqueteMODELOS`, salvo el indicado)

- **Conceptos generales:** interpretar la relación `estrato` vs `zona` (archivo 02) e identificar variables altamente correlacionadas en `rotacion` (archivo 03).
- **ACP (archivo 05):** construir 2 componentes principales que reduzcan variables sin perder información.
- **Conglomerados (archivo 07):** agrupar empleados en segmentos.
- **Correspondencia (archivo 09):** asociación entre Educación–Departamento y Satisfacción laboral–Equilibrio Trabajo-Vida.
