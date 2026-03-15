from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.datasets import make_classification
from sklearn.metrics import confusion_matrix, ConfusionMatrixDisplay, precision_score
import matplotlib.pyplot as plt
import os


# Path principal
CURRENT_PATH = os.getcwd()

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

# Precision
tp = cm[0][0]
fp = cm[1][0]

precision = tp / (tp + fp)
print(f'Precision: {precision:.4f}')