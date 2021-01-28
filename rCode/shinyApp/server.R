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
shinyServer(function(input, output, session) {
  
#======================================    
# Function to be used in Shiny
#====================================== 
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
                                # SBO model
                                if(model() == 1) {
                                    SBODf <- getBestSBODf(keyboardInput)
                                    SBOHit <- SBODf[hitId,1]
                                    result <- SBOHit
                                }
                                
                                # KBO model
                                if(model() == 2) {
                                    KBODf <- getBestKBODf(keyboardInput)
                                    KBOHit <- KBODf[hitId,1]
                                    result <- KBOHit
                                }
                      
                        } else {
                            result <- ""
                        }
                if(is.na(result)){result <-""} # This ensure that the output is empty and does not show NA
                return(result)
                }
                
        # fun to return input string with user choice
                getAdjustedString <- function(textString, userChoice){
                  
                          # Case of word selected while dialing a word
                                  # Need to take the last word, remove it and replace it with the selection
                          if(userChoice !="" & (!(grepl("[ \f\t\v]$", textString)))){
                                  lastWord <- stri_extract_last_words(textString)
                                  stringAdjusted <- str_remove(textString, lastWord)
                                  
                                  updateTextInput(session, "textInput", value = paste0(stringAdjusted, userChoice, " "))
                          }
                          
                          # Case of word selected after another selection
                                  # last char is empty space
                          if(userChoice !="" & ((grepl("[ \f\t\v]$", textString)))){
                                  updateTextInput(session, "textInput", value = paste0(textString, userChoice, " "))
                          }
                }
                
#======================================         
# ReactiveSource / value
#====================================== 
                
        # Object created for storing reactive values
        rChoice <- reactiveValues(userChoice = "")
                
#====================================== 
# ReactiveExpression / conductor
#====================================== 
                
        # Prediction values in action buttons        
        currentActionButtonValue1 <- reactive({ getActionButtonValues(input$textInput, hitId = 1) })
        currentActionButtonValue2 <- reactive({ getActionButtonValues(input$textInput, hitId = 2) })
        currentActionButtonValue3 <- reactive({ getActionButtonValues(input$textInput, hitId = 3) })
        
        # Model choice Values in radio: SBO vs KBO
        model <- reactive({ input$radioModel })
        # selectedChoice1 <- reactive({ input$choice1 })
        
        # Ajusted string after action button chosen by the user
        currentAdjustedString <- reactive({ getAdjustedString(input$textInput, rChoice$userChoice) })
        
#======================================         
# ReactiveEndpoint
#====================================== 
        
        # Button choices displayed input based on prediction
        output$predict1 <- renderText({ currentActionButtonValue1() })
        output$predict2 <- renderText({ currentActionButtonValue2() })
        output$predict3 <- renderText({ currentActionButtonValue3() })

        #Button action results after user selection
        output$wordSelected <- renderText({
            rChoice$userChoice
        })
                    # Observer: do not return a value but used for their side effect -> send data to the browser
                    observeEvent(input$choice1, {
                        rChoice$userChoice <- currentActionButtonValue1()
                        
                        # If observe is positive, then it will run the function that return the adjusted string after the choice selected by the user
                        currentAdjustedString()
                    })

                    observeEvent(input$choice2, {
                        rChoice$userChoice <- currentActionButtonValue2()
                        currentAdjustedString()
                    })

                    observeEvent(input$choice3, {
                        rChoice$userChoice <- currentActionButtonValue3()
                        currentAdjustedString()
                    })

})
