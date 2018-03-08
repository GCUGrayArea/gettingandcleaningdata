origwd <- getwd() # stores the original working directory to come back to later

# Step 1: Merge the training and test sets to create one data set

datahome <- "C:/Users/Graham/Documents/R Programming/Data Cleaning Project/UCI HAR Dataset"
                # stores the main directory to maintain absolute reference point
setwd(datahome)
setwd("./train")# opens the directory storing the training set

trainsubj <- read.table("subject_train.txt") #loads training subjects
traindata <- read.table("X_train.txt") # loads training data
trainlabel <- read.table("y_train.txt")  # loads training labels

train <- cbind(trainlabel, trainsubj, traindata)
rm("trainlabel"); rm("trainsubj"); rm("traindata")
        # merges test subjects, labels and training data into data frame "train"
        # and deletes the original data frames from memory

setwd(datahome) # returns to the main directory
setwd("./test") # opens the directory storing the test data

testsubj <- read.table("subject_test.txt") #loads test subjects
testdata <- read.table("X_test.txt")   # loads test data
testlabel <- read.table("y_test.txt")    # loads test labels
test <- cbind(testlabel, testsubj, testdata); rm("testlabel"); rm("testdata")
        # merges test labels and training data into data frame "test"
        # and deletes the original data frames from memory

dataset <- rbind(train, test); rm("train"); rm("test")
        # combines training and test sets into one data frame and
        # deletes the original data frames from memory

setwd(datahome) # the features.txt file is here, so we need to go back
features <- read.table("features.txt", stringsAsFactors = FALSE)[, 2]
        # loads the feature names. StringsAsFactors is set to false so the names
        # are read in as class character, and the first column (containing
        # only row indices) is dropped, resulting in a 561-element
        # character vector



# Both sets are now in a single combined dataset. Step 1 complete.

# Step 2: Extracts only the measurements on the mean and standard deviation
# for each measurement.


colnames(dataset) <- c("activity", "subject", features)
        # enters the column names for activity, subject and each features

vars <- c("activity", "subject", grep("-mean()", features, value = TRUE),
                grep("-std()", features, value = TRUE))
        # creates a new vector with only the mean() and std() column names
        # plus the activity and subject identifiers at far left

dataset <- dataset[, colnames(dataset) %in% vars]; rm("vars")
        # removes all columns from the dataset which are not of interest
        # activity and subject identifiers and the mean()s and std()s are kept

# Our combined dataset has now been purged of everything but the activity and
# subject identifiers and the mean() and std() of each measurement.
# Step 2 complete.

# Step 3: Uses descriptive activity names to name the activities in the data set

# class(dataset$activity) <- "character"
        # coerces activity label column to a character vector so we can easily
        # substitute numbers for names using gsub()

dataset$activity <- gsub("1", "walking", dataset$activity, fixed = TRUE)
dataset$activity <- gsub("2", "walkingUpstairs", dataset$activity, fixed = TRUE)
dataset$activity <- gsub("3", "walkingDownstairs", dataset$activity, fixed = TRUE)
dataset$activity <- gsub("4", "sitting", dataset$activity, fixed = TRUE)
dataset$activity <- gsub("5", "standing", dataset$activity, fixed = TRUE)
dataset$activity <- gsub("6", "laying", dataset$activity, fixed = TRUE)
        # substitutes activity names in place of numerical values according to
        # the "activity_labels.txt file included in the original dataset

# Activities are now descriptively named rather than numbered. Step 3 complete.

# Step 4: Appropriately labels the data set with descriptive variable names.

# This step was already accomplished above. The descriptive variable names
# "activity" and "subject" were added to the feature names. each column in
# our cut-down dataset is now labeled with variable names from the original
# dataset's codebook.

# Step 5: From the data set in step 4, creates a second, independent tidy data
# set with the average of each variable for each activity and each subject.

library(dplyr)  # dplyr is needed. tibbles will be easier to group in the way
                # we're interested in there

overview <- dataset %>% tbl_df %>% group_by(activity, subject) %>%
        summarize_all(mean)

# overview is a tibble storing the average value of each measurement for each
# possible activity-subject combination. Step 5 complete.

setwd(origwd) # returns to the originally stored working directory
write.csv(overview, "submitteddataset.csv")
