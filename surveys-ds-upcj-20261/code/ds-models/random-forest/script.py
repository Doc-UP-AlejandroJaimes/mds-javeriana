from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score, classification_report
import numpy as np

np.random.seed(42)

n = 300
edad   = np.random.normal(50, 15, n).clip(20, 85)
tamano = np.random.normal(3, 1.5, n).clip(0.5, 8)
z      = -6 + 0.05 * edad + 1.2 * tamano
y      = np.random.binomial(1, 1 / (1 + np.exp(-z)))
X      = np.column_stack([edad, tamano])

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.25, random_state=42)

modelo_rf = RandomForestClassifier(n_estimators=100, max_depth=4, random_state=42)
modelo_rf.fit(X_train, y_train)

print("=== Random Forest ===")
print(f"Train accuracy: {accuracy_score(y_train, modelo_rf.predict(X_train)):.4f}")
print(f"Test  accuracy: {accuracy_score(y_test,  modelo_rf.predict(X_test)):.4f}")
print(f"\nImportancia de variables:")
for nombre, imp in zip(["edad", "tamaño"], modelo_rf.feature_importances_):
    print(f"  {nombre}: {imp:.4f}")
print(f"\nReporte:\n{classification_report(y_test, modelo_rf.predict(X_test))}")