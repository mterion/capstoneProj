# MAIN FILE

# RAN Memory management
        # Restart with a clean fresh session
        .rs.restartR()  
        rm(list = ls()) # Is it needed ?

## Increase memory limit
        Sys.info()
        memory.limit()
        memory.size()
        memory.limit(size = 60000)
        gc()        # And gc() regularly in code as well
        
## Load libraries
        library(quanteda)
        library(readtext)
        library(quanteda.textmodels)
        library(quanteda.corpora)
        library(devtools)
        library(spacyr)
        library(newsmap)
        library(stringi)
        library(stringr)
        library(dplyr)
        library(crayon) # for cat colors green
        library(newsmap) # for geographical dict
        library(ggplot2)
        library(plotly)

#=======================
# Corpus Creation
#=======================

# Clear and call libraries
        source("./rCode/finalScripts/clearStart.R")

# Call function file
        source("./rCode/finalScripts/functions.R")
        source("./rCode/finalScripts/functionSBO.R")
        source("./rCode/finalScripts/functionKBO.R")
        source("./rCode/finalScripts/modelSBO.R")
        source("./rCode/finalScripts/modelKBO.R")

# Load data, summary and corpus creation
        source("./rCode/finalScripts/dataLoad.R")
        
        # Save / read
        saveRDS(cAll, "./data/processedData/cAll.RDS")
        
        cAll <- readRDS("./data/processedData/cAll.RDS")

# Tokenization
        source("./rCode/finalScripts/dataTokens.R")

        # Save / read
        toksCAll <- readRDS("./data/processedData/toksCAll.RDS")
        toksCBlogs <- readRDS("./data/processedData/toksCBlogs.RDS")
        toksCNews <- readRDS("./data/processedData/toksCNews.RDS")
        toksCTwitts <- readRDS("./data/processedData/toksCTwitts.RDS")

# NGrams operations
        source("./rCode/finalScripts/dataNGram.R")
        
# Data partition
        source("./rCode/finalScripts/dataPartitionFull.R")

# Minimal frequency threshold for ngram2 and ngram3 - > compared to processing time and accuracy
        source("./rCode/finalScripts/minimalFrequencyTable.R")
        
# Test of the algo on the test set
        source("./rCode/finalScripts/test.R")  
        
        

        
        
# Document-feature matrix and feature co-occurence matrix
        #source("./rCode/rawCode/dfm_fcm.R")

        
        
# End spacy session        
        spacy_finalize()
        
        #https://stackoverflow.com/questions/53505068/couldn-t-link-model-to-en-core-web-md-on-a-windows-10/53516347