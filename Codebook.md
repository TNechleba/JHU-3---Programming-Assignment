# Codebook for Programming Assignment 3: Getting and Cleaning Data Course Project

The script follows the following steps:

1. Retrieve activity definitions from activity_labels.txt and name the columns as follows:
    - ActivityNumber
    - ActivityName
    
2. Retrieve feature definitions from features.txt:
    - FeatureNumber (the row number)
    - FeatureName (the string following the feature number)
    
3. Read in .txt files: 
    - subject_test, y_test, subject_train, and y_train \n deliminated text files, no column names, as subject and y, respectively
    - x_test and x_train, apply list of FeatureNames from features.txt as column names, as x

4. Combine data sets
    - row_bind test and train pairs
    - rename first column in subject to SubjectNumber and add row number as Index, as subject_mod
    - join activity labels to y as y_mod
    - cbind subject_mod (SubjectNumber),  y_mod (ActivityNumber and ActivityName), and x to obtain combined data set x_mod
    
5. Discard metrics other than mean and standard deviation

6. Pivot in feature names (columns of x_mod other than Index, SubjectNumber and ActivityName) to FeatureName and their values to Value

7. Extract information about each variable from the FeatureName string:
    - Feature is the initial string of letters describing the measurement type
    - MetricType is mean or standard deviation
    - Axis is X, Y, or Z for those measurement that specify this or NULL for those that do not.
    
8. Pivot out the mean and standard deviation to Mean and StandardDeviation with the relevant values from Value 
   to arrive at the final data set

9. Produce second data set, averages, by grouping first data set by SubjectNumber, ActivityName, Feature, and Axis, and calculating the average of the Mean for each group, producing the required second data set of average measurements per subject, activity and feature

Data set 1 (x_mod):
Index, the experiment index (one instance of Subject, Activity and group of Features)
SubjectNumber
ActivityName
Feature
Axis
Mean
StandardDeviation

Data set2 (averages):
SubjectNumber
ActivityName
Feature
Axis
Average
