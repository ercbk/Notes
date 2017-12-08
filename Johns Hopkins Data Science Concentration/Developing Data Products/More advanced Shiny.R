# More advanced Shiny



library(shiny)


### ui.R

shinyUI(pageWithSidebar(
  headerPanel("Hello Shiny!"),
  sidebarPanel(
    textInput(inputId="text1", label = "Input Text1"),
    textInput(inputId="text2", label = "Input Text2")
  ),
  mainPanel(
    p('Output text1'),
    textOutput('text1'),
    p('Output text2'),
    textOutput('text2'),
    p('Output text3'),
    textOutput('text3'),
    p('Outside text'),
    textOutput('text4'),
    p('Inside text, but non-reactive'),
    textOutput('text5')
  )
))

### server.R Set x <- 0 in console before executing runApp()

library(shiny)
x <<- x + 1
y <<- 0

shinyServer(
  function(input, output) {
    y <<- y + 1
    output$text1 <- renderText({input$text1})
    output$text2 <- renderText({input$text2})
    output$text3 <- renderText({as.numeric(input$text1)+1})
    output$text4 <- renderText(y)
    output$text5 <- renderText(x)
  }
)
runApp()

### After app starts:
### text1 - no output
### text2 - no output
### text3 - NA (tries to add 1 to no output)
### text4 - 1 (because initial value is 0 outside of function and gets 1 added to it inside)
### text5 - 1 (because init val = 0 and 1 is added outside function)

### Refresh button hit
### y (text4) - 2 is incremented since its also included inside the function.
### x (text5) - 1 is unchanged since it's value is outside function
 

### Refresh hit again, and 2 inputted for text 1:
### text1 - 2
### text2 - no output
### text3 - 3 (since 2 inputted and text1 + 1 = 3)
### text4 - 3 (since refresh button hit again and y + 1 = 3)
### text5 - 1

### 5 inputted for text 2:
### text2 - 5
### All other outputs stay the same.
### What's interesting is that only text 2 is updated. Interesting because none of the
### other values appear to have been recalc'd. So shinyServer() does not get
### ran through line for line (serially). Only the pertinent line of code gets executed
### which here is "output$text2 <- renderText({input$text2})".

### So moral of the story is 
### 1. lines outside of shinyServer() get ran once
### 2. refreshing the page executes lines inside shinyServer()
### 3. After input, not every line of code gets executed only pertinent ones
### 4. When app is started server.R gets executed once



### 'showcase' shows the code in the app along with the side and main panel
### and as values get inputted, relevant code is highlighted.
runApp(display.mode='showcase')



server.R

### reactive() is a shortcut to adding a 100 to each instance of x.
### Notice x requires ().
### Unlike y <<- y+1 above, input$text1+100 needs to be inside a function. I guess
### since it's an input value.
shinyServer(
  function(input, output) {
    x <- reactive({as.numeric(input$text1)+100})      
    output$text1 <- renderText({x()                          })
    output$text2 <- renderText({x() + as.numeric(input$text2)})
  }
)

### The manual way
shinyServer(
  function(input, output) {
    output$text1 <- renderText({as.numeric(input$text1)+100  })
    output$text2 <- renderText({as.numeric(input$text1)+100 + 
        as.numeric(input$text2)})
  }
)


## ui.R

### actionButton() is described as more versatile than the submitButton
### and is preferred
shinyUI(pageWithSidebar(
  headerPanel("Hello Shiny!"),
  sidebarPanel(
    textInput(inputId="text1", label = "Input Text1"),
    textInput(inputId="text2", label = "Input Text2"),
    actionButton("goButton", "Go!")
  ),
  mainPanel(
    p('Output text1'),
    textOutput('text1'),
    p('Output text2'),
    textOutput('text2'),
    p('Output text3'),
    textOutput('text3')
  )
))

### isolate() keeps the concantenation of text1 and text2 from happening
### until the go button has been pressed.
shinyServer(
  function(input, output) {
    output$text1 <- renderText({input$text1})
    output$text2 <- renderText({input$text2})
    output$text3 <- renderText({
      input$goButton
      isolate(paste(input$text1, input$text2))
    })
  }
)

## Since button gets incremented with each button press conditional
## statements such as if (input$goButton == 1){ Conditional statements } can be
## used.

output$text3 <- renderText({
  if (input$goButton == 0) "You have not pressed the button"
  else if (input$goButton == 1) "you pressed it once"
  else "OK quit pressing it"
})


