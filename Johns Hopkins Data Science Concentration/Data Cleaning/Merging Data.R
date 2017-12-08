# Merging Data



## Peer review data

### Peer review study (model for scientific peer review)
### SAT questions answered (solutions) in one set
### People who reviewed those answers to decide whether they were right
### or wrong in the other set.
if(!file.exists("./data")){dir.creat("./data")}
fileUrl1 = "https://dl.dropboxusercontent.com/u/7710864/data/reviews-apr29.csv"
fileUrl2 = "https://dl.dropboxusercontent.com/u/7710864/data/solution-apr29.csv"
download.file(fileUrl1,destfile="./data/reviews,csv")
download.file(fileUrl2,destfile="./data/solutions,csv")
reviews <- read.csv("./data/reviews.csv")
solutions <- read.csv("./data/solutions.csv")
### similar to a SQL database these two sets have corresponding variables
### For reviews, one is "solution id" which corresponds with "id" in the
### solutions data set.
head(reviews)
head(solutions)


## Merging data

### Using solution id and id to merge datasets
### all=TRUE means include all variables not common to both data sets.
### Also insert NAs for missing values/rows. the x variable name will be
### used in place of the y variable name in the merged data set.
names(reviews)
names(solutions)
mergedData = merge(reviews,solutions,by.x="solution_id",by.y="id",all=TRUE)
head(mergedData)


## Default - merge all common column names

### Showing using merge() default values. Shows other variables common
### to both data sets but have different values. SO same name but not
### same variable. The merge creates different rows with same id numbers.
intersect(names(solutions)),names(reviews)
mergedData2 = merge(reviews,solutions,all=TRUE)
head(mergedData2)


## Using join in the plyr package

### faster but has fewer features than merge. Can only merge datasets
### common variable names. So not applicable with peer review data set.
df1 = data.frame(id=sample(1:10),x=rnorm(10))
df2 = data.frame(id=sample(1:10),y=rnorm(10))
### joins 2 data sets by id. Arrange orders data set by id in ascending order.
arrange(join(df1,df2),id)


## If you have multiple data frames

### Using join_all()
df3 = data.frame(id=sample(1:10),z=rnorm(10))
dfList = list(df1,df2,df3); dfList
arrange(join_all(dfList),id)