# Shiny template


library(shiny)

## Basic example showing how HTML is used.

### headerPanel() is for the overall "title" of your app

### sidebarPanel() will be on the left side of the browser
### h1 (header level 1) font size is largest and its text is towards the top of the page followed
### in size and location by h2 > h3 > h4
### Usually used for user input

### mainPanel() is on the right side and usually where the output is displayed
### code() is for displaying code
### p() is for displaying ordinary text

shinyUI(pageWithSidebar(
  headerPanel("Illustrating markup"),
  sidebarPanel(
    h1('Sidebar panel'),
    h1('H1 text'),
    h2('H2 Text'),
    h3('H3 Text'),
    h4('H4 Text')
    
  ),
  mainPanel(
    h3('Main Panel text'),
    code('some code'),
    p('some ordinary text')
  )
))


## Input values

### numericInput('input variable', 'title', default value, min value, max value, step size)
### Allows user to input number via keyboard or clicking up or down

### checkboxGroupInput('input variable', 'title', c('available input name' = 'value assigned', ...))
### Useful when input values are limited to just a few options. Allows for text inputs.

### dateInput('date variable', 'title')
### For inputting a date. User can also make use of a pop-up calendar.

### He mixed single and double quotes but I assume either is fine.
### He also left the main panel blank but fills it in below.

shinyUI(pageWithSidebar(
  headerPanel("Illustrating inputs"),
  sidebarPanel(
    numericInput('id1', 'Numeric input, labeled id1', 0, min = 0, max = 10, step = 1),
    checkboxGroupInput("id2", "Checkbox",
                       c("Value 1" = "1",
                         "Value 2" = "2",
                         "Value 3" = "3")),
    dateInput("date", "Date:")  
  ),
  mainPanel(
    
  )
))

## Displaying outputs 
## Output is just displaying inputs but allowing user to see what input is entered and
## is being used in the calculation is good practice. Can get confusing when inputting
## value getting output, inputting value and getting output, etc..

### This is the main panel he left out above.
### h3 is the title
### h4 is title of output 1 which comes from the server function below and displays
### it in the main panel. Same thing for other outputs.

mainPanel(
  h3('Illustrating outputs'),
  h4('You entered'),
  verbatimTextOutput("oid1"),
  h4('You entered'),
  verbatimTextOutput("oid2"),
  h4('You entered'),
  verbatimTextOutput("odate")
)

## Server function

### renderPrint looks like it takes the input and makes it a string. It's then assigned
### to a variable of the output object. verbatimTextOutput (above) then displays
### the string.

shinyServer(
  function(input, output) {
    output$oid1 <- renderPrint({input$id1})
    output$oid2 <- renderPrint({input$id2})
    output$odate <- renderPrint({input$date})
  }
)




