Getting and Cleaning Data Course Project
===========================================
This project entails the collection, cleaning and analysis of an untidy dataset. Per the Coursera course, the original data was collected from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip . Files in the repo for this project should include this file (README.md), a codebook describing variables (codebook.md), and a script conducting the required analysis (run_analysis.R). The final tidy data set is uploaded separately within Coursera and so not provided here.

This script *absolutely must* be run in the "UCI HAR Dataset" directory as unzipped directly from the download link to work properly.

README.md
------------------------
You're reading it now. This file documents the purpose and contents of the repo's various files, including itself.

run_analysis.R
--------------------
This is an R script that reads the dataset prescribed for the project, pares it down to the data of interest and then outputs a CSV file with the independent, tidy dataset requested which shows the average of each measurement for each subject and activity. Files were downloaded via web browser and unzipped manually as I did not care to automate the unzipping step within the script. For this reason, a Windows filepath is included to point the script to the right point on the local drive.

The script's general workflow is as follows:
* Open the directory where the dataset as a whole is stored
* Step 1: Merge the training and test sets to create one data set
  * Load the training portion of the dataset and cbind() its components into a single data frame
  * Load the test portion of the dataset and cbind() its components into a single data frame
  * Combine the training and test datasets into a single dataframe with rbind()
* Step 2: Extract only the measurements on the mean and standard deviation for each measurement.
    * Create a full list of column names for the monolithic dataset and assign the names to their columns via "features_info.txt"
    * Step 4 completed incidentally: Appropriately label the data set with descriptive variable names.
    * remove all columns from the original dataset which are not activity or subject identifiers or means/standard deviations of measurements. grep() is used to identify columns representing means and standard deviations
* Step 3: Uses descriptive activity names to name the activities in the data set
    * Directly substitute descriptive activity names for numerical identifiers according to "activity_labels.txt" using gsub()
* Step 5: From the data set in step 4, creates a second, independent tidy dataset with the average of each variable for each activity and each subject.
    * load dplyr
    * convert dataset from data.frame to tibble
    * group tibble by activity and subject values
    * summarize all ungrouped columns of tibble by mean()
    * write a CSV file with the summarized tidy dataset to original working directory

codebook.md
---------------
Codebook for the submitted dataset. The variables of the final dataset are explained by reference to the original dataset's codebook, "features_info.txt", which is reproduced in full for the sake of thoroughness.
