# Editing text variables



## Fixing character vectors

### Baltimore camera data
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://data.baltimorecity.gov/api/views/dz54-2aru/row.csv?accessType=DOWNLOAD"
download.file(fileUrl,destfile="./data/cameras.csv")
names(cameraData)
### makes all variable names use lower case letters
tolower(names(camerData))
### 6th variable name has a period in it followed by a number. strsplit splits the variable
### name from the period. "\\." argument tells function period is the 
### separator. This makes elt 6 a list with two elts.
splitNames = strsplit(names(cameraData),"\\.")
splitNames[[5]]
splitNames[[6]]


## Quick aside - lists

### Subsetting review
mylist <- list(letters=c("A","b","c"), numbers=1:3, matrix(1:25,ncol=5))
head(mylist)
mylist[[1]]
mylist$letters
mylist[1]


## Fixing character vectors - sapply()

splitNames[[6]][1]
### firstElement returns first elt of whatever is passed to it
firstElement <- function(x){x[1]}
### sapply uses firstElement to extract the first elt of the splitNames
### list we created earlier. So the ".1" in no longer a part of the variable
### and our variables are period-free.
sapply(splitNames,firstElement)


## Peer review data

if(!file.exists("./data")){dir.creat("./data")}
fileUrl1 = "https://dl.dropboxusercontent.com/u/7710864/data/reviews-apr29.csv"
fileUrl2 = "https://dl.dropboxusercontent.com/u/7710864/data/solution-apr29.csv"
download.file(fileUrl1,destfile="./data/reviews,csv")
download.file(fileUrl2,destfile="./data/solutions,csv")
reviews <- read.csv("./data/reviews.csv")
solutions <- read.csv("./data/solutions.csv")


## Fixing character vectors - sub()

### Remove an underscore from variable names
names(reviews)
sub("_","",names(reviews),)


## Fixing character vectors - gsub()

### Remove multiple underscores from variable names
testName <- "this_is_a_test"
sub("_","",testName)
gsub("_","",testName,)


## Finding values - grep(), grepl()

### Check for Alameda in var. intersection entries. Returns row #s
grep("Alameda",cameraData$intersection)
### grepl returns a T/F. Table counts Ts/Fs among all entries
table(grepl("Alameda",cameraData$intersection))
### Using grepl to subset out Alameda from data set
cameraData2 <- camerData[!grepl("Alameda",cameraData$intersection)]
### value = TRUE returns actual entry values instead of row #s
grep("Alameda",cameraData$intersection,value=TRUE)
### Examples of checking for a value that doesn't occur.
grep("JeffStreet",cameraData$intersection)
length(grep("JeffStreet",cameraData$intersection))


## More useful string functions

library(stringr)
### number of characters
nchar("Jeffrey Leek")
### keep first thru seventh letters
substr("Jeffrey Leek",1,7)
### concantenate with a space in between
paste("Jeffrey","Leek")
### concantenate with no space
paste0("Jeffrey","Leek")
### remove excess spaces
str_trim("Jeff    ")