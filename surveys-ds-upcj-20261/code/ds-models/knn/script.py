from sklearn.neighbors import KNeighborsClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score, classification_report
from sklearn.preprocessing import StandardScaler
import numpy as np

np.random.seed(42)

n = 300
edad   = np.random.normal(50, 15, n).clip(20, 85)
tamano = np.random.normal(3, 1.5, n).clip(0.5, 8)
z      = -6 + 0.05 * edad + 1.2 * tamano
y      = np.random.binomial(1, 1 / (1 + np.exp(-z)))
X      = np.column_stack([edad, tamano])

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.25, random_state=42)

scaler    = StandardScaler()
X_train_s = scaler.fit_transform(X_train)
X_test_s  = scaler.transform(X_test)

# Probar distintos valores de K
print("=== Efecto de K ===")
for k in [1, 3, 5, 7, 11, 15, 21]:
    modelo = KNeighborsClassifier(n_neighbors=k)
    modelo.fit(X_train_s, y_train)
    train_acc = accuracy_score(y_train, modelo.predict(X_train_s))
    test_acc  = accuracy_score(y_test,  modelo.predict(X_test_s))
    print(f"K={k:>2} | Train: {train_acc:.4f} | Test: {test_acc:.4f}")

# Reporte con el mejor K
print("\n=== Reporte K=7 ===")
modelo_final = KNeighborsClassifier(n_neighbors=7)
modelo_final.fit(X_train_s, y_train)
print(classification_report(y_test, modelo_final.predict(X_test_s)))