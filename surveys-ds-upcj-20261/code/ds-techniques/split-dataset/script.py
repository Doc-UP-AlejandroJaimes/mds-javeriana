from sklearn.model_selection import train_test_split
from sklearn.datasets import make_classification

# Generate example dataset
X, y = make_classification(n_samples=45189, n_features=5, random_state=42)

# Train/Test split
X_train, X_test, y_train, y_test = train_test_split(
    X, y, 
    test_size=0.2, 
    random_state=42,
    stratify=y
)

print(f"Train: {X_train.shape[0]} registros")
print(f"Test:  {X_test.shape[0]} registros")