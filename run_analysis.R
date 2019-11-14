setwd("C:/Users/TNechleba/JHU/3 - clean and get/assignment")

library(tidyverse)

# Get activity labels and feature labels

setwd("./UCI HAR Dataset")

activities <- read_table(
    "activity_labels.txt", 
    col_names = c("ActivityNumber", "ActivityName"))

features <- read_table("features.txt", col_names = FALSE) %>%
    mutate(FeatureNumber = row_number(),
        FeatureName = str_extract(X1, "(?<= ).*")) %>%
    select(-c(X1))

# Read in test data

setwd("./test")

subject_test <- read_delim("subject_test.txt", "\n", col_names = FALSE)
x_test <- read_table("X_test.txt", col_names = features$FeatureName)
y_test <- read_delim("y_test.txt", "\n", col_names = FALSE)

# Read in train data

setwd('..')
setwd("./train")

subject_train <- read_delim("subject_train.txt", "\n", col_names = FALSE)
x_train <- read_table("X_train.txt", col_names = features$FeatureName)
y_train <- read_delim("y_train.txt", "\n", col_names = FALSE)

setwd('..')

# Combine data sets

subject <- rbind(subject_test, subject_train)
x <- rbind(x_test, x_train)
y <- rbind(y_test, y_train)

# rm(list = c("subject_test", "subject_train", "x_test", "x_train", "y_test", "y_train"))

subject_mod <- subject %>%
    rename(SubjectNumber = X1) %>%
    mutate(Index = row_number()) %>%
    select(Index, SubjectNumber)

# Apply correct activity labels

y_mod <- y %>%
    left_join(activities, by = c("X1" = "ActivityNumber")) %>%
    select(-X1)

# Combine data with subject numbers and activity labels

x_mod <- subject_mod %>%
    cbind(y_mod) %>%
    cbind(x) %>%
    #  Keep only identifiers and mean and std values
    select(
        Index, 
        SubjectNumber, 
        ActivityName, 
        contains("mean()"), 
        contains("std()")) %>% 
    # Pivot in feature names 
    pivot_longer(
        cols = -c(Index, SubjectNumber, ActivityName), 
        names_to = "FeatureName", 
        values_to = "Value") %>%
    # Extract discrete information about values from FeatureName string
    mutate(
        Feature = str_extract(FeatureName, "^[:alpha:]+"),
        MetricType = str_extract(FeatureName, "(?<=-)[:alpha:]+"),
        Axis = str_extract(FeatureName, "[:alpha:]$")) %>%
    select(-c(FeatureName)) %>%
    # Pivot mean and std out
    pivot_wider(
        names_from = MetricType, 
        values_from = Value) %>%
    rename(Mean = mean, StandardDeviation = std)

# Compute second data set of averages by subject, activity and feature

averages <- x_mod %>%
    group_by(SubjectNumber, ActivityName, Feature, Axis) %>%
    summarise(Average = mean(Mean))

        