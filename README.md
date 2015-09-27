## This is the readME documentation

### The code supplied in this repo ("run_analysis.R") applies the transformations required for the course project
### on the Coursera MOOC "Getting and Cleaning Data".

As referenced in the read-me file for the data, the data represents HAR using Smartphones.
The code reads in the raw data - 6 files: the subject ID files (2 files), the activity file (Y, 2 files),
and the observed measurements (x, 2 files).
The goal is to create a tidy data set which summarises the mean and average standard deviation, by subject and
activity.

### Steps taken in script

 The first step (line 5 in the code) takes the compressed folder which was downloaded from the course website.
 The unzip command then extracts the data to the current workspace under a folder called "UCI HAR Dataset",
 this will only work if the zipped folder is in your workspace. If you have already extracted the files to your
 workspace in the correct structure you will not need to carry out this step.

 Line 13 in the code reads in the variable names (features) for the observed measurements. I decided to read these
 in first, so that they can be used when the measurements (datasets with prefix X) are read in.

 Lines 17 to 27 read in the various test and training datasets. The code is similar for each read in procedure,
 with a couple of things to note. Firstly the filepaths will need to match those on your computer for the code to
 function (hence it is useful if the original structure from the zipped file is retained), and secondly for the 
 X_test.txt and X_train.txt, the col.names option is also used to assign the variable names (from the features 
 dataset that we read in prior to this step). This ensures that the measured observations have sensible
 descriptive names.

 For the purposes of the task, it is not important to distinguish between test and training data. Hence the next
 step is to append the training and test data sets, so we only have 3 datasets: Subject, X and Y. This is done 
 using the rbind command.

 Then focussing on the Subject data, the variable is named Subject_ID to give a better description of the variable
 (line 50). Similarly the variable in the dataset Y is renamed activity.

 We only wish to extract the variables that relate to the mean or standard deviation of the observed measurements.
 Without much more knowledge of the data, the way I have chosen to do this is to extract any variables that 
 contain the strings "mean()" or "std()". The grep function is used to produce a vector of the columns which
 contain these strings. A new dataset Z is created - a subset of X only containing the selected columns (lines 
 69 to 74 in the script). Line 78 then combines the 3 datasets (Subject, Y and Z) into a single dataset.

 Line 82 reads in the activity names (as the current activities are coded 1 to 6). Lines 84 to 86 then merges on
 the activity names, and deletes the original numbered code. The activities now have more descriptive labels.

 Lines 92 to 93 create a dataset which takes an average of the observed values by subject and activity, leaving a
 dataset with 180 rows and 68 columns. Line 98 then outputs this table to a txt file in your directory.
