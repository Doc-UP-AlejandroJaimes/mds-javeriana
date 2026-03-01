import numpy as np
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score, classification_report, confusion_matrix
from sklearn.preprocessing import StandardScaler

np.random.seed(42)

# Datos: predecir tumor maligno (1) o benigno (0)
n = 300
edad   = np.random.normal(50, 15, n).clip(20, 85)
tamano = np.random.normal(3, 1.5, n).clip(0.5, 8)
z      = -6 + 0.05 * edad + 1.2 * tamano
y      = np.random.binomial(1, 1 / (1 + np.exp(-z)))  # clases reales
X      = np.column_stack([edad, tamano])

# Split y estandarización (importante en regresión logística)
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.25, random_state=42)
scaler  = StandardScaler()
X_train = scaler.fit_transform(X_train)
X_test  = scaler.transform(X_test)

# Entrenamiento
modelo = LogisticRegression()
modelo.fit(X_train, y_train)

# Predicción
y_pred = modelo.predict(X_test)
y_prob = modelo.predict_proba(X_test)[:, 1]  # probabilidad de clase 1

# Métricas
print(f"Accuracy:  {accuracy_score(y_test, y_pred):.4f}")
print(f"\nReporte:\n{classification_report(y_test, y_pred)}")
print(f"Matriz de confusión:\n{confusion_matrix(y_test, y_pred)}")