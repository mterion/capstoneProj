
#===============================
# Vocabulary - Tokens partition
#===============================        
        
# Read token with SW
        toksCAll <- readRDS("./data/processedData/toksCAll.RDS")
        toksCAllSW <- readRDS("./data/processedData/toksCAllSW.RDS")
        head(toksCAll); head(toksCAllSW)

# Cumulative freq table for SW
        toksNGram1CAllSW <- tokens_ngrams(toksCAllSW, 1)
                head(toksNGram1CAllSW)
        dfmToks1CAllSW <- dfm(toksNGram1CAllSW, remove="")
                head(dfmToks1CAllSW)

        # Create DF
        colSumToksSW <- colSums(dfmToks1CAllSW)
        featNamesToksSW <- names(colSumToksSW)
                head(featNamesToksSW); tail(featNamesToksSW)
        nrWordCAllSW <- length(featNamesToksSW) # For SW: 778654, for All: 778487 -> means that stopwords do not increase much the nr of words
        
# # Check delta in nr of ngram1 for both SW et ALL
#         #Cumulative freq table for All
#         toksNGram1CAll <- tokens_ngrams(toksCAll, 1)
#                 head(toksNGram1CAll)
#         dfmToks1CAll <- dfm(toksNGram1CAll, remove="")
#                 head(dfmToks1CAll)
# 
#         # Create DF
#         colSumToks <- colSums(dfmToks1CAll)
#         featNamesToks <- names(colSumToks)
#                 head(featNamesToks); tail(featNamesToks)
#         nrWordCAll <- length(featNamesToks)        
#         
        
        
        tableFeatFreq <- data.frame(featNamesToksSW, colSumToksSW) %>%
                        arrange(desc(colSumToksSW)) %>% 
                        rename(count = colSumToksSW) %>%
                        rename(ngrams = featNamesToksSW) %>%
                        mutate(cumSum = cumsum(count)) %>%
                        mutate(cumSumDivTotalWord = cumSum / sum(count))
                
        row.names(tableFeatFreq) <- 1: nrow(tableFeatFreq)
        
        featFreq95ToKeepDf <- tableFeatFreq %>%
                filter(cumSumDivTotalWord <= 0.95)
        
        featFreq98ToKeepDf <- tableFeatFreq %>%
                filter(cumSumDivTotalWord <= 0.98)
        
        
# Token words representing 95% of the vocabulary
        toksCAllSW95 <- tokens_select(x = toksCAllSW, pattern = featFreq95ToKeepDf$ngrams, selection = "keep", valuetype = "fixed", padding=TRUE ) # fixed for exact matching
        
        dfmToks1CAllSW95 <- dfm(toksCAllSW95, remove="")
        colSumToksCAllSW95 <- colSums(dfmToks1CAllSW95)
        featNamesToksCAllSW95 <- names(colSumToksCAllSW95)
        nrWordCAllSW95 <- length(featNamesToksCAllSW95)
        
# Token words representing 98% of the vocabulary   
        toksCAllSW98 <- tokens_select(x = toksCAllSW, pattern = featFreq98ToKeepDf$ngrams, selection = "keep", valuetype = "fixed", padding=TRUE ) # fixed for exact matching
        
        dfmToks1CAllSW98 <- dfm(toksCAllSW98, remove="")
        colSumToksCAllSW98 <- colSums(dfmToks1CAllSW98)
        featNamesToksCAllSW98 <- names(colSumToksCAllSW98)
        nrWordCAllSW98 <- length(featNamesToksCAllSW98)
        
# Check nr word        
        nrWordCAllSW95; nrWordCAllSW98; nrWordCAllSW; 
        # Results: 19949; 60599; 778654
# Save
        saveRDS(toksCAllSW95, "./data/processedData/toksCAllSW95.RDS")
        saveRDS(toksCAllSW98, "./data/processedData/toksCAllSW98.RDS")
        
#==================================================================================================
# Test done on the whole corpus with no partition train/test
#==================================================================================================       

