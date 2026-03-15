from sklearn.model_selection import StratifiedKFold, cross_val_score
from sklearn.linear_model import LogisticRegression
from sklearn.datasets import make_classification
from sklearn.model_selection import train_test_split


# Generate example dataset
X, y = make_classification(n_samples=15000, n_features=32, random_state=42)

model = LogisticRegression()
skf = StratifiedKFold(n_splits=5, shuffle=True, random_state=42)

scores = cross_val_score(model, X, y, cv=skf, scoring="f1")

print(f"F1 por fold  : {scores.round(4)}")
print(f"Media F1     : {scores.mean():.4f}")
print(f"Std          : {scores.std():.4f}")

# Verificar proporción de clases por fold
for i, (train_idx, val_idx) in enumerate(skf.split(X, y)):
    prop = y[val_idx].mean()
    print(f"Fold {i+1} - Proporción clase positiva: {prop:.3f}")