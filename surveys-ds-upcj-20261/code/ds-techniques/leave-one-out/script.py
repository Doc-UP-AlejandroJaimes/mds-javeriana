from sklearn.model_selection import LeaveOneOut, cross_val_score
from sklearn.linear_model import LogisticRegression

from sklearn.datasets import make_classification
import numpy as np

# Generate example dataset
X, y = make_classification(n_samples=300, n_features=32, random_state=42)

# ⚠️ Solo usar con datasets pequeños
X_small, y_small = X[:200], y[:200]

model = LogisticRegression()
loo = LeaveOneOut()

scores = cross_val_score(model, X_small, y_small, cv=loo, scoring="accuracy")

print(f"Observaciones evaluadas : {len(scores)}")
print(f"Accuracy promedio        : {scores.mean():.4f}")
print(f"Desviación std           : {scores.std():.4f}")