toksCAllSW <- readRDS("./data/processedData/toksCAllSW.RDS")        
toksCAllSW95 <- readRDS("./data/processedData/toksCAllSW95.RDS")
toksCAllSW98 <- readRDS("./data/processedData/toksCAllSW98.RDS")                
        
#╥Check nr ngrams
        # n1All<- tokens_ngrams(toksCAll, 1)
        # n2All <- tokens_ngrams(toksCAll, 2)
        # n3All <- tokens_ngrams(toksCAll, 3)
        # 
        # n1AllDfm <- dfm(n1All)
        # n2AllDfm <- dfm(n2All)
        # n3AllDfm <- dfm(n3All)
        
        n1All <- ngramFreqDfFun(toksCAllSW, 1); n2All <- ngramFreqDfFun(toksCAllSW, 2); n3All <- ngramFreqDfFun(toksCAllSW, 3)        
        n195 <- ngramFreqDfFun(toksCAllSW95, 1); n295 <- ngramFreqDfFun(toksCAllSW95, 2); n395 <- ngramFreqDfFun(toksCAllSW95, 3)
        n198 <- ngramFreqDfFun(toksCAllSW98, 1); n298 <- ngramFreqDfFun(toksCAllSW98, 2); n398 <- ngramFreqDfFun(toksCAllSW98, 3)

        nrow(n1All); nrow(n2All); nrow(n3All) # 778'654; 14'024'608; 44'356'951
        nrow(n198); nrow(n298); nrow(n398) # 60'600; 11'048'219; 39'772'664
        nrow(n195); nrow(n295); nrow(n395) # 19950; 8'142'840; 33'588'050
        
        # saveRDS(n1All, "./data/processedData/n1All.RDS")
        # saveRDS(n2All, "./data/processedData/n2All.RDS")
        # saveRDS(n3All, "./data/processedData/n3All.RDS")
        # 
        # saveRDS(n198, "./data/processedData/n198.RDS")
        # saveRDS(n298, "./data/processedData/n298.RDS")
        # saveRDS(n398, "./data/processedData/n398.RDS")
        # 
        # saveRDS(n195, "./data/processedData/n195.RDS")
        # saveRDS(n295, "./data/processedData/n295.RDS")
        # saveRDS(n395, "./data/processedData/n395.RDS")
        
        n1All <- readRDS("./data/processedData/n1All.RDS")
        n2All <- readRDS("./data/processedData/n2All.RDS")
        n3All <- readRDS("./data/processedData/n3All.RDS")
        
        n198 <- readRDS("./data/processedData/n198.RDS")
        n298 <- readRDS("./data/processedData/n298.RDS")
        n398 <- readRDS("./data/processedData/n398.RDS")
        
        n195 <- readRDS("./data/processedData/n195.RDS")
        n295 <- readRDS("./data/processedData/n295.RDS")
        n395 <- readRDS("./data/processedData/n395.RDS")
        
        rm(dfmToks1CAll, dfmToks1CAllSW95, dfmToks1CAllSW98, featFreq95ToKeepDf, featFreq98ToKeepDf, tableFeatFreq, toksCAllSW, toksNGram1CAll)
        rm(colSumToks, colSumToksCAllSW95, colSumToksCAllSW98, featNamesToks, featNamesToksCAllSW95, featNamesToksCAllSW98)
        rm(n1All, n2All, n3All, n195, n295, n395, n198, n298, n398)
        
        n298F <- n298 %>%
                filter(freq > 5) # if 1 = 3'882'419 left, if 2 = 2'433'741, if 3 = 1806986, if 4 = 1451970, if 5 = 1220452
        nrow(n298F)
        
        n398F <- n398 %>%
                filter(freq > 5) # if 1 = 7284026 left, if 2 = 3734561, if 3 = 2482362, if 4 = 1847346, if 5 = 1465230
        nrow(n398F)
        
        n295F <- n295 %>%
                filter(freq > 5) # if 1 = 3235387 left, if 2 = 2103454, if 3 = 1593757, if 4 = 1299086, if 5 = 1103741
        nrow(n295F)
        
        n395F <- n395 %>%
                filter(freq > 5) # if 1 = 6844914 left, if 2 = 3588688, if 3 = 2407900, if 4 = 1801536, if 5 = 1433992
        nrow(n395F)
        
        # Conclusion:
                # Advantage of 95 instead of 98 is mainly by n1
        
        
