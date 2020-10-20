library(dplyr)

# Read test data
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
subj_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

# Read train data
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
subj_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

# Merge train and test data sets
x <- rbind(x_train, x_test)
y <- rbind(y_train, y_test)
subject <- rbind(subj_train, subj_test)
rm(x_test, x_train, y_test, y_train, subj_test, subj_train)

# Read feature names
features <- read.table("UCI HAR Dataset/features.txt")
# Select features of means and standard deviations
mean_std_index <- grep("mean\\(|std\\(", features$V2)
# Extract only the measurements on the mean and standard deviation for each measurement
x <- select(x, mean_std_index)
# Extract feature names
mean_std_name <- grep("mean\\(|std\\(", features$V2, value = TRUE)
# Assign feature names to columns
names(x) <- mean_std_name
rm(features, mean_std_index, mean_std_name)

# Add activities and subjects
x <- cbind(x, y=y$V1, subject=subject$V1)
# Read activity labels
labels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("y", "activity"))
# Assign activity labels to data
x <- select(merge(x, labels), -y)
rm(y, subject, labels)
# Convert activity labels to lower case
x$activity <- tolower(x$activity)

# Change variable names to more appropriate
names(x) <- sub("^f", "frequency", names(x))
names(x) <- sub("^t", "time", names(x))
names(x) <- sub("Acc", "Accelerometer", names(x))
names(x) <- sub("Gyro", "Gyroscope", names(x))
names(x) <- sub("Mag", "Magnitude", names(x))
names(x) <- sub("mean\\(\\)", "MEAN", names(x))
names(x) <- sub("std\\(\\)", "STD", names(x))

# Reorder fields so they start from subject and activity
x <- select(x, c(subject, activity, `timeBodyAccelerometer-MEAN-X`:`frequencyBodyBodyGyroscopeJerkMagnitude-STD`))

# Average of each variable for each activity and each subject
averages <- x %>% group_by(subject, activity) %>% summarize_all(mean)
# Save as txt file
write.table(averages, row.name = FALSE, file = "averages.txt", sep=",")