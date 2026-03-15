from sklearn.model_selection import KFold, GridSearchCV, cross_val_score
from sklearn.linear_model import LogisticRegression
from sklearn.datasets import make_classification


# Generate example dataset
X, y = make_classification(n_samples=15000, n_features=32, random_state=42)

# Bucle interno: optimiza hiperparámetros
inner_cv = KFold(n_splits=3, shuffle=True, random_state=42)
# Bucle externo: evalúa rendimiento real
outer_cv = KFold(n_splits=5, shuffle=True, random_state=42)

param_grid = {"C": [0.01, 0.1, 1, 10]}
model = LogisticRegression()

# GridSearch actúa como bucle interno
clf = GridSearchCV(estimator=model, param_grid=param_grid, cv=inner_cv)

# Cross_val_score actúa como bucle externo
nested_scores = cross_val_score(clf, X, y, cv=outer_cv, scoring="accuracy")

print(f"Nested CV Scores : {nested_scores.round(4)}")
print(f"Media            : {nested_scores.mean():.4f}")
print(f"Std              : {nested_scores.std():.4f}")