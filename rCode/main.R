# MAIN FILE

# RAN Memory management
        # Restart with a clean fresh session
        .rs.restartR()  
        rm(list = ls()) # Is it needed ?

## Load libraries
        library(quanteda)
        library(readtext)
        library(quanteda.textmodels)
        library(quanteda.corpora)
        library(devtools)
        library(spacyr)
        library(newsmap)
        library(stringi)
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

# Load data, summary and corpus creation
        source("./rCode/finalScripts/dataLoad.R")
        
        # Save / read
        saveRDS(cAll, "./data/processedData/cAll.RDS")
        cAll <- readRDS("./data/processedData/cAll.RDS")

# Tokenization
        source("./rCode/finalScripts/dataTokens.R")

        # Save / read
        saveRDS(toksCAll, "./data/processedData/toksCAll.RDS")
        saveRDS(toksCBlogs, "./data/processedData/toksCBlogs.RDS")
        saveRDS(toksCNews, "./data/processedData/toksCNews.RDS")
        saveRDS(toksCTwitts, "./data/processedData/toksCTwitts.RDS")
        
        toksCAll <- readRDS("./data/processedData/toksCAll.RDS")
        toksCBlogs <- readRDS("./data/processedData/toksCBlogs.RDS")
        toksCNews <- readRDS("./data/processedData/toksCNews.RDS")
        toksCTwitts <- readRDS("./data/processedData/toksCTwitts.RDS")

# NGrams operations
        source("./rCode/finalScripts/dataNGram.R")
        

        readRDS("./figures/finalFigures/pannelFeatPlotNGram1.RDS")
        readRDS("./figures/finalFigures/pannelFeatPlotNGram2.RDS")
        readRDS("./figures/finalFigures/pannelFeatPlotNGram3.RDS")
        
        readRDS("./figures/finalFigures/nGram_1_TableAll.RDS")
        readRDS("./figures/finalFigures/nGram_1_TableBlogs.RDS")
        readRDS("./figures/finalFigures/nGram_1_TableNews.RDS")
        readRDS("./figures/finalFigures/nGram_1_TableTwitts.RDS")
        
        readRDS("./figures/finalFigures/nGram_2_TableAll.RDS")
        readRDS("./figures/finalFigures/nGram_2_TableBlogs.RDS")
        readRDS("./figures/finalFigures/nGram_2_TableNews.RDS")
        readRDS("./figures/finalFigures/nGram_2_TableTwitts.RDS")
        
        readRDS("./figures/finalFigures/nGram_3_TableAll.RDS")
        readRDS("./figures/finalFigures/nGram_3_TableBlogs.RDS")
        readRDS("./figures/finalFigures/nGram_3_TableNews.RDS")
        readRDS("./figures/finalFigures/nGram_3_TableTwitts.RDS")


# Document-feature matrix and feature co-occurence matrix
        #source("./rCode/rawCode/dfm_fcm.R")

        
        
# End spacy session        
        spacy_finalize()
        
        #https://stackoverflow.com/questions/53505068/couldn-t-link-model-to-en-core-web-md-on-a-windows-10/53516347