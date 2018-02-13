
This project collects, transforms and documents some data related to wearable computing. The data were collected by researchers from accelerometers in the Samsung brand Galaxy S smartphone. A full description can be found here:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The specific data for this project can be found here:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

In this repository, there is one R script run_analysis.R that does the following. Note that the comments in run_analysis.R are numbered to correspond:

0 Downloads and decompresses the dataset directory 'UCI HAR Dataset'. 

1 Reads in and merges the training and the test sets to create one data set 'd' using dplyr.

2 Selects from the data set 'd' the measurements on the mean and standard deviation.

3 Recodes the activity names from numbers to descriptive names in the data set 'd'.

4 Labels the data set 'd' with descriptive variable names taken from features.txt.

5 Creates a second tidy data set 'm' with the average of each variable for each activity and each subject.


