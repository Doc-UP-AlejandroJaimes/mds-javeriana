from sklearn.model_selection import TimeSeriesSplit, cross_val_score
from sklearn.linear_model import LogisticRegression
import matplotlib.pyplot as plt
from sklearn.datasets import make_classification
import os


# Path principal
CURRENT_PATH = os.getcwd()


model = LogisticRegression()
tscv = TimeSeriesSplit(n_splits=5)

# Generate example dataset
X, y = make_classification(n_samples=15000, n_features=32, random_state=42)

scores = cross_val_score(model, X, y, cv=tscv, scoring="accuracy")

print(f"Scores temporales : {scores.round(4)}")
print(f"Media             : {scores.mean():.4f}")

# Visualización de los folds
fig, ax = plt.subplots(figsize=(10, 4))
for i, (train_idx, val_idx) in enumerate(tscv.split(X)):
    ax.barh(i, len(train_idx), color="steelblue", label="Train" if i == 0 else "")
    ax.barh(i, len(val_idx), left=len(train_idx), color="orange", label="Val" if i == 0 else "")
ax.set_title("Time Series Split - Folds")
ax.legend();

# Save
filepath = f'{CURRENT_PATH}/temporal-series/series.png'
plt.savefig(filepath, dpi=300)