#===============================
# Partition: train / test set with 95% / 98% of vocabulary
#===============================

# Partition train / test set
        # TTS mean that partition is done on the trainTestSet col
                # later, the partition will be done on the trainValidTestSet col (TVT) when using DL model
        toksCAllSW <- readRDS("./data/processedData/toksCAllSW.RDS")
        toksCAllTrain <- tokens_subset(toksCAllSW, trainTestSet == "train") # train is not recorded bec I will use only the 95% of the word of the vocabulary for training (for computing efficiency)
        toksCAllTest <- tokens_subset(toksCAllSW, trainTestSet == "test")
                saveRDS(toksCAllTest, "./data/processedData/toksCAllTest.RDS")
                
                # test
                ndoc(toksCAllTrain) + ndoc(toksCAllTest) == ndoc(toksCAllSW)
                rm(toksCAllSW)

# Get train Df
        # Cumulative freq table for SW
        toksN1Train <- tokens_ngrams(toksCAllTrain, 1)
                head(toksN1Train)
        dfmToksN1Train <- dfm(toksN1Train, remove="")
                head(dfmToksN1Train)

        # Create DF
        colSumN1Train <- colSums(dfmToksN1Train)
        featNamesN1Train <- names(colSumN1Train)
                head(featNamesN1Train); tail(featNamesN1Train)
                length(featNamesN1Train) ####### nr = 683158
                

# Cumulative df
       tableFeatFreq <- data.frame(featNamesN1Train, colSumN1Train) %>%
                        arrange(desc(colSumN1Train)) %>% 
                        rename(count = colSumN1Train) %>%
                        rename(ngrams = featNamesN1Train) %>%
                        mutate(cumSum = cumsum(count)) %>%
                        mutate(cumSumDivTotalWord = cumSum / sum(count))
                
        row.names(tableFeatFreq) <- 1: nrow(tableFeatFreq)
        
        featFreq95ToKeepDf <- tableFeatFreq %>%
                filter(cumSumDivTotalWord <= 0.95)
        nrN1Train95 <- nrow(featFreq95ToKeepDf) #######  19936
        
        featFreq98ToKeepDf <- tableFeatFreq %>%
                filter(cumSumDivTotalWord <= 0.98) 
        nrN1Train98 <- nrow(featFreq98ToKeepDf) #######  60456
                
        
# Token words representing 95% of the vocabulary
        toksTrain95 <- tokens_select(x = toksCAllTrain, pattern = featFreq95ToKeepDf$ngrams, selection = "keep", valuetype = "fixed", padding=TRUE ) # fixed for exact matching
        
        dfmToksTrain95 <- dfm(toksTrain95, remove="")
        colSumDfmToksTrain95 <- colSums(dfmToksTrain95)
        featNamesToksTrain95 <- names(colSumDfmToksTrain95)
        nrWordToksTrain95 <- length(featNamesToksTrain95) #  Nr: 19936
        
        saveRDS(toksTrain95, "./data/processedData/toksTrain95.RDS")
        
# Token words representing 98% of the vocabulary   
        toksTrain98 <- tokens_select(x = toksCAllTrain, pattern = featFreq98ToKeepDf$ngrams, selection = "keep", valuetype = "fixed", padding=TRUE ) # fixed for exact matching
        
        dfmToksTrain98 <- dfm(toksTrain98, remove="")
        colSumDfmToksTrain98 <- colSums(dfmToksTrain98)
        featNamesToksTrain98 <- names(colSumDfmToksTrain98)
        nrWordToksTrain98 <- length(featNamesToksTrain98) #  Nr: 60456
        
        saveRDS(toksTrain98, "./data/processedData/toksTrain98.RDS")    
        

