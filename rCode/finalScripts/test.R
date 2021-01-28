#===============================
# Sample obs and test function
#===============================
# TrainSet -> with 95% vocabulary!!!
        gc()
        toksCAllTrain <- readRDS("./data/processedData/toksTrain95.RDS")
        nrDocTrain <- ndoc(toksCAllTrain)
        
        ngram1TrainFreqDfFull <- readRDS("./data/processedData/ngram1TrainFreqDfFull95.RDS")
        ngram2TrainFreqDfFull <- readRDS("./data/processedData/ngram2TrainFreqDfFull95.RDS")
        ngram3TrainFreqDfFull <- readRDS("./data/processedData/ngram3TrainFreqDfFull95.RDS")

        
# Test set
        toksCAllTest <- readRDS("./data/processedData/toksCAllTest.RDS")
        freqMin <- 21 # threshold based on value testing made in the minimalFrequencyTable

# NEED TO RUN THIS :)        
        
                
# Testing
        # 100 obs in test sample checked in 3 min, then 20'000 = 10 hr processing
        summaryDf <- data.frame(trainSet = numeric(), testSetSample = numeric(), SBOHitPer = numeric(), KBOHitPer = numeric())

        startTime <- Sys.time()
                        sumDf <- getTrainTestResults(trainSampleNr_ = nrDocTrain, testSampleNr_ = 20000, n2FreqMin_ = freqMin, n3FreqMin_ = freqMin)
                        summaryDf <- rbind(summaryDf, sumDf)
                        gc()
        endTime <- Sys.time()
        processingTime <- endTime-startTime
        
        summaryDf
        processingTime # 8.206753 hours
        
        saveRDS(summaryDf, "./data/processedData/summaryDf/test_21_20000.RDS")
        test_21_20000 <- readRDS("./data/processedData/summaryDf/test_21_20000.RDS")


        testTable <- plot_ly(
                      type = 'table',
                      columnwidth = c(50, 50, 50, 50),
                      columnorder = c(1,2,3,4),
                      header = list(
                        values = c("Train Set Doc.", "Test Sample Doc.", "SBO Hits (%)", "KBO Hits (%)"),
                        align = c("center", "center", "center", "center"),
                        line = list(width = 1, color = 'black'),
                        fill = list(color = c("grey", "grey")),
                        font = list(family = "Arial", size = 14, color = "white")
                      ),
                      cells = list(
                        values = rbind(test_21_20000$trainSet, test_21_20000$testSetSample, test_21_20000$SBOHitPer, test_21_20000$KBOHitPer),
                        align = c("center", "center", "center", "center"),
                        line = list(color = "black", width = 1),
                        font = list(family = "Arial", size = 12, color = c("black"))
                      ))
            
        testTable
        
        saveRDS(testTable, "./figures/finalFigures/testTable.RDS")
        
        testTable <- readRDS("./figures/finalFigures/testTable.RDS")

        
        
        

#=============================================================
        ### Trials
#=============================================================         
# Coursera test
        #getBestSBOVal("I want")
        #getBestKBOVal("I want")        
                

        # with freq: 15 = 13%, 10 = 16%, 5  = 16% -> 10 seems to be the best ratio betwee computing time and accuracy -> need to confirm this on 1 mio
        # 1 mio docs with 15 Freq min = avg 15%, SBO 0.3, KBO 0.35. computing time = 3.7 min
        # 1 mio docs with 10 Freq min = avg 15%, SBO 0.45, KBO 0.5, computing time = 3.86 min
        # 2 mio docs with 15 Freq min = avg 18%, SBO 0.316, KBO 0.358, computing time = 7.08 min
        # 2 mio docs with 10 Freq min = avg 20%, SBO 2.168, KBO 3.368, computing time = 15.45 min
        # 3 mio docs with 25 Freq min = avg 10%, SBO 0.478, KBO 0.544, computing time = 9.67 min
        # 3 mio docs with 20 Freq min = avg 21%, SBO 0.084, KBO 0.076, computing time = 9.54 min
        # 3 mio docs with 15 Freq min = avg 11%, SBO 2.482, KBO4.350, computing time = 17.61 min
        # 3 mio docs with 10 Freq min = avg 17%, SBO 3.082, KBO 4,856, computing time = 22.90 min
        # 3415739, sample 1000, with 25 Freq min = avg 13.6 %, SBO 0.795, KBO 0.918, processing time = 33 min
        # 3415739, sample 1000, with 20 Freq min = avg 14.4, SBO 1.446, KBO 1.942, processing time = 1.52 hrs
        
        
        
