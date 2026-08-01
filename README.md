Rossmann Retail Sales Forecasting

Project Overview

This project builds a machine learning solution to forecast daily salesfor Rossmann retail stores using historical sales, storecharacteristics, promotions, competition information, holidays, andcalendar-based features.

The project focuses on a realistic forecasting workflow: exploratorydata analysis, feature engineering, chronological validation, modelcomparison, hyperparameter tuning, error analysis, feature importance,and model persistence.

The final model is a tuned XGBoost Regressor, which achieved an R²score of 0.8814 and RMSPE of 18.27% on the chronologicalvalidation period.

Business Problem

Retail stores need reliable demand forecasts to support decisionsrelated to inventory, staffing, promotions, and store operations.

The objective of this project is to use historical Rossmann store datato predict daily store sales while accounting for factors such as:

Store characteristics

Promotions

State and school holidays

Competition

Promo2 participation

Calendar and seasonal information

The target variable is Sales.

Dataset

The project uses the Rossmann Store Sales data, primarily:

train.csv --- historical daily store observations including thetarget Sales

store.csv --- store-level information such as store type,assortment, competition, and Promo2 details

train.csv is not included in this repository because of its file size.Place the dataset in the working directory before running the notebook.

The modeling notebook merges the historical sales data with thestore-level information before analysis and feature engineering.

Project Workflow

Data loading and inspection

Data cleaning and missing-value treatment

Merge sales and store datasets

Exploratory data analysis

Feature engineering

Chronological train-validation split

Removal of closed-store observations from model training

Categorical preprocessing using ColumnTransformer andOneHotEncoder

Baseline model evaluation

Linear Regression

Random Forest Regressor

XGBoost Regressor

XGBoost hyperparameter tuning using RandomizedSearchCV andTimeSeriesSplit

Final model evaluation

Error analysis

Feature importance analysis

Train-vs-validation generalization check

Save the final preprocessing + XGBoost pipeline

Exploratory Data Analysis

The EDA investigates relationships between sales and important retailfactors such as:

Customer footfall

Promotions

Day of week

Store type

Assortment

State holidays

School holidays

Competition distance

Monthly sales and customer trends

Customer footfall shows a strong relationship with sales, but theCustomers feature is excluded from the forecasting model becausefuture customer counts would not normally be known at prediction time.

Feature Engineering

Several features are created from the raw date, competition, andpromotional information, including:

Year

Month

Day

WeekOfYear

Quarter

IsWeekend

CompetitionInfoMissing

CompetitionMonths

Promo2Months

Promo2ThisMonth

The raw Date field and selected source columns used to construct theseengineered features are removed before modeling.

Validation Strategy

A chronological validation split is used instead of a randomtrain-test split.

Historical observations are used for training, while the later period isheld out for validation. This better represents the real forecastingscenario in which a model is trained on past information and evaluatedon future observations.

Closed-store rows are excluded from model training because their salesare structurally zero and do not represent normal open-store demand.

Models Evaluated

The following approaches were compared:

Mean Sales Baseline

Linear Regression

Random Forest Regressor

XGBoost Regressor

Tuned XGBoost Regressor

Validation Performance

Model                   MAE           RMSE          RMSPE             R²

Mean                2278.55        3118.90         55.66%        -0.0050Baseline

Linear              1974.47        2677.64         48.50%         0.2593Regression

Random               954.25        1404.00         20.37%         0.7963Forest

XGBoost              868.52        1180.36         20.45%         0.8561

The tuned XGBoost model produced the strongest overall validationperformance and was selected as the final model.

Final XGBoost Performance

Training

Metric      Score

MAE        475.50RMSE       682.02RMSPE      18.28%R²         0.9517

Validation

Metric       Score

MAE         789.94RMSE       1071.64RMSPE       18.27%R²          0.8814

The model fits the training data more strongly than the validation data,producing a moderate train-validation gap in R². However, it retainsstrong performance on the later chronological validation period.

Hyperparameter Tuning

XGBoost was tuned using RandomizedSearchCV with TimeSeriesSplit topreserve the temporal nature of the forecasting problem.

Best parameters obtained in the notebook:

subsample = 1.0
n_estimators = 700
min_child_weight = 5
max_depth = 8
learning_rate = 0.1
colsample_bytree = 0.8

Feature Importance

Feature-importance analysis indicates that store characteristics,promotional variables, competition information, store identity, andassortment contribute strongly to the model's predictions.

Important features include:

Store type

Promo

Promo2

Competition distance

Store

Assortment

Day of week

Competition-related features

Feature importance represents predictive usefulness, not causalimpact.

Error Analysis

Prediction errors were analyzed using:

Mean error

Median error

Mean absolute error

Largest absolute prediction errors

Actual vs. predicted sales comparisons

The analysis showed that some unusually high-sales observations producesubstantially larger absolute errors than typical observations.

Technologies Used

Python

Pandas

NumPy

Matplotlib

Seaborn

Scikit-learn

XGBoost

Joblib

Jupyter / Google Colab

Repository Structure

rossmann-retail-sales-forecasting/
│
├── README.md
├── Rossmann_Retail_Sales_Forecasting.ipynb
├── store.csv
├── rossmann_xgboost_pipeline.pkl
├── requirements.txt
└── .gitignore

train.csv is intentionally excluded because of its size.

Installation

Clone the repository and install the required Python packages:

pip install -r requirements.txt

Place train.csv in the same location expected by the notebook, thenopen:

Rossmann_Retail_Sales_Forecasting.ipynb

Run the notebook from top to bottom.

Saved Model

The final trained model is saved as:

rossmann_xgboost_pipeline.pkl

The saved object contains the categorical preprocessing stage and thetrained XGBoost model.

Note: Feature engineering such as date, competition-duration, andPromo2-duration feature creation is performed separately in the notebookbefore data is passed to the saved pipeline.

Limitations

The final model is evaluated using a chronological holdout periodrather than future ground-truth sales outside the historicaltraining dataset.

Customer count is excluded because it would not normally beavailable when forecasting future sales.

Extreme sales observations can produce substantially larger forecasterrors.

Feature importance should not be interpreted as evidence ofcausality.

The saved model pipeline expects feature-engineered inputs ratherthan completely raw Rossmann records.

Future Improvements

Potential extensions include:

Rolling or multiple-window backtesting

Automated raw-data feature engineering inside the productionpipeline

Additional lag and rolling sales features with strict leakagecontrols

Model monitoring and retraining workflows

A lightweight forecasting application for business users

Conclusion

The project demonstrates an end-to-end retail sales forecasting workflowusing machine learning and time-aware validation.

Tree-based models substantially outperformed the linear baseline, andhyperparameter tuning further improved XGBoost. The final tuned XGBoostmodel achieved MAE = 789.94, RMSE = 1071.64, RMSPE = 18.27%,and R² = 0.8814 on the chronological validation period.

The project highlights practical skills in data cleaning, exploratoryanalysis, feature engineering, regression modeling, model evaluation,hyperparameter tuning, interpretation, and reproducible model saving.
