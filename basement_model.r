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

