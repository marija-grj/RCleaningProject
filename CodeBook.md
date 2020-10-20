# Getting and Cleaning Data Course Project

## Dataset

Source: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

**For each record it is provided:**

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

### Features

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

#### Features
- tBodyAcc-XYZ
- tGravityAcc-XYZ
- tBodyAccJerk-XYZ
- tBodyGyro-XYZ
- tBodyGyroJerk-XYZ
- tBodyAccMag
- tGravityAccMag
- tBodyAccJerkMag
- tBodyGyroMag
- tBodyGyroJerkMag
- fBodyAcc-XYZ
- fBodyAccJerk-XYZ
- fBodyGyro-XYZ
- fBodyAccMag
- fBodyAccJerkMag
- fBodyGyroMag
- fBodyGyroJerkMag

#### Aggregations
The set of variables that were estimated from these signals are: 

- **mean(): Mean value**
- **std(): Standard deviation**
- mad(): Median absolute deviation 
- max(): Largest value in array
- min(): Smallest value in array
- sma(): Signal magnitude area
- energy(): Energy measure. Sum of the squares divided by the number of values. 
- iqr(): Interquartile range 
- entropy(): Signal entropy
- arCoeff(): Autorregresion coefficients with Burg order equal to 4
- correlation(): correlation coefficient between two signals
- maxInds(): index of the frequency component with largest magnitude
- meanFreq(): Weighted average of the frequency components to obtain a mean frequency
- skewness(): skewness of the frequency domain signal 
- kurtosis(): kurtosis of the frequency domain signal 
- bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
- angle(): Angle between to vectors.

#### Naming
- t - time / f - frequency
- Acc - Accelerometer / Gyro - Gyroscope 
- Body / Gravity
- Jerk - Jerk signals
- Mag - Magnitude of signals
- X axis / Y axis / Z axis

## Transformations

Aim is to create a dataset of the mean and standard deviation for each measurement. Therefore I combine

- Data on 66 out of 561 features (mean() and std() only) from 
  - train/X_train.txt
  - test/X_test.txt
- 66 out of 561 feature names from
  - features.txt
- Activity values for each observation from
  - train/y_train.txt
  - test/y_test.txt
- Activity labels from
  - activity_labels.txt
- Identifiers of subjects who carried out the experiment for each observation from
  - train/subject_train.txt
  - test/subject_test.txt

**Used Libraries**
```R
library(dplyr)
```

### 1. Merge the training and the test sets to create one data set

Read test data
```R
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
subj_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
```
Read train data
```R
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
subj_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
```
Merge train and test data sets by binding them vertically
```R
x <- rbind(x_train, x_test)
y <- rbind(y_train, y_test)
subject <- rbind(subj_train, subj_test)
```

### 2. Extract only the measurements on the mean and standard deviation for each measurement

Read feature names
```R
features <- read.table("UCI HAR Dataset/features.txt")
```
Select features of means and standard deviations
```R
mean_std_index <- grep("mean\\(|std\\(", features$V2)
```
Extract only features of means and standard deviations
```R
x <- select(x, mean_std_index)
```

Select feature names
```R
mean_std_name <- grep("mean\\(|std\\(", features$V2, value = TRUE)
```
Assign feature names to columns
```R
names(x) <- mean_std_name
```

### 3. Use descriptive activity names to name the activities in the data set

Add activities and subjects
```R
x <- mutate(x, y=y$V1, subject=subject$V1)
```
Read activity labels
```R
labels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("y", "activity"))
```
Assign activity labels to data
```R
x <- select(merge(x, labels), -y)
```
Convert activity labels to lower case
```R
x$activity <- tolower(x$activity)
```

### 4. Appropriately label the data set with descriptive variable names

Rename variables in a more clear way:

|Initial |Modified     |
|--------|-------------|
|f       |frequency    |
|t       |time         |
|Acc     |Accelerometer|
|Gyro    |Gyroscope    |
|Mag     |Magnitude    |
|mean()  |MEAN         |
|std()   |STD          |

