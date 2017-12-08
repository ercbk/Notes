# plotly
### These are just basic examples. Much more on their website.




library(plotly)
set.seed(100)



## Scatterplot

d <- diamonds[sample(nrow(diamonds), 1000), ]
plot_ly(d, x = ~carat, y = ~price, color = ~carat,
        size = ~carat, text = ~paste("Clarity: ", clarity))




## Using with ggplot2

p <- ggplot(data = d, aes(x = carat, y = price)) +
  geom_point(aes(text = paste("Clarity:", clarity))) +
  geom_smooth(aes(colour = cut, fill = cut)) + facet_wrap(~ cut)

ggplotly(p)




# basic histogram

p <- plot_ly(x = ~rnorm(50), type = "histogram")

# Create a shareable link to your chart
# Set up API credentials: https://plot.ly/r/getting-started
chart_link = plotly_POST(p, filename="histogram/1")
chart_link

## Overlaid Histogram

p <- plot_ly(alpha = 0.6) %>%
  add_histogram(x = ~rnorm(500)) %>%
  add_histogram(x = ~rnorm(500) + 1) %>%
  layout(barmode = "overlay")




## Basic boxplot

p <- plot_ly(y = ~rnorm(50), type = "box") %>%
  add_trace(y = ~rnorm(50, 1))

## Adding Jittered Points

p <- plot_ly(y = ~rnorm(50), type = "box", boxpoints = "all", jitter = 0.3,
             pointpos = -1.8)

## Several Boxplots

p <- plot_ly(ggplot2::diamonds, y = ~price, color = ~cut, type = "box")

## Grouped Boxplots

p <- plot_ly(ggplot2::diamonds, x = ~cut, y = ~price, color = ~clarity, type = "box") %>%
  layout(boxmode = "group")

## Styling Outliers

y1 <- c(0.75, 5.25, 5.5, 6, 6.2, 6.6, 6.80, 7.0, 7.2, 7.5, 7.5, 7.75, 8.15,
        8.15, 8.65, 8.93, 9.2, 9.5, 10, 10.25, 11.5, 12, 16, 20.90, 22.3, 23.25)
y2 <- c(0.75, 5.25, 5.5, 6, 6.2, 6.6, 6.80, 7.0, 7.2, 7.5, 7.5, 7.75, 8.15,
        8.15, 8.65, 8.93, 9.2, 9.5, 10, 10.25, 11.5, 12, 16, 20.90, 22.3, 23.25)
y3 <- c(0.75, 5.25, 5.5, 6, 6.2, 6.6, 6.80, 7.0, 7.2, 7.5, 7.5, 7.75, 8.15,
        8.15, 8.65, 8.93, 9.2, 9.5, 10, 10.25, 11.5, 12, 16, 20.90, 22.3, 23.25)
y4 <- c(0.75, 5.25, 5.5, 6, 6.2, 6.6, 6.80, 7.0, 7.2, 7.5, 7.5, 7.75, 8.15,
        8.15, 8.65, 8.93, 9.2, 9.5, 10, 10.25, 11.5, 12, 16, 20.90, 22.3, 23.25)

p <- plot_ly(type = 'box') %>%
  add_boxplot(y = y1, jitter = 0.3, pointpos = -1.8, boxpoints = 'all',
              marker = list(color = 'rgb(7,40,89)'),
              line = list(color = 'rgb(7,40,89)'),
              name = "All Points") %>%
  add_boxplot(y = y2, name = "Only Whiskers", boxpoints = FALSE,
              marker = list(color = 'rgb(9,56,125)'),
              line = list(color = 'rgb(9,56,125)')) %>%
  add_boxplot(y = y3, name = "Suspected Outlier", boxpoints = 'suspectedoutliers',
              marker = list(color = 'rgb(8,81,156)',
                            outliercolor = 'rgba(219, 64, 82, 0.6)',
                            line = list(outliercolor = 'rgba(219, 64, 82, 1.0)',
                                        outlierwidth = 2)),
              line = list(color = 'rgb(8,81,156)')) %>%
  add_boxplot(y = y4, name = "Whiskers and Outliers", boxpoints = 'outliers',
              marker = list(color = 'rgb(107,174,214)'),
              line = list(color = 'rgb(107,174,214)')) %>%
  layout(title = "Box Plot Styling Outliers")




