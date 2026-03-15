import numpy as np
from sklearn.model_selection import train_test_split
import matplotlib.pyplot as plt
from sklearn.inspection import permutation_importance
from sklearn.datasets import make_classification
from sklearn.linear_model import LogisticRegression
import os


# Path principal
CURRENT_PATH = os.getcwd()



# Generate example dataset
X, y = make_classification(n_samples=51000, n_features=15, random_state=42)

# Train/Test split
X_train, X_test, y_train, y_test = train_test_split(
    X, y, 
    test_size=0.2, 
    random_state=42,
    stratify=y
)


model = LogisticRegression()

# Entrenamos el modelo
model.fit(X_train, y_train)

# Sensibilidad por permutación: aleatoriza cada variable y mide cuánto baja el score
result = permutation_importance(
    model, X_test, y_test,
    n_repeats=30,        # 30 permutaciones por variable
    random_state=42,
    scoring="accuracy"
)

# Ordenar por importancia
indices = result.importances_mean.argsort()[::-1]

plt.barh(
    range(X_test.shape[1]),
    result.importances_mean[indices],
    xerr=result.importances_std[indices]
)
plt.yticks(range(X_test.shape[1]), [f"Feature {i}" for i in indices])
plt.title("Análisis de Sensibilidad - Permutation Importance")
plt.xlabel("Caída en Accuracy al permutar la variable")
plt.tight_layout()

filepath = f'{CURRENT_PATH}/analisis-sensibility/analisis.png'
plt.savefig(filepath, dpi=600)