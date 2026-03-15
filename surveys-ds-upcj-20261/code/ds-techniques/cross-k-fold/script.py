from sklearn.model_selection import KFold, cross_val_score
from sklearn.linear_model import LogisticRegression

from sklearn.datasets import make_classification

# Generate example dataset
X, y = make_classification(n_samples=45189, n_features=5, random_state=42)


model = LogisticRegression()
kf = KFold(n_splits=5, shuffle=True, random_state=42)

scores = cross_val_score(model, X, y, cv=kf, scoring="accuracy")


print(f"Scores por fold : {scores.round(4)}")
print(f"Media           : {scores.mean():.4f}")
print(f"Desviación std  : {scores.std():.4f}")

# A lower std indicated stability among folds