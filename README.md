
## Predicting whether a house has a basement.

### Background

Our client wants to build a model that predicts whether a home has a basement. Would you please provide a short report documenting your model and its effectiveness? 

Your final report should be submitted as a `.html` or `.pdf` file with the pertinent scripts that were used to build your report.

__Here are a few essential requirements.__

1. We want a train-test-split of `80/20` and a random seed using `2021`.
2. Filter our data down to the observations that satisfy - `TOTUNITS <= 2`, `YRBUILT != 0`, `CONDITION != "None"`, and `LIVEAREA < 5500`.
3. Convert `BASEMENT` to a `0/1` target variable.
4. Your final model should only use six features.
5. Make sure you don't have any features that are proxies for the target variable.
6. Note that available variables in the `predict.csv` file are all that can be used in your model.

### Results

#### Data exploration

- Provide 3-4 visuals that show the relationship betwee some of the features and your target variable.

#### Model selection

- Use two different machine learning models.
- Compare your two models and justify which one is a better fit.
- Display your ROC curve.
- Display your confusion matrix.

#### Model results

On your final model;

- Display your feature importance chart and explain why you picked your six features.
- Report your accuracy, balanced accuracy, F1, and recall.

#### Model explanation

- Use two different model explanation methods to help us understand how your variables affect the prediction.
- Provide an explanation of the home using the values provided with the `predict.csv` file.
- Provide the homes probability and classification.

#### Reflection

Summarize your model and if you think it would be helpful for the intended purpose.