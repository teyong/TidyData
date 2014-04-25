library(reshape)
library(plyr)

setwd("./github/TidyData")
if(!file.exists("./data")) {
  dir.create("./data")
}

fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, destfile="./data/projectFile.zip", method="curl")
unzip("./data/projectFile.zip", exdir="./data")

features <- read.table("./data/UCI HAR Dataset/features.txt")
activity <- read.table("./data/UCI HAR Dataset/activity_labels.txt")

subjects_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/Y_train.txt")
y_train <- join(y_train, activity, by="V1", type="left")
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
train_data_frame <- cbind(subjects_train, y_train, x_train)[,-2]

subjects_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/Y_test.txt")
y_test <- join(y_test, activity, by="V1", type="left")
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
test_data_frame <- cbind(subjects_test, y_test, x_test)[,-2]

data <- rbind(train_data_frame, test_data_frame)
colnames(data) <- c("subject", "activity", as.character(features[,2]))

data$subject <- as.factor(data$subject)

data1 <- data[, c(TRUE, TRUE, (grepl("\\<mean\\>", features[,2]) | grepl("\\<std\\>", features[,2])))]
tidy_data <- melt(data1, id.vars=c("subject", "activity"), measure.vars=colnames(data1)[-(1:2)])


tidy_data2 <- sapply(split(data[,-(1:2)], list(data$subject, data$activity)), FUN=colMeans)
tidy_data2 <- melt(tidy_data2, id.var=c(colnames(tidy_data2), rownames(tidy_data2)))