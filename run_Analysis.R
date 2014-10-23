# run dataset merge and analysis for data 

##
## Read in the primary data sets
##

# Read in the test and training data, no headers
X_test <- read.table("UCI HAR Dataset/test/X_test.txt", header=FALSE)
X_train <- read.table("UCI HAR Dataset/train/X_train.txt", header=FALSE)

##
## Step 4 - Appropriately labels the data set with descriptive variable names. 
##

# Read in the names of the columns
cols <- read.table("UCI HAR Dataset/features.txt")

# manually assign the column names as read.table truncates them
colnames(X_test) <- cols$V2
colnames(X_train) <- cols$V2

## End Step 4

##
## Step 2 - Extracts only the measurements on the mean and standard deviation for each measurement. 
##

# find all columns that have 
colsToKeep <- c(grep("-mean()", colnames(X_test), fixed=TRUE), grep("-std()", colnames(X_test), fixed=TRUE))
X_test <- X_test[,colsToKeep]
X_train <- X_train[,colsToKeep]

# free up space
rm(cols)
rm(colsToKeep)

## End Step 2

##
## Add Subject and Activity IDs before any merge() operations take place since they do not guarantee order preservation
##

# Read in the test and training subject indicators
S_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
S_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

X_test$Subject.ID <- S_test$V1
X_train$Subject.ID <- S_train$V1

# free up space
rm(S_test)
rm(S_train)

# Read in the test and training activity indicators
Y_test <- read.table("UCI HAR Dataset/test/Y_test.txt", header=FALSE)
Y_train <- read.table("UCI HAR Dataset/train/Y_train.txt", header=FALSE)

# add the Activity.ID column
X_test$Activity.ID <- Y_test$V1
X_train$Activity.ID <- Y_train$V1

# free up space
rm(Y_test)
rm(Y_train)

##
# Step 3 - Uses descriptive activity names to name the activities in the data set
##
# Read in the activity names for rows
rows <- read.table("UCI HAR Dataset/activity_labels.txt")

# map Activity.ID to Activity.Name using rows data frame
colnames(rows) <- c("Activity.ID", "Activity.Name")
X_test <- merge(X_test, rows, by="Activity.ID")
X_train <- merge(X_train, rows, by="Activity.ID")

# free up space
rm(rows)
X_test$Activity.ID <- NULL
X_train$Activity.ID <- NULL

##
# Step 1 - Merges the training and the test sets to create one data set.
##

# Merge the two datasets into one combined set
X_all<-merge(X_test, X_train, all=TRUE)

# free up space
rm(X_test)
rm(X_train)

##
# Step 5 - From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
##
tidyData <- aggregate.data.frame(X_all, by=list(Subject=X_all$Subject.ID, Activity=X_all$Activity.Name), mean)

#remove unneeded columns from tidyData
tidyData$Activity.Name <- NULL
tidyData$Subject.ID <- NULL

tidyData

