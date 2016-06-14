library(reshape2)

#Select activity lables, select mean and standard deviation variables
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

meanSD <- grep(".*mean.*|.*std.*", features[,2])
meanSD.names <- features[meanSD,2]
meanSD.names = gsub('-mean', 'Mean', meanSD.names)
meanSD.names = gsub('-std', 'Std', meanSD.names)
meanSD.names <- gsub('[-()]', '', meanSD.names)

# Load training data
train <- read.table("UCI HAR Dataset/train/X_train.txt")[meanSD]
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)

#Load testing data
test <- read.table("UCI HAR Dataset/test/X_test.txt")[meanSD]
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)


allData <- rbind(train, test)
colnames(allData) <- c("subject", "activity", meanSD.names)
allData$activity <- factor(allData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
allData$subject <- as.factor(allData$subject)

allData.melted <- melt(allData, id = c("subject", "activity"))
allData.mean <- dcast(allData.melted, subject + activity ~ variable, mean)

write.table(allData.mean, "tidy data.txt", row.names = FALSE, quote = FALSE)
