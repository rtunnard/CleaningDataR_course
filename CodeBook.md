<h3>CodeBook.md</h3>
<h5>This code book describes the cleaning process in `run_analysis.R`, the code used, and the final variables in the output `TidyTable`.</h5>

<h6>Overview</h6>
The `run_analysis.R` script is written to read in the Samsung wearable device data from the "UCI HAR Dataset" directory, produced when zip archive is extracted. With UCI HAR Dataset in the working directory, the script will read in data from the testing and training dataset. The full range of measurements available is trimmed to include only the mean and standard deviations of each variable.  These data are then combined with the test subject IDs and desciptions of the activities corresponding to each record.

Finally, the mean of the gyrometer variables is taken, grouped by the subject ID and activity, and output as the `TidyTable` data product.

<h6>Line descriptions</h6>
Here follows a line by line description of the code.

`ln 1-2`: import the `dplyr` and `plyr` libraries.

`ln 4`: read in the variable names from "features.txt", which will then be used as column titles for the main data.

`ln 5`: the file "features.txt" contains an id column which we will not use. Here it is trimmed to leave only the column titles.

`ln 7-8`: the testing and training datasets are read into R, using the column titles from "features.txt".

`ln 9-10`: the information giving the `ActivityID` for each row of measurements is stored in separate files: these are imported here.

`ln 11-12`: as above, but for the `SubjectID`.

`ln 14`: we import the descriptive names for each `ActivityID`.

`ln 16`: the test and train datasets and now merged. Since these two datasets have identical columns, the `all=TRUE` option is redundant. (This can be confirmed by running `any(is.na(merged))`, which would return `TRUE` is any `NA` has been introduced in this step).

`ln 17`: the R native `grep` command (familiar to any UNIX users) is invoked to select only columns which are means or standard deviations. This exlcudes `meanFrequencies`. The specific `grep` search string `"mean\\.|std\\."` searches for the strings mean. or std.. The full stop is used as non-standard characters are lost in the assignment to column titles in `ln 7-8`, replaced with full stops. This then searches the column titles in `names(merged)` and returns the titles matching this search string to be used as indexes for `merged`. The result overwrites `merged`.

`ln 20-22`: the `ActivityID`, `Activity` and `SubjectID` data are added to the `merged` data frame as new columns.

`ln 24`: here we make the `TidyTable` output. The `group_by` and `summarise_each` funtions are used in conjunction here to apply the `mean` function over every column of the grouped data <b>except</b> those used to group the data. When `SubjectID` and `Activity` are used as grouping id variables, this returns the mean for every other column, for each `SubjectID` - `Activity` pairing. 

<h6>Desciption of TidyTable</h6>
The product of the `run_analysis.R` script is the data frame `TidyTable`, with 180 observations of 69 variables in wide table format. The observations are the six unique activities (`LAYING`, `SITTING`, `WALKING`, `WALKING_DOWNSTAIRS` and`WALKING_UPSTAIRS`) for each of the 30 `SubjectID`s. The variables are:

1. `SubjectID` - a unique identifier between 1 and 30 for each of the thirty subjects.
2. `Activity` - the descriptive explantion of the activity the following measurements describe.
3 - 68. - the mean and standard deviations of the various components of the gyrometer measurements collected from the wearable devices. For each activity and subject ID the all measurements of each gyrometer component have been meaned.
69. `ActivityID` - the id code for the activities named in the `Activity` column. This has been included for refering back to the raw data at a later date.

