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


all <- rbind(train, test)
colnames(all) <- c("subject", "activity", meanSD.names)
all$activity <- factor(all$activity, levels = activityLabels[,1], labels = activityLabels[,2])
all$subject <- as.factor(all$subject)

all.melt <- melt(all, id = c("subject", "activity"))
all.mean <- dcast(all.melted, subject + activity ~ variable, mean)

write.table(all.mean, "tidy data.txt", row.names = FALSE, quote = FALSE)
