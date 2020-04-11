# load libraries
library(dplyr) 

# read train data 
train_x   <- read.table("./train/X_train.txt")
train_y   <- read.table("./train/Y_train.txt") 
train_sub <- read.table("./train/subject_train.txt")

# read test data 
test_x   <- read.table("./test/X_test.txt")
test_y   <- read.table("./test/Y_test.txt") 
test_sub <- read.table("./test/subject_test.txt")

# read features description 
features <- read.table("./features.txt") 

# read activity labels 
activity_labels <- read.table("./activity_labels.txt") 
colnames(activity_labels) <- c("activityid", "activity")

# merge of training and test sets
total_x   <- rbind(train_x, test_x)
total_y   <- rbind(train_y, test_y) 
total_sub <- rbind(train_sub, test_sub) 

# Adding column names for the merged dataset
colnames(total_x) <- features[,2]
colnames(total_y) <- "activityid"
colnames(total_sub) <- "subjectid"
data_with_label <- cbind(total_y, total_sub, total_x)

# keep only measurements for mean and standard deviation 
select_columns <- grepl("*mean\\(\\)|*std\\(\\)|activityid|subjectid", names(data_with_label))
selected_data <- data_with_label[ , select_columns]

# Replace the actvity IDs with the descriptive names for the activity.
labelled_data <- merge(selected_data, activity_labels, by = "activityid") 
labelled_data <- labelled_data[, c(2,ncol(labelled_data), 3:(ncol(labelled_data)-1))]

# Create a tidy data set where the average for each of the variables has been calculated for each activity and subject combination and shown on a single row.
TidyData <- aggregate(.~subjectid + activity, labelled_data, mean)
TidyData <- arrange(TidyData, subjectid)

# Tidy Data
write.table(TidyData, "TidyData.txt", row.names = FALSE, quote = FALSE)
