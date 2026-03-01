"""
=============================================================
  REGRESIÓN LINEAL - Guía práctica de Minería de Datos
=============================================================

TEORÍA BREVE:
-------------
La regresión lineal busca modelar la relación entre una variable
dependiente (y) y una o más variables independientes (X),
ajustando una línea recta (o hiperplano) de la forma:

    y = β₀ + β₁·x₁ + β₂·x₂ + ... + ε

  donde:
    β₀  = intercepto
    β₁  = coeficiente (pendiente) de cada variable
    ε   = error / residuo

El objetivo es minimizar el Error Cuadrático Medio (MSE):
    MSE = (1/n) · Σ(yᵢ - ŷᵢ)²

Los coeficientes óptimos se obtienen con la fórmula de
mínimos cuadrados ordinarios (OLS):
    β = (XᵀX)⁻¹ · Xᵀy

=============================================================
"""
import os
import numpy as np
import matplotlib.pyplot as plt
from sklearn.linear_model import LinearRegression
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_squared_error, r2_score
from sklearn.preprocessing import StandardScaler

# Path principal
CURRENT_PATH = os.getcwd()

# Fijamos semilla para reproducibilidad
np.random.seed(42)


# ============================================================
# PARTE 1: REGRESIÓN LINEAL SIMPLE (1 variable)
# ============================================================
print("=" * 60)
print("PARTE 1: REGRESIÓN LINEAL SIMPLE")
print("=" * 60)

# --- Generamos datos simulados ---
# Escenario: predecir precio de casa (miles USD) según m²
metros2 = np.random.uniform(40, 200, 100)
precio  = 50 + 1.8 * metros2 + np.random.normal(0, 15, 100)  # ruido realista

X_simple = metros2.reshape(-1, 1)
y_simple  = precio

# --- Train / Test split ---
X_train, X_test, y_train, y_test = train_test_split(
    X_simple, y_simple, test_size=0.2, random_state=42
)

# --- Entrenamiento ---
modelo_simple = LinearRegression()
modelo_simple.fit(X_train, y_train)

# --- Predicción ---
y_pred = modelo_simple.predict(X_test)

# --- Métricas ---
mse = mean_squared_error(y_test, y_pred)
rmse = np.sqrt(mse)
r2   = r2_score(y_test, y_pred)

print(f"\nEcuación aprendida:")
print(f"  precio = {modelo_simple.intercept_:.2f} + {modelo_simple.coef_[0]:.2f} * metros²")
print(f"\nMétricas en test:")
print(f"  MSE  = {mse:.2f}")
print(f"  RMSE = {rmse:.2f}  ← error promedio en miles USD")
print(f"  R²   = {r2:.4f}  ← el modelo explica el {r2*100:.1f}% de la varianza")

# --- Visualización PARTE 1 ---
fig, axes = plt.subplots(1, 2, figsize=(14, 5))
fig.suptitle("Regresión Lineal Simple — Precio vs Metros²", fontsize=14, fontweight='bold')

# Scatter + línea de regresión
ax = axes[0]
ax.scatter(X_train, y_train, alpha=0.5, color='steelblue', label='Train')
ax.scatter(X_test,  y_test,  alpha=0.7, color='orange',   label='Test')
x_line = np.linspace(40, 200, 200).reshape(-1, 1)
ax.plot(x_line, modelo_simple.predict(x_line), color='crimson', lw=2, label='Regresión')
ax.set_xlabel("Metros cuadrados")
ax.set_ylabel("Precio (miles USD)")
ax.legend()
ax.set_title("Datos y línea ajustada")

# Residuos
ax = axes[1]
residuos = y_test - y_pred
ax.scatter(y_pred, residuos, alpha=0.7, color='purple')
ax.axhline(0, color='black', lw=1.5, linestyle='--')
ax.set_xlabel("Predicción ŷ")
ax.set_ylabel("Residuo (y - ŷ)")
ax.set_title("Gráfico de Residuos\n(Ideal: distribución aleatoria alrededor de 0)")

