# 0. install packages 
if (!require("dplyr")) {
  install.packages("dplyr")
} else {
  print("dplyr is already installed")
}

# 1.Merges the training and the test sets to create one data set.

# 1.1 Download file 

download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip', destfile = 'Dataset.zip')

# 1.2 Unzip file

unzip('Dataset.zip') 

# 1.3 Import data into r (X_test, Y_test, X_train, Y_train, subject_test, subject_train, features.txt) 

features <- read.table('UCI HAR Dataset/features.txt')
subject_test <- read.table('UCI HAR Dataset/test/subject_test.txt',col.names = c('subject')) 
Y_test <- read.table('UCI HAR Dataset/test/y_test.txt',col.names = c('Y')) 
X_test <- read.table('UCI HAR Dataset/test/X_test.txt',col.names = features$V2) 
subject_train <- read.table('UCI HAR Dataset/train/subject_train.txt',col.names = c('subject')) 
Y_train <- read.table('UCI HAR Dataset/train/y_train.txt',col.names = c('Y')) 
X_train <- read.table('UCI HAR Dataset/train/X_train.txt',col.names = features$V2) 


# 1.4 Merge data into one big table
test <- cbind(subject_test,Y_test,X_test) 
train <- cbind(subject_train, Y_train, X_train) 
full <- rbind(test, train) #Ans

# 2.Extracts only the measurements on the mean and standard deviation for each measurement. 

# get the col_names 

fullColNames <- names(full)

# get only mean or std 

extractColumn <- grep(".*(mean|std).*",fullColNames, ignore.case = TRUE ) 

# bind everything into variable newDF 

newDF <- cbind(subject = full$subject, Y = full$Y, full[extractColumn]) #Ans

# 3.Uses descriptive activity names to name the activities in the data set

# read table 'activity_labels.txt' as activity for looking up

activity <- read.table('UCI HAR Dataset/activity_labels.txt') 

# Indexing the lookup vector 

full$Y <- activity$V2[full$Y] 

# Change column name to make it more read-able 

colnames(full)[which(names(full) == "Y")] <- c('Activity')

# 4.Appropriately labels the data set with descriptive variable names. 

new_features <- gsub('^t','time.',features$V2) # change t to time.
new_features <- gsub('^f','freq.',new_features) # change f to freq. 
new_features <- gsub('[-!@#$%^&*()_+,]','.',new_features) # change any special character to '.'
new_features <- gsub('\\.\\.\\.','.',new_features) 
new_features <- gsub('\\.\\.','.',new_features) 
# Change column name into readable format 

colnames(full) <- c('subject', 'Activity', new_features) 

# Remove duplicates 
full_clean <- full[,!duplicated(as.list(full))]

# 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Group the data by column subject and activity

groupby_data <- full_clean %>% group_by(subject,Activity) 

# Generate tidy data set with the average of each variable for each activity and each subject. 

tidy <- summarise_each(groupby_data, funs(mean)) 

View(tidy) #Here's the tidy data
write.table(tidy,file = 'tidy_data.txt',row.names = FALSE) # Code Output

