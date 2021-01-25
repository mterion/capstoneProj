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
library(crayon)
library(stringi)
library(stringr)

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

        
        ngram1FreqDf <- readRDS(paste0(wd,"./data/processedData/ngram1Train95Freq21Df.RDS"))
        ngram2FreqDf <- readRDS(paste0(wd,"./data/processedData/ngram2Train95Freq21Df.RDS"))
        ngram3FreqDf <- readRDS(paste0(wd,"./data/processedData/ngram3Train95Freq21Df.RDS"))
        wordsSW85Df <- readRDS(paste0(wd,"./data/processedData/wordsSW85Df.RDS"))
        
# Tests:
    # myDf <- getBestSBODf("I")
    # myDf <- getBestKBODf("I want to")
    # myDf[1,1]


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
# Reactive button values
    rChoice <- reactiveValues(userChoice = "")
    
    output$wordSelected <- renderText({
        rChoice$userChoice
    })

    observeEvent(input$choice1, {
        rChoice$userChoice <- "hit1as"
    })

    observeEvent(input$choice2, {
        rChoice$userChoice <- "has"
    })
            
    observeEvent(input$choice3, {
        rChoice$userChoice <- "asdfasd"
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
    

# Fun to get values in action buttons
        getActionButtonValues <- function(keyboardInput, hitId){
                keyboardInput <- tolower(keyboardInput)
                if(keyboardInput > 0 & (!(grepl("[ \f\t\v]$", keyboardInput)))){
                    df <- getWordOnLetters(keyboardInput, wordsSW85Df)
                    hit <- df[hitId,1]
                        # if NA return from hit
                        if(is.na(hit)){
                            # this will be the case after an empty space, need to extract just the last word
                            lastWord <- stri_extract_last_words(keyboardInput)
                            df <- getWordOnLetters(lastWord, wordsSW85Df)
                            hit <- df[hitId,1]
                            result <- hit
                                
                        } else {
                            result <- hit
                        }

                } else if(keyboardInput > 0 & ((grepl("[ \f\t\v]$", keyboardInput)))){
                        SBODf <- getBestSBODf(keyboardInput)
                        SBOHit <- SBODf[hitId,1]
                  
                        result <- SBOHit
              
                } else {
                    result <- "ZeroStart"
                }
        if(is.na(result)){result <-""} # This ensure that the output is empty and does not show NA
        return(result)
        }

# ReactiveExpression / conductor
        # Values in action buttons        
        currentActionButtonValue1 <- reactive({ getActionButtonValues(input$textInput, hitId = 1) })
        currentActionButtonValue2 <- reactive({ getActionButtonValues(input$textInput, hitId = 2) })
        currentActionButtonValue3 <- reactive({ getActionButtonValues(input$textInput, hitId = 3) })
        
# Button choices input based on algo values
    output$choice1 <- renderText({ currentActionButtonValue1() })
    output$choice2 <- renderText({ currentActionButtonValue2() })
    output$choice3 <- renderText({ currentActionButtonValue3() })
        

# ReactiveEndpoint
        output$actionButtonValue <- renderText({ currentActionButtonValue1() })



})
