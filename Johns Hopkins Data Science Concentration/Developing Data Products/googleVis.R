# googleVis






suppressPackageStartupMessages(library(googleVis))

### This is sort of a multichart with buttons for bubble, bar, and line.
### Has a slider on the bottom that show how values change with time. Plus other stuff.
### In the demo(googleVis) presentation that opens a browser window, chart requires flash player.
M <- gvisMotionChart(Fruits, "Fruit", "Year",
                     options=list(width=600, height=400))
### Uses print here for slidify presentation so it shows in the slide
### Just working in RStudio, you can use plot(M)
print(M,"chart")



## Maps

### Exports is the dataframe. locationvar can either be a var in your df or latitude,longitude (supposedly)
G <- gvisGeoChart(Exports, locationvar="Country",
                  colorvar="Profit",options=list(width=600, height=400))
print(G,"chart")

### Europe is specified here by region="150"
G2 <- gvisGeoChart(Exports, locationvar="Country",
                   colorvar="Profit",options=list(width=600, height=400,region="150"))
print(G2,"chart")




## Line graphs


df <- data.frame(label=c("US", "GB", "BR"), val1=c(1,3,4), val2=c(23,12,32))
### Just a line chart that illustrates many of the customizations you can make.
### Lots of options but not seeing an easy way to make a regression plot w/CI shading.
### Probably possible but would have to dig into the documentation or do a search.
### curvetype=function just makes your line smooth instead of jagged/segmented.
Line <- gvisLineChart(df, xvar="label", yvar=c("val1","val2"),
                      options=list(title="Hello World", legend="bottom",
                                   titleTextStyle="{color:'red', fontSize:18}",                         
                                   vAxis="{gridlines:{color:'red', count:3}}",
                                   hAxis="{title:'My Label', titleTextStyle:{color:'blue'}}",
                                   series="[{color:'green', targetAxisIndex: 0}, 
                                   {color: 'blue',targetAxisIndex:1}]",
                                   vAxes="[{title:'Value 1 (%)', format:'##,######%'}, 
                                   {title:'Value 2 (\U00A3)'}]",                          
                                   curveType="function", width=500, height=300                         
                      ))
print(Line,"chart")




## Merge graphs of different types to create a facetted chart.

### Merges must be done two objects at a time.
G <- gvisGeoChart(Exports, "Country", "Profit",options=list(width=200, height=100))
T1 <- gvisTable(Exports,options=list(width=200, height=270))
M <- gvisMotionChart(Fruits, "Fruit", "Year", options=list(width=400, height=370))
GT <- gvisMerge(G,T1, horizontal=FALSE)
GTM <- gvisMerge(GT, M, horizontal=TRUE,tableOptions="bgcolor=\"#CCCCCC\" cellspacing=10")
print(GTM,"chart")




## View HTML and save it as a file

M <- gvisMotionChart(Fruits, "Fruit", "Year", options=list(width=600, height=400))
### displays HTML code
print(M)
### Guessing this saves the html code to a file in your working directory
print(M, 'chart', file='myfilename.html')


### Embed them in R markdown based documents
### Set results="asis" in the chunk options

demo(googleVis)


