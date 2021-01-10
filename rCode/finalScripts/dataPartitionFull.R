        toksCAllSW <- readRDS("./data/processedData/toksCAllSW.RDS")                                            
        
        # Remove empty tokens
        
                head(docvars(toksCAllSW))

# Partition train / test set
        # TTS mean that partition is done on the trainTestSet col
                # later, the partition will be done on the trainValidTestSet col (TVT) when using DL model

        toksCAllTrainTTS <- tokens_subset(toksCAllSW, trainTestSet == "train")

        toksCAllTestTTS <- tokens_subset(toksCAllSW, trainTestSet == "test")
                # test
                ndoc(toksCAllTrainTTS) + ndoc(toksCAllTestTTS) == ndoc(toksCAllSW)


# Train set
        # Random sample of 10000
        size_ <- 10000
        trainSample <- tokens_sample(toksCAllTrainTTSRm, size_)
        head(trainSample); tail(trainSample)
        
        ngram1FreqDf <- ngramFreqDfFun(trainSample, 1)
        ngram2FreqDf <- ngramFreqDfFun(trainSample, 2) %>%
                filter(freq > 1)
        ngram3FreqDf <- ngramFreqDfFun(trainSample, 3)%>%
                filter(freq > 1)
        
                head(ngram1FreqDf); head(ngram2FreqDf); head(ngram3FreqDf)
# Model predictions
                # https://www.r-bloggers.com/2017/05/5-ways-to-measure-running-time-of-r-code/

        timeSBOVect <- system.time(
                # model prediction
                bestSBODf <- getBestSBODf("I want to fuck")
                )
        sboTime <- timeSBOVect[3]
        bestSBOValue <- bestSBODf[1,1]
        
        timeKBOVect <- system.time(
                # model prediction
                bestKBODf <- getBestKBODf("I want to fuck")
                )
        kboTime <- timeKBOVect[3]
        bestKBOValue <- bestKBODf[1,1]

        Sys.time()
        
        
          1.53 / 0.03
          