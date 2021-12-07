# Import libraries
library(tidyverse)
library(tidymodels)
library(visdat)
library(skimr)

# Import Data w/ only desired columns + flip all to lowercase to conserve typing

dat <- read.csv('C:/code/coding_challenges/data/SalesBook_2013.csv') %>%
    select(BASEMENT, PARCEL, LIVEAREA, YRBUILT, CONDITION, QUALITY, TOTUNITS, STORIES, GARTYPE, NOCARS, NUMBDRM, NUMBATHS, ARCSTYLE, SPRICE, DEDUCT, NETPRICE, TASP, SMONTH, SYEAR, QUALIFIED, STATUS) %>%
    rename_all(str_to_lower) %>%
    filter(
        totunits <= 2,
        yrbuilt != 0,
        condition != "None",
        livearea < 5500) %>%
    # Change str -> int/float, fill in nulls    
    mutate(
        basement = ifelse(is.na(basement), 0, basement),
        has_basement = ifelse(basement > 0, "has_basement", "no_basement")  %>% factor(levels = c("has_basement","no_basement")),
        # quality case_when (keeping same as class)
    quality = case_when(
        quality == "E-" ~ -0.3, quality == "E" ~ 0,
        quality == "E+" ~ 0.3, quality == "D-" ~ 0.7, 
        quality == "D" ~ 1, quality == "D+" ~ 1.3,
        quality == "C-" ~ 1.7, quality == "C" ~ 2,
        quality == "C+" ~ 2.3, quality == "B-" ~ 2.7,
        quality == "B" ~ 3, quality == "B+" ~ 3.3,
        quality == "A-" ~ 3.7, quality == "A" ~ 4,
        quality == "A+" ~ 4.3, quality == "X-" ~ 4.7,
        quality == "X" ~ 5, quality == "X+" ~ 5.3),

# condition case_when (keeping same as class)
    condition = case_when(
        condition == "Excel" ~ 3,
        condition == "VGood" ~ 2,
        condition == "Good" ~ 1,
        condition == "AVG" ~ 0,
        condition == "Avg" ~ 0,
        condition == "Fair" ~ -1,
        condition == "Poor" ~ -2),
    
    # qualified q to 1 u to 0
    qualified = case_when(
        qualified == "Q" ~ 1,
        qualified == "U" ~ 0),
    # status v to 1 i to 0
    status = case_when(
        status == "V" ~ 1,
        status == "I" ~ 0),

    arcstyle = ifelse(is.na(arcstyle), "missing", arcstyle),
    gartype = ifelse(is.na(gartype), "missing", gartype),
    attachedGarage = gartype %>% str_to_lower() %>% str_detect("att") %>% as.numeric(),
    attachedGarage = gartype %>% str_to_lower() %>% str_detect("det") %>% as.numeric(),
    attachedGarage = gartype %>% str_to_lower() %>% str_detect("cp") %>% as.numeric(),
    attachedGarage = gartype %>% str_to_lower() %>% str_detect("none") %>% as.numeric()
    ) %>%
    # Get first one in group when multiple sales
    arrange(parcel,smonth) %>%
    group_by(parcel) %>%
    slice(1) %>%
    ungroup() %>%
    # Remove undesired/unneeded fields
    select(-basement, -parcel, -gartype)  %>%
    replace_na(
        c(list(
            basement = 0),
        colMeans(select(., nocars, numbdrm, numbaths), na.rm = TRUE)
        )
    )

# Set dummy variables for the arcstyle
dat_ml <- dat %>%
    recipe(has_basement ~ ., data = dat) %>% 
    step_dummy(arcstyle) %>% #different steps other than dummy
    prep() %>%
    juice()

# Views of dataframe for ML model
unique(dat_ml[c("has_basement")])
glimpse(dat_ml)
skim(dat_ml)
vis_dat(dat_ml)

#Save graph
ggsave("C:/code/coding_challenges/documents/vis_dat_graph_no_na.png")

# write file
write_rds(dat_ml, "C:/code/coding_challenges/data/dat_ml.rds")
