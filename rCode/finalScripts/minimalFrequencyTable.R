#=============================================================        
# Frequency Loop
#=============================================================        
##
# Define:
        testSampleNr <- 10
##                
        
        
# TrainSet -> with 95% vocabulary !!!!
        toksCAllTrain <- readRDS("./data/processedData/toksTrain95.RDS")
        nrDocTrain <- ndoc(toksCAllTrain)
        
                # The whole train sample is considered to search for optimal freq taking into consideration processing time and accuracy
                        # Bec we are looking for the optimal minFreq, only the later will change in the fun
                # ngram1TrainFreqDfFull <- ngramFreqDfFun(toksCAllTrain, 1)
                # ngram2TrainFreqDfFull <- ngramFreqDfFun(toksCAllTrain, 2) 
                # ngram3TrainFreqDfFull <- ngramFreqDfFun(toksCAllTrain, 3)
                # 
                # saveRDS(ngram1TrainFreqDfFull, "./data/processedData/ngram1TrainFreqDfFull95.RDS")
                # saveRDS(ngram2TrainFreqDfFull, "./data/processedData/ngram2TrainFreqDfFull95.RDS")
                # saveRDS(ngram3TrainFreqDfFull, "./data/processedData/ngram3TrainFreqDfFull95.RDS")
        
        ngram1TrainFreqDfFull <- readRDS("./data/processedData/ngram1TrainFreqDfFull95.RDS")
        ngram2TrainFreqDfFull <- readRDS("./data/processedData/ngram2TrainFreqDfFull95.RDS")
        ngram3TrainFreqDfFull <- readRDS("./data/processedData/ngram3TrainFreqDfFull95.RDS")

        
# Test set
        # Full test set
        toksCAllTest <- readRDS("./data/processedData/toksCAllTest.RDS")
        
        # Sample test set
                # Define the nr
        testResultDf <- getTestSampleDf(testSampleNr)
        
        #Check optimal Freq min 
        summaryDf <- data.frame(trainSet = numeric(), freqMin = numeric(), testSetSample = numeric(), SBOHitPer = numeric(), KBOHitPer = numeric(), SBOTime = numeric(), KBOTime = numeric(), n1Nr = numeric(), n2Nr = numeric(), n3Nr = numeric())
        startTime <- Sys.time()
                for (i in seq(0, 30, 1)){
                        sumDf <- getTrainTestResultsFreq(trainSampleNr_ = nrDocTrain, testSampleNr_ = testSampleNr, freqMin_ = i)
                        summaryDf <- rbind(summaryDf, sumDf)
                        cat(green("Summary df done: ", i,"\n"))
                        gc()
                }
        endTime <- Sys.time()
        processingTime <- endTime-startTime # 4.30 hrs to be done
        
        # saveRDS(summaryDf, "./data/processedData/summaryDf/sumFreqChecks_10_0_30V2.RDS")
        
        sumFreqChecks <- readRDS("./data/processedData/summaryDf/sumFreqChecks_10_0_30.RDS")


# Bug in plotly to round up decimal value
        #bug need to be solved this way
        SBOTime <- c(127.658, 25.653, 14.203, 9.724,   7.326,   5.850,   5.268,   4.470,   3.938,   3.483,   3.212,   2.856,   2.603,   2.418,   2.235,
        2.102,   1.961,   1.840,   1.727,   1.761,   1.687,   0.586,   0.575,   0.547,   0.537,   0.517,   0.490,   0.487,   0.465,   0.448,
        0.437)
        KBOTime <- c(180.742,  36.786,  19.405,  13.157,   9.867,   7.894,   7.802,   6.648,   5.820,   5.112,   4.720,   4.206,   3.873,   3.528,   3.285,
        3.035,   2.880,   2.668,   2.524,   2.790,   2.609,   0.659,   0.642,   0.615,   0.606,   0.583,   0.563,   0.543,   0.521,   0.506,
        0.500)
        
# Table
        sumFreqChecksTable <- plot_ly(
              type = 'table',
              columnwidth = c(50,35,35,35,35,50,50,55, 55, 55),
              columnorder = c(1,2,3,4,5,6,7,8,9,10),
              header = list(
                values = c("Train Set", "Freq Min","Test Sample", "SBO Hits (%)", "KBO Hits (%)",  "SBO Time (sec)", "KBO Time (sec)", "n-grams 1", "n-grams 2", "n-grams 3"),
                align = c("center", "center", "center", "center", "center", "center", "center", "center", "center", "center"),
                line = list(width = 1, color = 'black'),
                fill = list(color = c("grey", "grey")),
                font = list(family = "Arial", size = 14, color = "white")
              ),
              cells = list(
                values = rbind(sumFreqChecks$trainSet, sumFreqChecks$freqMin, sumFreqChecks$testSetSample, sumFreqChecks$SBOHitPer, sumFreqChecks$KBOHitPer, SBOTime, KBOTime, sumFreqChecks$n1Nr, sumFreqChecks$n2Nr, sumFreqChecks$n3Nr),
                align = c("center", "center", "center", "center", "center", "right", "right", "right", "right", "right"),
                line = list(color = "black", width = 1),
                font = list(family = "Arial", size = 12, color = c("black"))
              ))
            
        sumFreqChecksTable
        
        saveRDS(sumFreqChecksTable, "./figures/finalFigures/sumFreqChecksTable.RDS")
        
        sumFreqChecksTable <- readRDS("./figures/finalFigures/sumFreqChecksTable.RDS")

        
# Save df for shiny app and use with SBO KBO fun
        # Minimal threshold of 21
        
        ngram1TrainFreqDfFull <- readRDS("./data/processedData/ngram1TrainFreqDfFull95.RDS")
        ngram2TrainFreqDfFull <- readRDS("./data/processedData/ngram2TrainFreqDfFull95.RDS")
        ngram3TrainFreqDfFull <- readRDS("./data/processedData/ngram3TrainFreqDfFull95.RDS")  
        
        ngram1Train95Freq21Df <<- ngram1TrainFreqDfFull
        ngram2Train95Freq21Df <<- ngram2TrainFreqDfFull %>%
                            filter(freq > 21)
        ngram3Train95Freq21Df <<- ngram3TrainFreqDfFull%>%
                            filter(freq > 21)
        
        saveRDS(ngram1Train95Freq21Df, "./data/processedData/ngram1Train95Freq21Df.RDS")
        saveRDS(ngram2Train95Freq21Df, "./data/processedData/ngram2Train95Freq21Df.RDS")
        saveRDS(ngram3Train95Freq21Df, "./data/processedData/ngram3Train95Freq21Df.RDS")
        