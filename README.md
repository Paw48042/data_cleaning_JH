# Explaining  on run_analysis.R 

First! let's check if the package dplyr is installed already 
```
if (!require("dplyr")) {
  install.packages("dplyr")
} else {
  print("dplyr is already installed")
}
```
## 1.Merges the training and the test sets to create one data set. 

Let's start with download file from the internet and save it in the working directory as **Dataset.zip**
```
download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip', destfile = 'Dataset.zip')
```
Next Step, Let's unzip the downloaded file in the working directory. 
```
unzip('Dataset.zip') 
```
Now that we have data from the unzipped file, Check inside, and then import data into R using `read.table` 
the data we will import into R is 
- X_test.txt
- Y_test.txt
- Subject_test.txt
- X_train.txt
- Y_train.txt
- Subject_train.txt
- features.txt 
```
features <- read.table('UCI HAR Dataset/features.txt')
subject_test <- read.table('UCI HAR Dataset/test/subject_test.txt',col.names = c('subject')) 
Y_test <- read.table('UCI HAR Dataset/test/y_test.txt',col.names = c('Y')) 
X_test <- read.table('UCI HAR Dataset/test/X_test.txt',col.names = features$V2) 
subject_train <- read.table('UCI HAR Dataset/train/subject_train.txt',col.names = c('subject')) 
Y_train <- read.table('UCI HAR Dataset/train/y_train.txt',col.names = c('Y')) 
X_train <- read.table('UCI HAR Dataset/train/X_train.txt',col.names = features$V2) 
```
Now after inspect we will notice that X test, X train both have 561 columns, however Y and subject both have only 1 column but have the rows match the X_test, X_train. 
Here's we will notice that we have to merge these into train table and test table with cbinds and store it in the `test` and `train` variable
```
test <- cbind(subject_test,Y_test,X_test) 
train <- cbind(subject_train, Y_train, X_train) 
```

After Merging, we will want the big data table for further task. So, we will merge it with rbind and store it in the `full` variable

`full <- rbind(test, train) #Ans`

This is where the first task finished

## 2.Extracts only the measurements on the mean and standard deviation for each measurement. 

From this, we will extract colnames from `full`
```
fullColNames <- names(full)
```

Since the task ask us to get `mean` or `std`, we will use `grep` command combine with regular expressions. to get only variable that have mean or std in the name. 

Then we stored it in `extractColumn` Variable

```
extractColumn <- grep(".*(mean|std).*",fullColNames, ignore.case = TRUE ) 
```

Now, bind everything and store it into `newDF` variable
```
newDF <- cbind(subject = full$subject, Y = full$Y, full[extractColumn]) 
```

# 3.Uses descriptive activity names to name the activities in the data set

In order to do this, we have to import the file `activity_labels.txt` into R first, store it in variable named `activity`
```
activity <- read.table('UCI HAR Dataset/activity_labels.txt') 
```
After that, we will indexing through `activity`. R will lookup in activity and replace numbers in `full$Y` with strings. 
```
full$Y <- activity$V2[full$Y] 
```

Now that we change from numbers to activity, using column name Y might not be suitable and might make confusion to the others.
So I decide to change column name into `Activity`
```
colnames(full)[which(names(full) == "Y")] <- c('Activity')
```
# 4.Appropriately labels the data set with descriptive variable names. 

This task ask us to change column name to be more readable, so we change from `t` to `time` and `f` to `freq` to make it more readable. 
Then we use regex to change any special character into `.` to avoid any errors. Finally, We trim out the `...` and `..` make it just one dot to make out column name more readable. This process done in the variable new_features to avoid any error if happen.

```
new_features <- gsub('^t','time.',features$V2) # change t to time.
new_features <- gsub('^f','freq.',new_features) # change f to freq. 
new_features <- gsub('[-!@#$%^&*()_+,]','.',new_features) # change any special character to '.'
new_features <- gsub('\\.\\.\\.','.',new_features) 
new_features <- gsub('\\.\\.','.',new_features)
```
After done the modifying, now we will change the column names using function `colnames()`.
```
colnames(full) <- c('subject', 'Activity', new_features) 
```


# 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

### Note: After I tried to group data using `group_by`. I found out that the data have duplicates column. So, to make the process run smoothly. We will remove duplicates first.
```
full_clean <- full[,!duplicated(as.list(full))]
```

#### Group the data by column subject and activity
Now, we will group data by subject and activity since the task ask to create a second, independent tidy data set with the average of each variable for each activity and each subject. 
```
groupby_data <- full_clean %>% group_by(subject,Activity) 
```

Then we generate the tidy data set with average of each variable and each subject using `summarise_each()` function 
```
tidy <- summarise_each(groupby_data, funs(mean)) 
```
View the tidy data
```
View(tidy) #Here's the tidy data 
```
Now, final steps. Let's export the data out as a text file for the submission.
```
write.table(tidy,file = 'tidy_data.txt',row.names = FALSE) # Code Output
```
Thank you for reading! 
By the way, the task is lack of details. 
If you're not clear why the solution has to be this way.
For more information about the solution. I found mentor mention this slide on discussion forum years ago. hope it's help 
```
https://drive.google.com/file/d/1TiA9Re1y16HTJ_7xUvsW1V15blzjvj03/view
```
