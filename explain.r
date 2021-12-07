# Import libraries
library(tidyverse)
library(tidymodels)
library(DALEX)
library(vip)
library(patchwork)

# Read in the file if stopped
dat_ml <- read_rds("C:/code/coding_challenges/data/dat_ml.rds")

# Before now 0 and 1 is after
dat_exp <- mutate(dat_train, has_basement = as.integer(dat_train$has_basement) - 1)

# Explainer codes saved into variables
explainer_bt <- DALEX::explain(
    bt_model,
    select(dat_exp, -has_basement), dat_exp$has_basement, label = "Boosted Trees")

explainer_logistic <- DALEX::explain(
    logistic_model,
    select(dat_exp, -has_basement), dat_exp$has_basement, label = "Logistic Regression")

performance_bt <- model_performance(explainer_bt)
performance_logistic <- model_performance(explainer_logistic)

# predicting 0's on left and 1  (% of residuals with the given value)
plot(performance_bt, performance_logistic)

#Save graph
ggsave("C:/code/coding_challenges/documents/residual_rev_cumulative.png")

plot(performance_bt, performance_logistic, geom = "boxplot")

#Save graph
ggsave("C:/code/coding_challenges/documents/residual_boxplot.png")

# Use loss root mean square by our designation
# Dash line is rms error.  left/lower means fitting better
# Variable importance bar like last class

bt_parts <- model_parts(explainer_bt,
    loss_function = loss_root_mean_square)

logistic_parts <- model_parts(explainer_logistic, 
    loss_function = loss_root_mean_square)

# Plot RMS Errors

plot(bt_parts, logistic_parts, max_vars = 6)

#Save graph
ggsave("C:/code/coding_challenges/documents/eval_feat_importance.png")

#looking at difference instead
bt_parts <- model_parts(explainer_bt,
    loss_function = loss_root_mean_square, type = "difference")
logistic_parts <- model_parts(explainer_logistic, 
    loss_function = loss_root_mean_square, type = "difference")

# Plot rms error diff

plot(bt_parts, logistic_parts,  max_vars = 6)

#Save graph
ggsave("C:/code/coding_challenges/documents/eval_feat_importance_diff.png")