# Ngram
# 95% of vocabulary
        toksTrain95 <- readRDS("./data/processedData/toksTrain95.RDS")
        toksTrain98 <- readRDS("./data/processedData/toksTrain98.RDS")
        
        n1Train95 <- ngramFreqDfFun(toksTrain95, 1); timeN1Train95 <- system.time(ngramFreqDfFun(toksTrain95, 1)) # Time: 11.64 -> 19'937 obs
        n2Train95 <- ngramFreqDfFun(toksTrain95, 2); timeN2Train95 <- system.time(ngramFreqDfFun(toksTrain95, 2)) # Time: 68.27 -> 7'105'099
        n3Train95 <- ngramFreqDfFun(toksTrain95, 3); timeN3Train95 <- system.time(ngramFreqDfFun(toksTrain95, 3)) # Time: 599.50 -> 28'081'517

                
        n1Train95Df <- n1Train95 %>%
                arrange(desc(freq))
        
        n2Train95Df <- n2Train95 %>%
                arrange(desc(freq))
                head(n2Train95Df); tail(n2Train95Df)
                
        n3Train95Df <- n3Train95 %>%
                arrange(desc(freq))
                head(n3Train95Df); tail(n3Train95Df)
                
        saveRDS(n1Train95Df, "./data/processedData/n1Train95Df.RDS")
        saveRDS(n2Train95Df, "./data/processedData/n2Train95Df.RDS")
        saveRDS(n3Train95Df, "./data/processedData/n3Train95Df.RDS")
        
# Ngram
# 98% of vocabulary        
        n1Train98 <- ngramFreqDfFun(toksTrain98, 1); timeN1Train98 <- system.time(ngramFreqDfFun(toksTrain98, 1)) # Time: 48.71 -> 60'457
        n2Train98 <- ngramFreqDfFun(toksTrain98, 2); timeN2Train98 <- system.time(ngramFreqDfFun(toksTrain98, 2)) # Time: 182.37 -> 9'542'701
        n3Train98 <- ngramFreqDfFun(toksTrain98, 3); timeN3Train98 <- system.time(ngramFreqDfFun(toksTrain98, 3)) # Time: 722.91 -> 33'102'110

        n1Train98Df <- n1Train98 %>%
                arrange(desc(freq))
        
        n2Train98Df <- n2Train98 %>%
                arrange(desc(freq))
                head(n2Train98Df); tail(n2Train98Df)
                
        n3Train98Df <- n3Train98 %>%
                arrange(desc(freq))
                head(n3Train98Df); tail(n3Train98Df)
                
        saveRDS(n1Train98Df, "./data/processedData/n1Train98Df.RDS")
        saveRDS(n2Train98Df, "./data/processedData/n2Train98Df.RDS")
        saveRDS(n3Train98Df, "./data/processedData/n3Train98Df.RDS")
        
# Conclusion:
        # For computing effciency -> choice made on using train 95 only
        
#===============================
# Exploration of train 95
#===============================        

        n1Train95Df <- readRDS("./data/processedData/n1Train95Df.RDS")
        n2Train95Df <- readRDS("./data/processedData/n2Train95Df.RDS")
        n3Train95Df <- readRDS("./data/processedData/n3Train95Df.RDS")
        
        n2Train95DfNrRowFreq <- c()
        for (i in 0:5){
                nDf <- n2Train95Df %>%
                        filter(freq > i)
                numberRow <- nrow(nDf)
                n2Train95DfNrRowFreq <- c(n2Train95DfNrRowFreq, numberRow)
        }
        n2Train95DfNrRowFreq # 0->7105099, 1->2763738, 2->1786932, 3->1350465, 4->1098106, 5->931023

        n3Train95DfNrRowFreq <- c()
        for (i in 0:5){
                nDf <- n3Train95Df %>%
                        filter(freq > i)
                numberRow <- nrow(nDf)
                n3Train95DfNrRowFreq <- c(n3Train95DfNrRowFreq, numberRow)
        }
        n3Train95DfNrRowFreq # 0->28081517, 1->5532679, 2->2876598, 3->1921757, 4->1433057, 5->1138121
        