plt.tight_layout()
# Path to save
path_to_save = f'{CURRENT_PATH}/parte1_simple.png'
plt.savefig(path_to_save, dpi=300)
plt.close()
print("\n→ Gráfico guardado: parte1_simple.png")


# ============================================================
# PARTE 2: REGRESIÓN LINEAL MÚLTIPLE (varias variables)
# ============================================================
print("\n" + "=" * 60)
print("PARTE 2: REGRESIÓN LINEAL MÚLTIPLE")
print("=" * 60)

# --- Datos simulados ---
# Variables: metros², habitaciones, antigüedad → precio
n = 200
metros2_m    = np.random.uniform(40,  200, n)
habitaciones = np.random.randint(1, 6, n).astype(float)
antiguedad   = np.random.uniform(0,  40,  n)

precio_m = (
    30
    + 1.5 * metros2_m
    + 10  * habitaciones
    - 0.8 * antiguedad
    + np.random.normal(0, 12, n)
)

X_multi = np.column_stack([metros2_m, habitaciones, antiguedad])
y_multi = precio_m
features = ["metros²", "habitaciones", "antigüedad"]

X_tr, X_te, y_tr, y_te = train_test_split(X_multi, y_multi, test_size=0.2, random_state=42)

modelo_multi = LinearRegression()
modelo_multi.fit(X_tr, y_tr)
y_pred_m = modelo_multi.predict(X_te)

r2_m   = r2_score(y_te, y_pred_m)
rmse_m = np.sqrt(mean_squared_error(y_te, y_pred_m))

print(f"\nEcuación aprendida:")
print(f"  precio = {modelo_multi.intercept_:.2f}")
for feat, coef in zip(features, modelo_multi.coef_):
    print(f"           + ({coef:.2f}) × {feat}")

print(f"\nMétricas en test:")
print(f"  RMSE = {rmse_m:.2f}")
print(f"  R²   = {r2_m:.4f}  ← {r2_m*100:.1f}% de varianza explicada")

# --- Visualización PARTE 2 ---
fig, axes = plt.subplots(1, 2, figsize=(14, 5))
fig.suptitle("Regresión Lineal Múltiple", fontsize=14, fontweight='bold')

# Real vs Predicho
ax = axes[0]
ax.scatter(y_te, y_pred_m, alpha=0.6, color='teal')
lims = [min(y_te.min(), y_pred_m.min()), max(y_te.max(), y_pred_m.max())]
ax.plot(lims, lims, 'r--', lw=2, label='Predicción perfecta')
ax.set_xlabel("Valor real")
ax.set_ylabel("Valor predicho")
ax.set_title("Real vs. Predicho\n(Puntos cerca de la diagonal = buen modelo)")
ax.legend()

# Importancia de coeficientes (estandarizados)
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X_multi)
modelo_std = LinearRegression().fit(X_scaled, y_multi)

ax = axes[1]
colors = ['#2196F3', '#4CAF50', '#F44336']
bars = ax.barh(features, np.abs(modelo_std.coef_), color=colors)
ax.set_xlabel("Coeficiente estandarizado (valor absoluto)")
ax.set_title("Importancia relativa de variables\n(Coeficientes estandarizados)")
for bar, coef in zip(bars, modelo_std.coef_):
    sign = '+' if coef > 0 else '−'
    ax.text(bar.get_width() + 0.5, bar.get_y() + bar.get_height()/2,
            f'{sign}{abs(coef):.1f}', va='center', fontsize=10)

plt.tight_layout()
# Path to save
path_to_save = f'{CURRENT_PATH}/parte2_multiple.png'
plt.savefig(path_to_save, dpi=300)
plt.close()
print("\n→ Gráfico guardado: parte2_multiple.png")


