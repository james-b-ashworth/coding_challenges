# Import needed libraries
library(tidyverse)
library(tidymodels)
library(DALEX)
library(skimr)
library(GGally)
library(xgboost)
library(vip)
library(patchwork)

# Read in the file if stopped
dat_ml <- read_rds("C:/code/coding_challenges/data/dat_ml.rds")

# create training & test dataframes
set.seed(2021)
dat_split <- initial_split(dat_ml, prop = .8, strata = has_basement)

dat_train <- training(dat_split)
dat_test <- testing(dat_split)

## Fit the models

bt_model <- boost_tree() %>%
    set_engine(engine = "xgboost") %>%
    set_mode("classification") %>%
    fit(has_basement ~ ., data = dat_train)

logistic_model <- logistic_reg() %>%
    set_engine(engine = "glm") %>%
    set_mode("classification") %>%
    fit(has_basement ~ ., data = dat_train)

nb_model <- discrim::naive_Bayes() %>%
    set_engine(engine = "naivebayes") %>%
    set_mode("classification") %>%
    fit(has_basement ~ ., data = dat_train)

(vip(bt_model, num_features = 20) + labs(title = "boosted")) + 
(vip(logistic_model, num_features = 20) + labs(title = "logistic"))

#Save graph
ggsave("C:/code/coding_challenges/documents/variable_importance_scores.png")

# evaluate performance of all three models

preds_bt <- bind_cols(
    predict(bt_model, new_data = dat_test),
    predict(bt_model, dat_test, type = "prob"),
    truth = pull(dat_test, has_basement)
  )

preds_logistic <- bind_cols(
    predict(logistic_model, new_data = dat_test),
    predict(logistic_model, dat_test, type = "prob"),
    truth = pull(dat_test, has_basement)
  )

preds_nb <- bind_cols(
    predict(nb_model, new_data = dat_test),
    predict(nb_model, dat_test, type = "prob"),
    truth = pull(dat_test, has_basement)
  )

# Confusion Matrixes
preds_bt %>% conf_mat(truth, .pred_class)
preds_logistic %>% conf_mat(truth, .pred_class)
preds_nb %>% conf_mat(truth, .pred_class)

# Accuracy rates
preds_bt %>% metrics(truth, .pred_class)
preds_logistic %>% metrics(truth, .pred_class)
preds_nb %>% metrics(truth, .pred_class)

# Other requested metrics setting up what want to recall below
metrics_calc <- metric_set(accuracy, bal_accuracy, precision, f_meas, recall)

# Look at metrics
preds_bt %>%
    metrics_calc(truth, estimate = .pred_class)

preds_logistic %>%
    metrics_calc(truth, estimate = .pred_class)

preds_nb %>%
    metrics_calc(truth, estimate = .pred_class)

#  & roc curves of three models

preds_bt %>%
    roc_curve(truth, estimate = .pred_has_basement) %>%
    autoplot()

#Save graph
ggsave("C:/code/coding_challenges/documents/auc_bt.png")

preds_logistic %>%
    roc_curve(truth, estimate = .pred_has_basement) %>%
    autoplot()

#Save graph
ggsave("C:/code/coding_challenges/documents/auc_logistic.png")

preds_nb %>%
    roc_curve(truth, estimate = .pred_has_basement) %>%
    autoplot()

#Save graph
ggsave("C:/code/coding_challenges/documents/auc_bayes.png")

# Combine all rows to combine in a single graph
preds_all <- bind_rows(
    mutate(preds_bt, model = "Boosted Tree"),
    mutate(preds_logistic, model = "Logistic Regression"),
    mutate(preds_nb, model = "Naive Bayes")
)

# Plot & table of all three models
preds_all %>%
    group_by(model) %>%
    roc_curve(truth, estimate = .pred_has_basement) %>%
    autoplot()

#Save graph
ggsave("C:/code/coding_challenges/documents/auc_all_models.png")

preds_all %>%
    group_by(model) %>%
    metrics_calc(truth, estimate = .pred_class) %>%
    pivot_wider(names_from = .metric, values_from = .estimate)