I keep "-" separators for better MEAN and STD recognition and
I don't split time/frequency, Accelerometer/Gyroscope, X/Y/Z etc. in separate columns because each feature is reasonable only as a whole, e.g., metric aggregation by X axis wouldn't make any sense here.

Example:

- *tGravityAcc-std()-X* becomes *timeGravityAccelerometer-STD-X*
- *fBodyAccMag-mean()* becomes *frequencyBodyAccelerometerMagnitude-MEAN*

```R
names(x) <- sub("^f", "frequency", names(x))
names(x) <- sub("^t", "time", names(x))
names(x) <- sub("Acc", "Accelerometer", names(x))
names(x) <- sub("Gyro", "Gyroscope", names(x))
names(x) <- sub("Mag", "Magnitude", names(x))
names(x) <- sub("mean\\(\\)", "MEAN", names(x))
names(x) <- sub("std\\(\\)", "STD", names(x))
```
Reorder fields so they start from subject and activity
```R
x <- select(x, c(subject, activity, `timeBodyAccelerometer-MEAN-X`:`frequencyBodyBodyGyroscopeJerkMagnitude-STD`))
```

### 5. From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject
Calculate mean of all features by subject and activity
```R
averages <- x %>% group_by(subject, activity) %>% summarize_all(mean)
```
Save as txt file
```R
write.table(averages, row.name = FALSE, file = "averages.txt", sep=",")
```

## Output

`averages.txt`

