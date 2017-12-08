# Shiny example, diabetes predictive function, histogram w slider

library(shiny)

## ui.R file
## Predicting diabetes from glucose measurement

### Glucose input value collected in the sidebar panel. Remember to include units.
### Default value 90. It gets inputted and calc'd as soon as the app started.
### Submit button included which means output not automatically calc'd when
### values are inputted.

### Prediction output in the main panel

shinyUI(
  pageWithSidebar(
    # Application title
    headerPanel("Diabetes prediction"),
    
    sidebarPanel(
      numericInput('glucose', 'Glucose mg/dl', 90, min = 50, max = 200, step = 5),
      submitButton('Submit')
    ),
    mainPanel(
      h3('Results of prediction'),
      h4('You entered'),
      verbatimTextOutput("inputValue"),
      h4('Which resulted in a prediction of '),
      verbatimTextOutput("prediction")
    )
  )
)

## server.R file
## Prediction function

diabetesRisk <- function(glucose) glucose / 200

## Server function

### User's input changed to a string, sent back to the main panel and displayed
### prediction value changed to a string, sent back, displayed.
shinyServer(
  function(input, output) {
    output$inputValue <- renderPrint({input$glucose})
    output$prediction <- renderPrint({diabetesRisk(input$glucose)})
  }
)



## ui.R file
## Guess the mean of a histogram with input slider

### value is the default value where the slider starts at

shinyUI(pageWithSidebar(
  headerPanel("Example plot"),
  sidebarPanel(
    sliderInput('mu', 'Guess at the mean', value = 70, min = 62, max = 74, step = 0.05)
  ),
  mainPanel(
    plotOutput('newHist')
  )
))

## server.R file

### renderPlot creates the histogram
### lines() displays where your guess is on the the histogram
### mean square error of your guess is calc'd then displayed along
### with your input mean in the histogram by text()
### All of this is assigned to newHist which is used by plotOutput() in
### the main panel above.

library(UsingR)
data(galton)

shinyServer(
  function(input, output) {
    output$newHist <- renderPlot({
      hist(galton$child, xlab='child height', col='lightblue',main='Histogram')
      mu <- input$mu
      lines(c(mu, mu), c(0, 200),col="red",lwd=5)
      mse <- mean((galton$child - mu)^2)
      text(63, 150, paste("mu = ", mu))
      text(63, 140, paste("MSE = ", round(mse, 2)))
    })
    
  }
)

