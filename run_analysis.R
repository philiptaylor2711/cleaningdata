### First step unzips the data to your workspace
### If the data is already unzipped, then skip this step
## The title is that of the zipped folder so edit if it is not correct

unzip("getdata-projectfiles-UCI HAR Dataset (1).zip")

### Read all of the training data sets into R data sets
### Do the same for the test data sets
### Also look at the dimensions for all raw data sets

# Have to read in the feature names file to get the variable names for X.

features <- read.table("./UCI HAR Dataset/features.txt")
head(features)


trainingX <- read.table("./UCI HAR Dataset/train/X_train.txt",col.names=features[,2])
  dim(trainingX)
trainingY <- read.table("./UCI HAR Dataset/train/Y_train.txt")
  dim(trainingY)
trainingSubject <- read.table("./UCI HAR Dataset/train/subject_train.txt")
  dim(trainingSubject)
testX <- read.table("./UCI HAR Dataset/test/X_test.txt",col.names=features[,2])
  dim(testX)
testY <- read.table("./UCI HAR Dataset/test/Y_test.txt")
  dim(testY)
testSubject <- read.table("./UCI HAR Dataset/test/subject_test.txt")
  dim(testSubject)

### From the readME files the following is clear:
### The test data and training data are different subsets.
### However the same variables are observed for both test and training sets
### The tidy data set does not require us to tell which observations are
### test and which are training so these can be appended using rbind()
## so we append using test first then training (ordering is important!)

Subject <- rbind(testSubject,trainingSubject)
X <- rbind(testX,trainingX)
Y <- rbind(testY,trainingY)

## Before the data is binded by columns, the variable names need to be changed.


head(Subject,n=5)

# There is 1 variable which is the subject ID in the Subject data.
# load the dplyr library of functions
library(dplyr)
# Then rename the variable as subject_ID
Subject <- rename(Subject,subject_ID=V1)
# run the head function to check
head(Subject,n=5)

head(Y,n=5)

# Y also has one variable (the activity name), so rename as activity
Y <- rename(Y,activity=V1)
head(Y,n=5)
# The six activity codes also require re-coding.
# For this we could read in the activity labels text file.
# This will be easier after the column bind as merging re-sorts the data.

head(X,n=1)


# those variables containing mean() or std() need to be extracted.
# the grep function finds a string (mean or std) in the list of features.
# bind these two together to get the list of columns required.
a <- grep("mean()",features[,2], fixed=TRUE)
b <- grep("std()",features[,2], fixed=TRUE)
columnsneeded <- c(a,b)

# Create dataset Z, which is X but only with the columns required.
Z <- X[,columnsneeded]

# now bind the columns together.

tidyData1 <- cbind(Y,Subject,Z)

# read in the activity labels

activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
head(activity_labels)
tidyData <- merge(tidyData1,activity_labels,by.x="activity",by.y="V1",all=TRUE)
tidyData <- rename(tidyData,activity=V2)
tidyData <- tidyData[,c(2:69)]

# Creating the smaller dataset with the average of each variable
# by subject and activity, use groupby syntax.
# apply the mean function to each group using summarize_each.

tidyData2 <- group_by(tidyData,subject_ID,activity)
 tidyData3 <- summarize_each(tidyData2,funs(mean))
head(tidyData3)

# write the dataset to a txt file for upload to Coursera.

write.table(tidyData3,"./tidyData.txt",row.name=FALSE)
