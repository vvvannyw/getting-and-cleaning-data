##1. Merges the training and the test sets to create one data set.
##download and unzip the zip file
if (!file.exists("./data"))dir.create("./data")
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl, destfile = "./data/getCleanData.zip")
listzip <- unzip("./data/getCleanData.zip")

##load the data in R
train.x <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
train.y <- read.table("./data/UCI HAR Dataset/train/Y_train.txt")
train.subject <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
text.x <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
test.y <- read.table("./data/UCI HAR Dataset/test/Y_test.txt")
test.subject <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

##merge data
traindata <- cbind(train.subject, train.y, train.x)
testdata <- cbind(test.subject, test.y, test.x)
mydata <- rbind(traindata, testdata)


##2.Extracts only the measurements on the mean and standard deviation 
##for each measurement.
##load into R
name <- read.table("./data/UCI HAR Dataset/features/txt", stringsAsFactors = FALSE)[,2]

#extract mean and sd
index <- grep(("mean\\(\\)|std\\(\\)"), name)
result <- fulldata[, c(1, 2, index+2)]
colnames(result) <- c("object", "activity", name(index))


##3.Uses descriptive activity names to name the activities in the data set
##load in the R
activityname <- read.table("./data/UCI HAR Dataset/activity_labels.txt")

##replace to their names
result$activity <- factor(result$activity, levels = activityname[,1],  labels = activityName[,2])

##4.Appropriately labels the data set with descriptive variable names.
names(result) <- gsub("\\()", "", names(result))
names(result) <- gsub("^t", "time", names(result))
names(result) <- gsub("^f", "frequence", names(result))

##5.create tidy dataset from step4
library(dplyr)
groupdata <- result %>%
      group_by(subject, activity) %>%
      summarise_each(funs(mean))

write.table(groupdata, "./Getting_and_Cleaning_data_Project/MeanData.txt", row.names = FALSE)
