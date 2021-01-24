#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

rm(list = ls())
library(shiny)
library(quanteda)
library(dplyr)

# Working directory
    # Needed to avoid conflict with Shiny
wd <- "C:/Users/cliva/OneDrive - Analytic Base/personalFilesManu/data_science/coursera_courses/data_scientist/10_capstoneProj"

# Function files
        source(paste0(wd,"/rCode/finalScripts/functions.R"))
        source(paste0(wd,"/rCode/finalScripts/functionSBO.R"))
        source(paste0(wd,"/rCode/finalScripts/functionKBO.R"))
        source(paste0(wd,"/rCode/finalScripts/modelSBO.R"))
        source(paste0(wd,"/rCode/finalScripts/modelKBO.R"))


# Data load     
    wordsSW85Df <- readRDS(paste0(wd, "/data/processedData/wordsSW85Df.RDS"))    
##
    # Assign also values
    df <- getWordOnLetters("a", wordsSW85Df)
    hit1 <- df[1,1]
    # hit2 <- df[2,1]
    hit2 <- "alpha"
    # hit3 <- df[3,1]
    hit3 <- "bravo"
    inputValue <- ""
##    
    
    # getWordOnLetters("", wordsSW85Df)



# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    # output$predict <- renderText{
    #     df <- getWordOnLetters(input$textInput, wordsSW85Df)
    #     hit1 <- df[1,1]
    #     hit2 <- df[2,1]
    #     hit3 <- df[3,1]        
    # }

# Button choices input based on algo values
    output$choice1 <- renderText({hit1})
    output$choice2 <- renderText({hit2})
    output$choice3 <- renderText({hit3})
    
    
# Reactive button values
    rChoice <- reactiveValues(userChoice = "")
    
    output$wordSelected <- renderText({
        rChoice$userChoice
    })

    observeEvent(input$choice1, {
        rChoice$userChoice <- hit2
    })

    observeEvent(input$choice2, {
        rChoice$userChoice <- hit2
    })
            
    observeEvent(input$choice3, {
        rChoice$userChoice <- hit3
    })

# Reactive texte value

    inputText <- reactive({
        input$textInput
    })

    inputChoice <- reactive({
        rChoice$userChoice
    })

    output$stringFull <- renderText({
        inputText <- inputText()
        inputChoice <- inputChoice()
        paste(inputText, inputChoice)
        })
    
  
    output$hit1 <- renderText({
        if(input$textInput > 0 & (!(grepl("[ \f\t\v]$", input$textInput)))){
            df <- getWordOnLetters(input$textInput, wordsSW85Df)
                hit1 <- df[1,1]
                # if NA return from hit
                if(is.na(hit1)){
                    # check if cause = empty space
                        hit1 <- "No hits found"
                        rChoice$userChoice <- hit1
                } else {
                    rChoice$userChoice <- hit1
                }
                # hit2 <- df[2,1]
                # hit3 <- df[3,1]
        } else if(input$textInput > 0 & ((grepl("[ \f\t\v]$", input$textInput)))){
            hit1 <- "Empty space: get function back Wi-1"
            rChoice$userChoice <- hit1
        } else {
            rChoice$userChoice <- "ZeroStart"
        }
    })

# Need to keep on doing conditions    
    
    
    
# Test

    # myString1 <- "alfa fa"
    # myString2 <- " "
    # myString3 <- ""
    # grepl("\\s*$", myString3)
    # grepl("[ \f\t\v]$", myString3)
    # 
    # myString1 > 0 & (!(grepl("[ \f\t\v]$", myString1)))
    # myString2 > 0 & (!(grepl("[ \f\t\v]$", myString2)))
    # myString3 > 0 & (!(grepl("[ \f\t\v]$", myString3)))
      
  #   prendre input
  #   premier mot + alpha
  #   
  # event  
  #   
    
    
    # updateTextInput(session, "textInput", value = renderText({paste(inputText(), inputChoice())}))
    
    # observe({
    #     #input <- input$textInput
    #     #choice <- rChoice$userChoice
    # 
    #     updateTextInput(session, "textInput", value =  paste("Fuck", input$textInput))
    # })        
    
    
    
    #output$fullText <- renderText({
        #rInput$textIntegrated <- "trial"
        #rInput$textIntegrated <- input$textInput
        #rInput$textIntegrated <- rChoice$userChoice

    #})        
    
    

 
        # output$textIntegrated <- renderText({
        #     input$textInput
        # 
        # })
        #userIntegrated <- paste(userText, userChoice)
        
})
