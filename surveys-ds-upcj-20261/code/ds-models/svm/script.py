from sklearn.svm import SVC
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

# Estandarizar — SVM es muy sensible a la escala
scaler = StandardScaler()
X_train_s = scaler.fit_transform(X_train)
X_test_s  = scaler.transform(X_test)

# Kernel lineal vs RBF (no lineal)
for kernel in ['linear', 'rbf']:
    modelo = SVC(kernel=kernel, random_state=42)
    modelo.fit(X_train_s, y_train)
    print(f"=== SVM kernel={kernel} ===")
    print(f"Train accuracy: {accuracy_score(y_train, modelo.predict(X_train_s)):.4f}")
    print(f"Test  accuracy: {accuracy_score(y_test,  modelo.predict(X_test_s)):.4f}")
    print(f"\nReporte:\n{classification_report(y_test, modelo.predict(X_test_s))}\n")