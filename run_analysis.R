library(plyr)
library(dplyr)

col_titles <- read.table('./UCI HAR Dataset/features.txt',stringsAsFactors = FALSE)
col_titles <- col_titles[,2] #Remove the index to give just names

test_data <- read.table('./UCI HAR Dataset/test/X_test.txt',stringsAsFactors = FALSE, col.names = col_titles)
train_data <- read.table('./UCI HAR Dataset/train/X_train.txt',stringsAsFactors = FALSE, col.names = col_titles)
test_activity <- read.table('./UCI HAR Dataset/test/y_test.txt',stringsAsFactors = FALSE, col.names = "ActivityID")
train_activity <- read.table('./UCI HAR Dataset/train/y_train.txt',stringsAsFactors = FALSE, col.names = "ActivityID")
test_subject <- read.table('./UCI HAR Dataset/test/subject_test.txt',stringsAsFactors = FALSE, col.names = "SubjectID")
train_subject <- read.table('./UCI HAR Dataset/train/subject_train.txt',stringsAsFactors = FALSE, col.names = "SubjectID")

activity_labels <- read.table('./UCI HAR Dataset/activity_labels.txt',stringsAsFactors = FALSE, col.names = c("ActivityID","Activity"))

merged <- merge(test_data,train_data,all = TRUE)
merged <- merged[, grep("mean\\.|std\\.",names(merged),value = TRUE)]


merged$ActivityID <- c(test_activity[,1],train_activity[,1])
merged$Activity <- activity_labels[merged$ActivityID,2]
merged$SubjectID <- c(test_subject[,1],train_subject[,1])

TidyTable <- merged %>% group_by(SubjectID,Activity) %>% summarise_each(funs(mean))
