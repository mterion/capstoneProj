#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Natural Language Processing Application"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            radioButtons("radio", 
                         h3("Type of NLP Model"),
                         choices = list(
                             "SBO" = 1,
                             "KBO" = 2
                         ), selected = 1)
        ), # End of sidebarPanel

        # Show a plot of the generated distribution
        mainPanel(
            textInput(inputId = "textInput",
                  label = h3("Text Input"), 
                  value = inputValue,
                  width= "100%"
            ),
            div(style="display:inline-block;width:50%;text-align: center;",
                actionButton("choice2", textOutput("choice2")),
                actionButton("choice1", textOutput("choice1")),
                actionButton("choice3", textOutput("choice3")),
            ),
            
           h3("Returned Value:"),
           #textOutput("wordSelected")
           #textOutput("textIntegrated")
           #textOutput("fullText")
           textOutput("stringFull"),
           textOutput("predict"),
           textOutput("hit1")
           
           
            
        ) # End of mainPanel
    ) # End of sidebarLayout
)) # End of shiny UI and fluidPage
