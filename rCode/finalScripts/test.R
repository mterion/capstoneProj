#===============================
# Sample obs and test function
#===============================
# TrainSet -> with 95% vocabulary!!!

        toksCAllTrain <- readRDS("./data/processedData/toksTrain95.RDS")
        nrDocTrain <- ndoc(toksCAllTrain)
        
        ngram1TrainFreqDfFull <- readRDS("./data/processedData/ngram1TrainFreqDfFull.RDS")
        ngram2TrainFreqDfFull <- readRDS("./data/processedData/ngram2TrainFreqDfFull.RDS")
        ngram3TrainFreqDfFull <- readRDS("./data/processedData/ngram3TrainFreqDfFull.RDS")

        
# Test set
        toksCAllTest <- readRDS("./data/processedData/toksCAllTest.RDS")

        
        
                                
            ngram1FreqDf <<- ngram1TrainFreqDfFull
            ngram3FreqDf <<- ngram3TrainFreqDfFull%>%
            ngram2FreqDf <<- ngram2TrainFreqDfFull %>%
                                filter(freq > freqMin_) # origin is 1
                                filter(freq > freqMin_) # origin is 1            

        
# Sample Loop        
        summaryDf <- data.frame(trainSet = numeric(), testSetSample = numeric(), SBOHitPer = numeric(), KBOHitPer = numeric(), SBOTime = numeric(),  KBOTime = numeric())

        startTime <- Sys.time()
        
                for (i in seq(10000, nrDocTrain, 10000)){
                        sumDf <- getTrainTestResults(trainSampleNr_ = i, testSampleNr_ = 100, n2FreqMin_ = 15, n3FreqMin_ = 15)
                        summaryDf <- rbind(summaryDf, sumDf)
                        cat(green("Summary df done: ", i,"\n"))
                        gc()
                }
        
        endTime <- Sys.time()
        
        processingTime <- endTime-startTime


        
# result the same at 30% hit for all Freq bec:
        # Either word not found, but in this case the back off model should have made a difference
        # Either word found, but given the fact that sequence limited to 3grams, the proba of having the 3rd ford following 2 other where higher than the reality
#=============================================================         
        
                
### Trial
        nrDocTrain <- 2000000 
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
        
        
        
        startTime <- Sys.time()
                        sumDf <- getTrainTestResults(trainSampleNr_ = nrDocTrain, testSampleNr_ = 100, n2FreqMin_ = 10, n3FreqMin_ = 10)
                        summaryDf <- rbind(summaryDf, sumDf)
                        cat(green("Summary df done: ", i,"\n"))
                        gc()
                
        endTime <- Sys.time()
        
        processingTime <- endTime-startTime
        
# need to go !!!!!!!!!!!!!
nrDocTrain <- nrDocTrain 

        startTime <- Sys.time()
                        sumDf <- getTrainTestResults(trainSampleNr_ = nrDocTrain, testSampleNr_ = 10000, n2FreqMin_ = 25, n3FreqMin_ = 25)
                        summaryDf <- rbind(summaryDf, sumDf)
                        cat(green("Summary df done: ", i,"\n"))
                        gc()
                
        endTime <- Sys.time()
        
        processingTime1 <- endTime-startTime        
        
        startTime <- Sys.time()
                        sumDf <- getTrainTestResults(trainSampleNr_ = nrDocTrain, testSampleNr_ = 1000, n2FreqMin_ = 20, n3FreqMin_ = 20)
                        summaryDf <- rbind(summaryDf, sumDf)
                        cat(green("Summary df done: ", i,"\n"))
                        gc()
                
        endTime <- Sys.time()
        
        processingTime2 <- endTime-startTime        
        
        
        
