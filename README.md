# Rossmann Retail Sales Forecasting

## Project Overview

This project builds a machine learning solution to forecast daily sales for Rossmann retail stores using historical sales, store characteristics, promotions, competition information, holidays, and calendar-based features.

The project follows an end-to-end machine learning workflow including exploratory data analysis, feature engineering, chronological validation, model comparison, hyperparameter tuning, error analysis, feature importance, and model persistence.

The final model is a tuned **XGBoost Regressor**, which achieved an **R² score of 0.8814** and **RMSPE of 18.27%** on the chronological validation period.

---

## Business Problem

Retail stores require reliable sales forecasts to support decisions related to:

- Inventory planning
- Staffing
- Promotional strategies
- Store operations
- Demand planning

The objective of this project is to predict daily Rossmann store sales using historical store and sales information.

The target variable is:

**Sales**

---

## Dataset

The project uses the Rossmann Store Sales dataset.

The main files used are:

- `train.csv` — historical daily store observations containing the target `Sales`
- `store.csv` — store-level information including store type, assortment, competition, and Promo2 information

> **Note:** `train.csv` is not included in this repository because of its large file size. It must be downloaded separately and placed in the working directory before running the notebook.

The sales and store datasets are merged before exploratory analysis and model development.

---

## Project Workflow

The project follows the workflow below:

1. Data Loading and Inspection
2. Data Cleaning
3. Missing Value Treatment
4. Dataset Merging
5. Exploratory Data Analysis
6. Feature Engineering
7. Chronological Train-Validation Split
8. Removal of Closed Stores from Model Training
9. Categorical Encoding using ColumnTransformer
10. Baseline Model
11. Linear Regression
12. Random Forest Regressor
13. XGBoost Regressor
14. XGBoost Hyperparameter Tuning
15. Model Evaluation
16. Error Analysis
17. Feature Importance Analysis
18. Train vs Validation Performance Analysis
19. Final Model Saving

---

## Exploratory Data Analysis

EDA was performed to understand the relationship between sales and important retail factors such as:

- Customer footfall
- Promotions
- Day of week
- Store type
- Assortment
- State holidays
- School holidays
- Competition distance
- Monthly sales trends
- Monthly customer trends

Customer footfall showed a strong positive relationship with sales.

However, the `Customers` feature was excluded from the forecasting model because future customer counts would not normally be available at prediction time.

---

## Feature Engineering

Several new features were created from the available date, competition, and promotional information.

### Calendar Features

- `Year`
- `Month`
- `Day`
- `WeekOfYear`
- `Quarter`
- `IsWeekend`

### Competition Features

- `CompetitionInfoMissing`
- `CompetitionMonths`

### Promo2 Features

- `Promo2Months`
- `Promo2ThisMonth`

The original date and selected source columns used to generate these features were removed before model training.

---

## Validation Strategy

Since this is a forecasting problem, a **chronological validation split** was used instead of a random train-test split.

Historical observations were used for training while a later period was reserved for validation.

This approach better represents a real forecasting scenario:

**Past Data → Train Model → Predict Future Sales**

Closed-store observations were removed from model training because their sales are structurally zero and do not represent normal open-store demand.

---

## Data Preprocessing

Categorical variables were encoded using:

- `ColumnTransformer`
- `OneHotEncoder`

The preprocessing step was combined with the machine learning models using Scikit-learn pipelines.

Tree-based models such as Random Forest and XGBoost did not require numerical feature scaling.

---

## Models Evaluated

The following models were evaluated:

- Mean Sales Baseline
- Linear Regression
- Random Forest Regressor
- XGBoost Regressor
- Tuned XGBoost Regressor

---

## Model Performance

| Model | MAE | RMSE | RMSPE | R² |
|---|---:|---:|---:|---:|
| Mean Baseline | 2278.55 | 3118.90 | 55.66% | -0.0050 |
| Linear Regression | 1974.47 | 2677.64 | 48.50% | 0.2593 |
| Random Forest | 954.25 | 1404.00 | 20.37% | 0.7963 |
| XGBoost | 868.52 | 1180.36 | 20.45% | 0.8561 |
| **Tuned XGBoost** | **789.94** | **1071.64** | **18.27%** | **0.8814** |

The tuned XGBoost model achieved the strongest overall validation performance and was selected as the final model.

---

## XGBoost Hyperparameter Tuning

XGBoost was tuned using:

