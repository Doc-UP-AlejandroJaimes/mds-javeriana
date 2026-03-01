from sklearn.tree import DecisionTreeClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score, classification_report
from sklearn.preprocessing import StandardScaler
import numpy as np

np.random.seed(42)

# Mismos datos de tumor
n = 300
edad   = np.random.normal(50, 15, n).clip(20, 85)
tamano = np.random.normal(3, 1.5, n).clip(0.5, 8)
z      = -6 + 0.05 * edad + 1.2 * tamano
y      = np.random.binomial(1, 1 / (1 + np.exp(-z)))
X      = np.column_stack([edad, tamano])

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.25, random_state=42)

# Árbol sin limitar → sobreajuste
arbol_libre = DecisionTreeClassifier(random_state=42)
arbol_libre.fit(X_train, y_train)

# Árbol podado → mejor generalización
arbol_podado = DecisionTreeClassifier(max_depth=4, random_state=42)
arbol_podado.fit(X_train, y_train)

print("=== Sin limitar (max_depth=None) ===")
print(f"Train accuracy: {accuracy_score(y_train, arbol_libre.predict(X_train)):.4f}")
print(f"Test  accuracy: {accuracy_score(y_test,  arbol_libre.predict(X_test)):.4f}")

print("\n=== Podado (max_depth=4) ===")
print(f"Train accuracy: {accuracy_score(y_train, arbol_podado.predict(X_train)):.4f}")
print(f"Test  accuracy: {accuracy_score(y_test,  arbol_podado.predict(X_test)):.4f}")

print("\nReporte árbol podado:")
print(classification_report(y_test, arbol_podado.predict(X_test)))