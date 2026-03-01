from sklearn.neural_network import MLPClassifier
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

# Tres arquitecturas distintas para comparar
arquitecturas = {
    "Pequeña  (1 capa,  8 neuronas)": (8,),
    "Mediana  (2 capas, 16-8)":       (16, 8),
    "Grande   (3 capas, 32-16-8)":    (32, 16, 8),
}

for nombre, capas in arquitecturas.items():
    modelo = MLPClassifier(
        hidden_layer_sizes=capas,
        activation='relu',       # función de activación
        max_iter=500,
        random_state=42
    )
    modelo.fit(X_train_s, y_train)
    train_acc = accuracy_score(y_train, modelo.predict(X_train_s))
    test_acc  = accuracy_score(y_test,  modelo.predict(X_test_s))
    print(f"=== Red {nombre} ===")
    print(f"Train: {train_acc:.4f} | Test: {test_acc:.4f}")

# Reporte del modelo mediano
modelo_final = MLPClassifier(hidden_layer_sizes=(16, 8), activation='relu', max_iter=500, random_state=42)
modelo_final.fit(X_train_s, y_train)
print(f"\nReporte modelo mediano:\n{classification_report(y_test, modelo_final.predict(X_test_s))}")
print(f"Iteraciones hasta converger: {modelo_final.n_iter_}")