- `RandomizedSearchCV`
- `TimeSeriesSplit`

Time-aware cross-validation was used to preserve the chronological nature of the forecasting problem.

### Best Parameters

```text
subsample = 1.0
n_estimators = 700
min_child_weight = 5
max_depth = 8
learning_rate = 0.1
colsample_bytree = 0.8
```

---

## Final Model Performance

### Training Performance

| Metric | Score |
|---|---:|
| MAE | 475.50 |
| RMSE | 682.02 |
| RMSPE | 18.28% |
| R² | 0.9517 |

### Validation Performance

| Metric | Score |
|---|---:|
| MAE | 789.94 |
| RMSE | 1071.64 |
| RMSPE | 18.27% |
| R² | 0.8814 |

The model performs better on the training data than on the validation period, resulting in a moderate train-validation gap.

However, the tuned XGBoost model maintains strong performance on unseen future-period observations and achieved the best validation performance among the evaluated models.

---

## Feature Importance

Feature importance analysis was performed on the final XGBoost model.

Some of the most influential features included:

- Store Type
- Promo
- Promo2
- Competition Distance
- Store
- Assortment
- Day of Week
- Competition-related features

These importance values represent the features' **predictive usefulness to the model** and should not be interpreted as causal relationships.

---

## Error Analysis

Prediction errors were analyzed using:

- Mean Error
- Median Error
- Mean Absolute Error
- Largest Absolute Errors
- Actual vs Predicted Sales

The analysis showed that some unusually high-sales observations generated significantly larger prediction errors than typical observations.

This helps identify situations where the forecasting model may have greater difficulty.

---

## Technologies Used

- Python
- Pandas
- NumPy
- Matplotlib
- Seaborn
- Scikit-learn
- XGBoost
- Joblib
- Jupyter Notebook / Google Colab

---

## Repository Structure

```text
rossmann-retail-sales-forecasting/
│
├── README.md
├── Rossmann_Retail_Sales_Forecasting.ipynb
├── store.csv
├── rossmann_xgboost_pipeline.pkl
├── requirements.txt
└── .gitignore
```

`train.csv` is intentionally excluded because of its file size.

---

## Installation

Clone the repository:

```bash
git clone <your-repository-url>
```

Navigate to the project directory:

```bash
cd rossmann-retail-sales-forecasting
```

Install the required libraries:

```bash
pip install -r requirements.txt
```

Download `train.csv` and place it in the location expected by the notebook.

Then open:

```text
Rossmann_Retail_Sales_Forecasting.ipynb
```

and run the notebook from top to bottom.

---

## Saved Model

The final trained model is saved as:

```text
rossmann_xgboost_pipeline.pkl
```

The saved pipeline contains:

**Categorical Preprocessing → XGBoost Regressor**

### Important

Feature engineering such as:

- Date features
- Competition duration
- Promo2 duration
- Promo2 activity

is performed separately in the notebook before the data is passed to the saved pipeline.

Therefore, the saved model expects **feature-engineered input data rather than completely raw Rossmann records**.

---

## Limitations

- The model was evaluated using a chronological historical validation period rather than future ground-truth sales outside the provided historical dataset.
- Customer count was excluded because it would not normally be available when forecasting future sales.
- Extreme sales observations can produce substantially larger prediction errors.
- Feature importance represents predictive usefulness rather than causality.
- Feature engineering is currently performed outside the saved model pipeline.

---

## Future Improvements

Potential improvements include:

- Multiple-window or rolling backtesting
- Automated feature engineering within the prediction pipeline
- Lag and rolling sales features with strict leakage prevention
- Additional model experimentation
- Model monitoring and retraining
- Deployment as a retail sales forecasting application

---

## Conclusion

This project demonstrates an end-to-end machine learning workflow for retail sales forecasting using the Rossmann Store Sales dataset.

A chronological validation strategy was used to simulate forecasting future sales. Linear Regression, Random Forest, and XGBoost were compared against a baseline model.

The **Tuned XGBoost Regressor** achieved the best validation performance:

- **MAE:** 789.94
- **RMSE:** 1071.64
- **RMSPE:** 18.27%
- **R²:** 0.8814

The project demonstrates practical skills in **data cleaning, exploratory data analysis, feature engineering, regression modeling, time-aware validation, hyperparameter tuning, model evaluation, error analysis, feature interpretation, and model persistence**.