```
tibble [180 x 68] (S3: grouped_df/tbl_df/tbl/data.frame)
 $ subject                                         : int [1:180] 1 1 1 1 1 1 2 2 2 2 ...
 $ activity                                        : chr [1:180] "laying" "sitting" "standing" "walking" ...
 $ timeBodyAccelerometer-MEAN-X                    : num [1:180] 0.222 0.261 0.279 0.277 0.289 ...
 $ timeBodyAccelerometer-MEAN-Y                    : num [1:180] -0.04051 -0.00131 -0.01614 -0.01738 -0.00992 ...
 $ timeBodyAccelerometer-MEAN-Z                    : num [1:180] -0.113 -0.105 -0.111 -0.111 -0.108 ...
 $ timeBodyAccelerometer-STD-X                     : num [1:180] -0.928 -0.977 -0.996 -0.284 0.03 ...
 $ timeBodyAccelerometer-STD-Y                     : num [1:180] -0.8368 -0.9226 -0.9732 0.1145 -0.0319 ...
 $ timeBodyAccelerometer-STD-Z                     : num [1:180] -0.826 -0.94 -0.98 -0.26 -0.23 ...
 $ timeGravityAccelerometer-MEAN-X                 : num [1:180] -0.249 0.832 0.943 0.935 0.932 ...
 $ timeGravityAccelerometer-MEAN-Y                 : num [1:180] 0.706 0.204 -0.273 -0.282 -0.267 ...
 $ timeGravityAccelerometer-MEAN-Z                 : num [1:180] 0.4458 0.332 0.0135 -0.0681 -0.0621 ...
 $ timeGravityAccelerometer-STD-X                  : num [1:180] -0.897 -0.968 -0.994 -0.977 -0.951 ...
 $ timeGravityAccelerometer-STD-Y                  : num [1:180] -0.908 -0.936 -0.981 -0.971 -0.937 ...
 $ timeGravityAccelerometer-STD-Z                  : num [1:180] -0.852 -0.949 -0.976 -0.948 -0.896 ...
 $ timeBodyAccelerometerJerk-MEAN-X                : num [1:180] 0.0811 0.0775 0.0754 0.074 0.0542 ...
 $ timeBodyAccelerometerJerk-MEAN-Y                : num [1:180] 0.003838 -0.000619 0.007976 0.028272 0.02965 ...
 $ timeBodyAccelerometerJerk-MEAN-Z                : num [1:180] 0.01083 -0.00337 -0.00369 -0.00417 -0.01097 ...
 $ timeBodyAccelerometerJerk-STD-X                 : num [1:180] -0.9585 -0.9864 -0.9946 -0.1136 -0.0123 ...
 $ timeBodyAccelerometerJerk-STD-Y                 : num [1:180] -0.924 -0.981 -0.986 0.067 -0.102 ...
 $ timeBodyAccelerometerJerk-STD-Z                 : num [1:180] -0.955 -0.988 -0.992 -0.503 -0.346 ...
 $ timeBodyGyroscope-MEAN-X                        : num [1:180] -0.0166 -0.0454 -0.024 -0.0418 -0.0351 ...
 $ timeBodyGyroscope-MEAN-Y                        : num [1:180] -0.0645 -0.0919 -0.0594 -0.0695 -0.0909 ...
 $ timeBodyGyroscope-MEAN-Z                        : num [1:180] 0.1487 0.0629 0.0748 0.0849 0.0901 ...
 $ timeBodyGyroscope-STD-X                         : num [1:180] -0.874 -0.977 -0.987 -0.474 -0.458 ...
 $ timeBodyGyroscope-STD-Y                         : num [1:180] -0.9511 -0.9665 -0.9877 -0.0546 -0.1263 ...
 $ timeBodyGyroscope-STD-Z                         : num [1:180] -0.908 -0.941 -0.981 -0.344 -0.125 ...
 $ timeBodyGyroscopeJerk-MEAN-X                    : num [1:180] -0.1073 -0.0937 -0.0996 -0.09 -0.074 ...
 $ timeBodyGyroscopeJerk-MEAN-Y                    : num [1:180] -0.0415 -0.0402 -0.0441 -0.0398 -0.044 ...
 $ timeBodyGyroscopeJerk-MEAN-Z                    : num [1:180] -0.0741 -0.0467 -0.049 -0.0461 -0.027 ...
 $ timeBodyGyroscopeJerk-STD-X                     : num [1:180] -0.919 -0.992 -0.993 -0.207 -0.487 ...
 $ timeBodyGyroscopeJerk-STD-Y                     : num [1:180] -0.968 -0.99 -0.995 -0.304 -0.239 ...
 $ timeBodyGyroscopeJerk-STD-Z                     : num [1:180] -0.958 -0.988 -0.992 -0.404 -0.269 ...
 $ timeBodyAccelerometerMagnitude-MEAN             : num [1:180] -0.8419 -0.9485 -0.9843 -0.137 0.0272 ...
 $ timeBodyAccelerometerMagnitude-STD              : num [1:180] -0.7951 -0.9271 -0.9819 -0.2197 0.0199 ...
 $ timeGravityAccelerometerMagnitude-MEAN          : num [1:180] -0.8419 -0.9485 -0.9843 -0.137 0.0272 ...
 $ timeGravityAccelerometerMagnitude-STD           : num [1:180] -0.7951 -0.9271 -0.9819 -0.2197 0.0199 ...
 $ timeBodyAccelerometerJerkMagnitude-MEAN         : num [1:180] -0.9544 -0.9874 -0.9924 -0.1414 -0.0894 ...
 $ timeBodyAccelerometerJerkMagnitude-STD          : num [1:180] -0.9282 -0.9841 -0.9931 -0.0745 -0.0258 ...
 $ timeBodyGyroscopeMagnitude-MEAN                 : num [1:180] -0.8748 -0.9309 -0.9765 -0.161 -0.0757 ...
 $ timeBodyGyroscopeMagnitude-STD                  : num [1:180] -0.819 -0.935 -0.979 -0.187 -0.226 ...
 $ timeBodyGyroscopeJerkMagnitude-MEAN             : num [1:180] -0.963 -0.992 -0.995 -0.299 -0.295 ...
 $ timeBodyGyroscopeJerkMagnitude-STD              : num [1:180] -0.936 -0.988 -0.995 -0.325 -0.307 ...
 $ frequencyBodyAccelerometer-MEAN-X               : num [1:180] -0.9391 -0.9796 -0.9952 -0.2028 0.0382 ...
 $ frequencyBodyAccelerometer-MEAN-Y               : num [1:180] -0.86707 -0.94408 -0.97707 0.08971 0.00155 ...
 $ frequencyBodyAccelerometer-MEAN-Z               : num [1:180] -0.883 -0.959 -0.985 -0.332 -0.226 ...
 $ frequencyBodyAccelerometer-STD-X                : num [1:180] -0.9244 -0.9764 -0.996 -0.3191 0.0243 ...
 $ frequencyBodyAccelerometer-STD-Y                : num [1:180] -0.834 -0.917 -0.972 0.056 -0.113 ...
 $ frequencyBodyAccelerometer-STD-Z                : num [1:180] -0.813 -0.934 -0.978 -0.28 -0.298 ...
 $ frequencyBodyAccelerometerJerk-MEAN-X           : num [1:180] -0.9571 -0.9866 -0.9946 -0.1705 -0.0277 ...
 $ frequencyBodyAccelerometerJerk-MEAN-Y           : num [1:180] -0.9225 -0.9816 -0.9854 -0.0352 -0.1287 ...
 $ frequencyBodyAccelerometerJerk-MEAN-Z           : num [1:180] -0.948 -0.986 -0.991 -0.469 -0.288 ...
 $ frequencyBodyAccelerometerJerk-STD-X            : num [1:180] -0.9642 -0.9875 -0.9951 -0.1336 -0.0863 ...
 $ frequencyBodyAccelerometerJerk-STD-Y            : num [1:180] -0.932 -0.983 -0.987 0.107 -0.135 ...
 $ frequencyBodyAccelerometerJerk-STD-Z            : num [1:180] -0.961 -0.988 -0.992 -0.535 -0.402 ...
 $ frequencyBodyGyroscope-MEAN-X                   : num [1:180] -0.85 -0.976 -0.986 -0.339 -0.352 ...
 $ frequencyBodyGyroscope-MEAN-Y                   : num [1:180] -0.9522 -0.9758 -0.989 -0.1031 -0.0557 ...
 $ frequencyBodyGyroscope-MEAN-Z                   : num [1:180] -0.9093 -0.9513 -0.9808 -0.2559 -0.0319 ...
 $ frequencyBodyGyroscope-STD-X                    : num [1:180] -0.882 -0.978 -0.987 -0.517 -0.495 ...
 $ frequencyBodyGyroscope-STD-Y                    : num [1:180] -0.9512 -0.9623 -0.9871 -0.0335 -0.1814 ...
 $ frequencyBodyGyroscope-STD-Z                    : num [1:180] -0.917 -0.944 -0.982 -0.437 -0.238 ...
 $ frequencyBodyAccelerometerMagnitude-MEAN        : num [1:180] -0.8618 -0.9478 -0.9854 -0.1286 0.0966 ...
 $ frequencyBodyAccelerometerMagnitude-STD         : num [1:180] -0.798 -0.928 -0.982 -0.398 -0.187 ...
 $ frequencyBodyBodyAccelerometerJerkMagnitude-MEAN: num [1:180] -0.9333 -0.9853 -0.9925 -0.0571 0.0262 ...
 $ frequencyBodyBodyAccelerometerJerkMagnitude-STD : num [1:180] -0.922 -0.982 -0.993 -0.103 -0.104 ...
 $ frequencyBodyBodyGyroscopeMagnitude-MEAN        : num [1:180] -0.862 -0.958 -0.985 -0.199 -0.186 ...
 $ frequencyBodyBodyGyroscopeMagnitude-STD         : num [1:180] -0.824 -0.932 -0.978 -0.321 -0.398 ...
 $ frequencyBodyBodyGyroscopeJerkMagnitude-MEAN    : num [1:180] -0.942 -0.99 -0.995 -0.319 -0.282 ...
 $ frequencyBodyBodyGyroscopeJerkMagnitude-STD     : num [1:180] -0.933 -0.987 -0.995 -0.382 -0.392 ...
 ```
 