## Basic line plot
## (This looks like a time series plot. There is a section for
## time series but they're all scatterplots. Go figure.)

x <- c(1:100)
random_y <- rnorm(100, mean = 0)
data <- data.frame(x, random_y)

p <- plot_ly(data, x = ~x, y = ~random_y, type = 'scatter', mode = 'lines')


## Facetted line graph (3 lines)

trace_0 <- rnorm(100, mean = 5)
trace_1 <- rnorm(100, mean = 0)
trace_2 <- rnorm(100, mean = -5)
x <- c(1:100)

data <- data.frame(x, trace_0, trace_1, trace_2)

### Same graph but two ways of coding
### one way
p <- plot_ly(data, x = ~x) %>%
  add_trace(y = ~trace_0, name = 'trace 0',mode = 'lines') %>%
  add_trace(y = ~trace_1, name = 'trace 1', mode = 'lines+markers') %>%
  add_trace(y = ~trace_2, name = 'trace 2', mode = 'markers')
### The other way (Think I like the first one)
p <- plot_ly(data, x = ~x, y = ~trace_0, name = 'trace 0', type = 'scatter', mode = 'lines') %>%
  add_trace(y = ~trace_1, name = 'trace 1', mode = 'lines+markers') %>%
  add_trace(y = ~trace_2, name = 'trace 2', mode = 'markers')


## Fitted lines
## The average between high and low temperature is the fitted line here
## but (see notes pg 148) fitted pts + CI pts can be put into a dataframe
## and substituted into this code.

month <- c('January', 'February', 'March', 'April', 'May', 'June', 'July',
           'August', 'September', 'October', 'November', 'December')
high_2014 <- c(28.8, 28.5, 37.0, 56.8, 69.7, 79.7, 78.5, 77.8, 74.1, 62.6, 45.3, 39.9)
low_2014 <- c(12.7, 14.3, 18.6, 35.5, 49.9, 58.0, 60.0, 58.6, 51.7, 45.2, 32.2, 29.1)
data <- data.frame(month, high_2014, low_2014)
data$average_2014 <- rowMeans(data[,c("high_2014", "low_2014")])

#The default order will be alphabetized unless specified as below:
data$month <- factor(data$month, levels = data[["month"]])

p <- plot_ly(data, x = ~month, y = ~high_2014, type = 'scatter', mode = 'lines',
             line = list(color = 'transparent'),
             showlegend = FALSE, name = 'High 2014') %>%
  add_trace(y = ~low_2014, type = 'scatter', mode = 'lines',
            fill = 'tonexty', fillcolor='rgba(0,100,80,0.2)', line = list(color = 'transparent'),
            showlegend = FALSE, name = 'Low 2014') %>%
  add_trace(x = ~month, y = ~average_2014, type = 'scatter', mode = 'lines',
            line = list(color='rgb(0,100,80)'),
            name = 'Average') %>%
  layout(title = "Average, High and Low Temperatures in New York",
         paper_bgcolor='rgb(255,255,255)', plot_bgcolor='rgb(229,229,229)',
         xaxis = list(title = "Months",
                      gridcolor = 'rgb(255,255,255)',
                      showgrid = TRUE,
                      showline = FALSE,
                      showticklabels = TRUE,
                      tickcolor = 'rgb(127,127,127)',
                      ticks = 'outside',
                      zeroline = FALSE),
         yaxis = list(title = "Temperature (degrees F)",
                      gridcolor = 'rgb(255,255,255)',
                      showgrid = TRUE,
                      showline = FALSE,
                      showticklabels = TRUE,
                      tickcolor = 'rgb(127,127,127)',
                      ticks = 'outside',
                      zeroline = FALSE))


## Density Plots

dens <- with(diamonds, tapply(price, INDEX = cut, density))
df <- data.frame(
  x = unlist(lapply(dens, "[[", "x")),
  y = unlist(lapply(dens, "[[", "y")),
  cut = rep(names(dens), each = length(dens[[1]]$x))
)

p <- plot_ly(df, x = ~x, y = ~y, color = ~cut) %>%
  add_lines()
