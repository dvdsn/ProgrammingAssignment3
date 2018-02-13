## 0. Set up
library(dplyr)

# Download data and decompress
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
datafile <- "Dataset.zip"
download.file(url, datafile)
unzip(datafile)


## 1. Merge the training and the test sets to create one data set.

# Two subdirectories for the data
data_directory <- c("UCI HAR Dataset/test/", 
                    "UCI HAR Dataset/train/")

# Subject identifiers
sfile <-c("subject_test.txt",
          "subject_train.txt")

# Activity labels
yfile <- c("y_test.txt", 
           "y_train.txt")

# Feature vectors
xfile <- c("X_test.txt",
           "X_train.txt")

# Number of rows in each feature vector X_* file
nrows_vec <- c(2947, 7352)

# Initialize a data table with var. names that read.table uses
tmp <- data.frame(s = NA, 
		  y = NA, 
		  matrix(NA,1,561))
d <- tbl_df(tmp)
rm(tmp)
names(d) <- c("s", "y", paste("V", 1:561, sep=""))

# Read in data for test and train, and combine
for(i in 1:2){

   s <- read.table(paste(data_directory[i], sfile[i], sep=""))
   y <- read.table(paste(data_directory[i], yfile[i], sep=""))
   x <- read.table(paste(data_directory[i], xfile[i], sep=""), 
                comment.char="", 
		nrows=nrows_vec[i],
		colClasses = numeric())

   tmp <- data.frame(s = s[,1], y = y[,1], x)

   d <- rbind(d, tmp)
   rm(tmp, s, y, x)

}
d <- filter(d, !is.na(V1))


## 2. Extract measurements with the mean and standard deviation for each measurement.
f <- read.table(paste("UCI HAR Dataset", "features.txt", sep="/"), header=F)
names(f) <- c("index","feature")

idx_mean <- grep("-mean()", f$feature, fixed=TRUE)
idx_std <- grep("-std()", f$feature, fixed=TRUE)

d <- d %>% 
select(s, y, idx_mean + 2, idx_std + 2)


## 3. Use descriptive activity names to name the activities in the data set.
d$y <- recode(d$y, 
              `1`="walking",
              `2`="walking_upstairs",
              `3`="walking_downstairs",
              `4`="sitting",
              `5`="standing",
              `6`="laying")

# Recode activity and subject id as factors
d$y <- as.factor(d$y)
relevel(d$y, ref="laying")

d$s <- paste("s",d$s, sep="")
d$s <- as.factor(d$s)


## 4. Appropriately label the data set with descriptive variable names.
names_vec <- c("subject", 
               "activity", 
               as.character(f$feature[idx_mean]), 
               as.character(f$feature[idx_std]))

names_vec <- sub("mean\\(\\)", "mn", names_vec)
names_vec <- sub("std\\(\\)", "sd", names_vec)
names_vec <- gsub("-", "_", names_vec)

names(d) <- names_vec

write.table(d, "d.txt")


## 5. From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.
m <- d %>% 
group_by(subject, activity) %>%
summarise_each(funs(mean), names_vec[3:68])

write.table(m, "m.txt")


