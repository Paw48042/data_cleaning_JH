# CodeBook

## Variables

### `subject`: Identifier for the subject who performed the activity.
### `activity`: Descriptive name of the activity (e.g., WALKING, SITTING).
### Any variable follow with mean = Average of each activity, 
  - if follow with X,Y, or Z means that it's a mean of that activity, for example time.BodyAcc.mean...X" "time.BodyAcc.mean...Y" "time.BodyAcc.mean...Z means that it's a mean of time.BodyAcc in each axis(X,Y,Z)
### Any variable follow with std = Standard deviation of each activity
   - if follow with X,Y, or Z means that it's a standard daviation of that activity, for example "time.GravityAcc.std...X" "time.GravityAcc.std...Y" "time.GravityAcc.std...Z" means that it's a std of time.GravityAcc in each axis(X,Y,Z)

for the structure of this data set, it will has 542 variable (or 542 columns) with 180 rows (6 activity on 30 subject). 
Please note that each row is a average of each subject in that activity in that variable. For example 
time.BodyAcc.mean...X will have 6 average on 6 activity (LAYING, SITTING, STANDING, WALKING, WALKING_DOWNSTAIRS, WALKING_UPSTAIRS) on 30 subject(subject 1-30)



## Note : Data transformation process has describe in the readme.md