# Function individual testing       
        ngram1FreqDf <<- n1Train95Df
        ngram2FreqDf <<- n2Train95Df %>%
                filter(freq > 20) # origin is 1 
        ngram3FreqDf <<- n3Train95Df%>%
                filter(freq > 20) # origin is 1 
        
        timeSBO <- system.time(getBestSBOVal("I want to")) # SBO freq test: 15= 1.75, 10=2.53, 6=4.39, 5=5.36, 4=6.69, 3=9.26, 2 = 14.00, 1 = 28.757
        timeKBO <- system.time(getBestKBOVal("I want to")) # KBO freq test: 15=1.58, 10=2.57, 6=4.33, 5=5.4, 4=6.65, 3=9.19, 2 = 13.56, 1= 26.38

                
 

#===============================
# Sample obs and test function
#===============================
# TrainSet -> with 95% vocabulary
        toksCAllTrain <- readRDS("./data/processedData/toksTrain95.RDS")
        nrDocTrain <- ndoc(toksCAllTrain)
        
# Test set
        toksCAllTest <- readRDS("./data/processedData/toksCAllTest.RDS")

        
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

#=============================================================        
# To run tonight        
        
# Frequency Loop   
        # Need to check optimal Freq nr (20-26)
        summaryDf <- data.frame(trainSet = numeric(), freqMin = numeric(), testSetSample = numeric(), SBOHitPer = numeric(), KBOHitPer = numeric(), SBOTime = numeric(), KBOTime = numeric())

        startTime <- Sys.time()
                for (i in seq(20, 25, 1)){
                        sumDf <- getTrainTestResultsFreq(trainSampleNr_ = nrDocTrain, testSampleNr_ = 1000, freqMin_ = i)
                        summaryDf <- rbind(summaryDf, sumDf)
                        cat(green("Summary df done: ", i,"\n"))
                        gc()
                }
        endTime <- Sys.time()
        processingTime <- endTime-startTime
        
        summaryDf1 <- summaryDf %>%
                mutate(SBOTimeSec = round(as.numeric(SBOTime * 60), digits = 2)) %>%
                mutate(KBOTimeSec = round(as.numeric(SBOTime * 60), digits = 2))
        save(summaryDf1, "./data/processedData/summaryDf/sumFreqChecks.RDS")

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
        
        
        
# ====        
        

saveRDS(summaryDf, "./data/processedData/summaryDf/SW95_100_percent_26min_n1away.RDS")
# getTrainTestResults(10000, 1000) # 1 min de calcul pour 10'000 sample et 100 test

# Conclusion:
        # if remove ngram2 and 3 with freq <2, gain 50% elapsed time
        # we reach higher averages (19 instead of 15%) but the model is more unstable 
        # next try should be to consider only 95 % of the vocabulary with full ngram
t1 <- readRDS("./data/processedData/summaryDf/1000_6Hours_n1away.RDS")
# t2: ngram1: 17461, ngram2: 180158, ngram3: 144098
t2 <- readRDS("./data/processedData/summaryDf/100_percent_40min_n1away.RDS")
t3 <- readRDS("./data/processedData/summaryDf/100_percent_20min_n2away.RDS")
t4 <- readRDS("./data/processedData/summaryDf/SW98_100_percent_37min_n1away.RDS")

# t5: ngram1: 19925, ngram2: 180158, ngram3: 144098
t5 <- readRDS("./data/processedData/summaryDf/SW95_100_percent_26min_n1away.RDS")

t1; t2; t3; t4; t5
