from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.datasets import make_classification
from sklearn.metrics import confusion_matrix, f1_score
import matplotlib.pyplot as plt
import os


# Generate example dataset
X, y = make_classification(n_samples=1000, n_features=5, random_state=42)

# Train/Test split
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42
)

# Train model
model = LogisticRegression()
model.fit(X_train, y_train)

# Predictions
y_pred = model.predict(X_test)

# Confusion matrix
cm = confusion_matrix(y_test, y_pred)

# F1 Score
f1 = f1_score(y_test, y_pred, pos_label=1)
print(f"F1-Score: {f1:.4f}")

# Para múltiples clases
f1_macro = f1_score(y_test, y_pred, average="macro", pos_label=1)
print(f"F1-Score Macro: {f1_macro:.4f}")