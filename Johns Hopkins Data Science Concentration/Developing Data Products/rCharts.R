# rCharts






require(rCharts)

### The dataset's class is table and rCharts evidently requiress a df.
### Actually looks like two tables separated by sex. Guess this is what an array looks like.
### Sex gets it's own column as a factor var
haireye = as.data.frame(HairEyeColor)

### nPlot is a specific function for accessing the nvD3 java library.
### Bar chart with frequency in regards to hair color (x axis).
### Multi-bar so each bar will be a different eye color.
### Data is subsetted by sex.
n1 <- nPlot(Freq ~ Hair, group = 'Eye', type = 'multiBarChart',
            data = subset(haireye, Sex == 'Male')
)
n1


## Embedding your plot into a slidify project

### Plot was assigned to n1 object so it could be embedded into slidify.
### Plot is saved in an html document and needs to be in your slidify project folder.
### No idea what cdn is. No documentation for ?nPlot.
n1$save('fig/n1.html', cdn = TRUE)
### Prints out html code for the object
n1$html()
### This command is what goes into your slidify script. cat is like a print command. 
cat('<iframe src="fig/n1.html" width=100%, height=600></iframe>')

### This is what goes into the yaml section of you slidify script
## yaml ext_widgets : {rCharts: ["libraries/nvd3"]}
### If you want to embed multiple charts from multiple java libraries, this is how.
## yaml ext_widgets : {rCharts: ["libraries/highcharts", "libraries/nvd3", "libraries/morris"]}




## Example 1 Facetted Scatterplot and bar plot
## Also see next section using mtcars data. It's a little different.

### Taking out the "." in the column names
### Didn't see "\\" in the original data and couldn't find it in my regular expression notes
### so don't understand why it gets included. 
names(iris) = gsub("\\.", "", names(iris))

### rPlot accesses a different java library; type = 'point' means scatterplot
### The "| Species" part tells it to make as many different plots as there
### are levels in species. 3 different types of species therefore this creates
### 3 scatterplots w/Length as yaxis and Width as xaxis in 1 multifacetted plot.
### Without the | Species it's just 1 scatterplot w/points colored by species.
r1 <- rPlot(SepalLength ~ SepalWidth | Species, data = iris, color = 'Species', type = 'point')
r1$save('fig/r1.html', cdn = TRUE)
cat('<iframe src="fig/r1.html" width=100%, height=600></iframe>')

### Same thing, but here as a bar plot.
hair_eye = as.data.frame(HairEyeColor)
r2 <- rPlot(Freq ~ Hair | Eye, color = 'Eye', data = hair_eye, type = 'bar')
r2$save('fig/r2.html', cdn = TRUE)
cat('<iframe src="fig/r2.html" width=100%, height=600></iframe>')




## Printing the javascript; saving/publishing your chart

### am and vs are two dummy vars. "am + vs" produces the different possible
### combinations therefore 4 plots. am = 1, vs = 1; am = 1, vs = 0; etc.
### Btw, 'vs' refers to the architecture of the engine. V-shaped piston plane or Straight
### up-down piston plane.
r1 <- rPlot(mpg ~ wt | am + vs, data = mtcars, type = "point", color = "gear")
r1
r1$print("chart1") # print out the js 
r1$save('myPlot.html') #save as html file
### Not sure if gist means github or something similar
r1$publish('myPlot', host = 'gist') # save to gist, require(rjson)
r1$publish('myPlot', host = 'rpubs') # save to rpubs




## Morris library; multi-timeseries plot

data(economics, package = "ggplot2")
### Transforming the date variable from a Date class to a character var
### economics was multi-class (including df) data set but transform coerces it into a dataframe
### Wonder if the mPlot would've accepted the multi-class.
econ <- transform(economics, date = as.character(date))
### Pretty cool multi time series interactive plot I must say.
m1 <- mPlot(x = "date", y = c("psavert", "uempmed"), type = "Line", data = econ)
### This hides the data points for a pure line graph methinks
m1$set(pointSize = 0, lineWidth = 1)
m1$save('fig/m1.html', cdn = TRUE)
cat('<iframe src="fig/m1.html" width=100%, height=600></iframe>')




## X Chart library; multi-line graph (stacked?)

require(reshape2)
### Melt takes this matrix and creates a df with obs labels in a new
### column variable. Useful.
uspexp <- melt(USPersonalExpenditure)
### labeling the new column and the melted column
names(uspexp)[1:2] = c("category", "year")
### Either just a multi-line graph or maybe a stacked line graph
x1 <- xPlot(value ~ year, group = "category", data = uspexp, type = "line-dotted")
x1$save('fig/x1.html', cdn = TRUE)
cat('<iframe src="fig/x1.html" width=100%, height=600></iframe>')




## Leaflet Library; Creating Maps

map3 <- Leaflet$new()
### Setting the longitude,latitude location; maybe initial zoom level or zoom stepsize?
map3$setView(c(51.505, -0.09), zoom = 13)
### Setting pop-up location and text
map3$marker(c(51.5, -0.09), bindPopup = "<p> Hi. I am a popup </p>")
map3$marker(c(51.495, -0.083), bindPopup = "<p> Hi. I am another popup </p>")
map3$save('fig/map3.html', cdn = TRUE)
cat('<iframe src="fig/map3.html" width=100%, height=600></iframe>')




## Rickshaw library; Same type of graph as XChart but with a slider

usp = reshape2::melt(USPersonalExpenditure)
# get the decades into a date Rickshaw likes
usp$Var2 <- as.numeric(as.POSIXct(paste0(usp$Var2, "-01-01")))
p4 <- Rickshaw$new()
p4$layer(value ~ Var2, group = "Var1", data = usp, type = "area", width = 560)
# add a helpful slider this easily; other features TRUE as a default
p4$set(slider = TRUE)
p4$save('fig/p4.html', cdn = TRUE)
cat('<iframe src="fig/p4.html" width=100%, height=600></iframe>')




## highchart library; line graph with various options

h1 <- hPlot(x = "Wr.Hnd", y = "NW.Hnd", data = MASS::survey, type = c("line", 
             "bubble", "scatter"), group = "Clap", size = "Age")
h1$save('fig/h1.html', cdn = TRUE)
cat('<iframe src="fig/h1.html" width=100%, height=600></iframe>')