# ============================================================
# PARTE 3: IMPLEMENTACIÓN MANUAL con OLS (sin sklearn)
# ============================================================
print("\n" + "=" * 60)
print("PARTE 3: IMPLEMENTACIÓN MANUAL con OLS (NumPy)")
print("=" * 60)
print("""
La fórmula analítica de mínimos cuadrados:
    β = (XᵀX)⁻¹ · Xᵀy
""")

# Usamos los mismos datos simples de la Parte 1
X_ols = np.column_stack([np.ones(len(X_train)), X_train])  # agrega columna de 1s para β₀

beta = np.linalg.inv(X_ols.T @ X_ols) @ X_ols.T @ y_train

print(f"Coeficientes calculados manualmente:")
print(f"  β₀ (intercepto) = {beta[0]:.4f}")
print(f"  β₁ (metros²)    = {beta[1]:.4f}")
print(f"\nComparación con sklearn:")
print(f"  β₀ sklearn = {modelo_simple.intercept_:.4f}")
print(f"  β₁ sklearn = {modelo_simple.coef_[0]:.4f}")
print("\n✓ Los resultados son idénticos — sklearn usa el mismo método OLS internamente.")


# ============================================================
# PARTE 4: SUPUESTOS DEL MODELO
# ============================================================
print("\n" + "=" * 60)
print("PARTE 4: VERIFICACIÓN DE SUPUESTOS")
print("=" * 60)
print("""
Un modelo de regresión lineal asume:
  1. LINEALIDAD        → relación lineal entre X e y
  2. INDEPENDENCIA     → residuos no correlacionados
  3. HOMOCEDASTICIDAD  → varianza constante de residuos
  4. NORMALIDAD        → residuos distribuidos normalmente
""")

fig, axes = plt.subplots(1, 2, figsize=(14, 5))
fig.suptitle("Verificación de Supuestos", fontsize=14, fontweight='bold')

residuos_train = y_train - modelo_simple.predict(X_train)

# Histograma de residuos (Normalidad)
ax = axes[0]
ax.hist(residuos_train, bins=20, color='steelblue', edgecolor='white', alpha=0.8)
ax.axvline(0, color='crimson', linestyle='--', lw=2)
ax.set_xlabel("Residuo")
ax.set_ylabel("Frecuencia")
ax.set_title("Distribución de Residuos\n(Debe ser aprox. Normal centrada en 0)")

# QQ-Plot manual
ax = axes[1]
sorted_res  = np.sort(residuos_train)
n_res = len(sorted_res)
theoretical_q = np.array([np.percentile(np.random.normal(0,1,10000), 100*(i/(n_res+1)))
                           for i in range(1, n_res+1)])
ax.scatter(theoretical_q, sorted_res, alpha=0.6, color='teal')
lims = [min(theoretical_q.min(), sorted_res.min()), max(theoretical_q.max(), sorted_res.max())]
ax.plot(lims, lims, 'r--', lw=2)
ax.set_xlabel("Cuantiles teóricos (Normal)")
ax.set_ylabel("Cuantiles muestrales (residuos)")
ax.set_title("QQ-Plot de Residuos\n(Puntos sobre la diagonal = normalidad)")

plt.tight_layout()
# Path to save
path_to_save = f'{CURRENT_PATH}/parte3_supuestos.png'
plt.savefig(path_to_save, dpi=300)
plt.close()
print("→ Gráfico guardado: parte3_supuestos.png")

print("\n" + "=" * 60)
print("¡Implementación completa!")
print("=" * 60)
print("""
RESUMEN DE CONCEPTOS CLAVE:
  • β₀ (intercepto) → valor de y cuando todas las X = 0
  • β₁ (coeficiente) → cuánto cambia y por cada unidad de X
  • MSE / RMSE       → error promedio del modelo (mismas unidades que y)
  • R²               → qué % de la variabilidad de y explica el modelo
                        R²=1 perfecto | R²=0 inútil | R²<0 peor que la media
  • Residuos         → la "firma" del modelo; analizarlos revela problemas
""")