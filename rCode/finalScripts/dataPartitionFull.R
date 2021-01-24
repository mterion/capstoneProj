
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
        
        featFreq98ToKeepDf <- tableFeatFreq %>%
                filter(cumSumDivTotalWord <= 0.98) # 60599
        
        featFreq95ToKeepDf <- tableFeatFreq %>%
                filter(cumSumDivTotalWord <= 0.95) # 19949
        
        featFreq90ToKeepDf <- tableFeatFreq %>%
                filter(cumSumDivTotalWord <= 0.90) # 7905
        
        featFreq85ToKeepDf <- tableFeatFreq %>%
                filter(cumSumDivTotalWord <= 0.85) # 4184
        
        featFreq80ToKeepDf <- tableFeatFreq %>%
                filter(cumSumDivTotalWord <= 0.80) # 2448
        
        featFreq70ToKeepDf <- tableFeatFreq %>%
                filter(cumSumDivTotalWord <= 0.70) # 941 word
        
        featFreq60ToKeepDf <- tableFeatFreq %>%
                filter(cumSumDivTotalWord <= 0.60) # 366 words
        
        featFreq50ToKeepDf <- tableFeatFreq %>%
                filter(cumSumDivTotalWord <= 0.50) # 138 words
        
        nrow(featFreq85ToKeepDf)
        
        
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
        
# Token words representing 90% of the vocabulary   
        toksCAllSW90 <- tokens_select(x = toksCAllSW, pattern = featFreq90ToKeepDf$ngrams, selection = "keep", valuetype = "fixed", padding=TRUE ) # fixed for exact matching
        
        dfmToks1CAllSW90 <- dfm(toksCAllSW90, remove="")
        colSumToksCAllSW90 <- colSums(dfmToks1CAllSW90)
        featNamesToksCAllSW90 <- names(colSumToksCAllSW90)
        nrWordCAllSW90 <- length(featNamesToksCAllSW90)
        
        wordsSW90Df <- data.frame(word = featNamesToksCAllSW90, freq = colSumToksCAllSW90) %>%
        arrange(word)
        row.names(wordsSW90Df) <- NULL
        
# Token words representing 85% of the vocabulary   
        toksCAllSW85 <- tokens_select(x = toksCAllSW, pattern = featFreq85ToKeepDf$ngrams, selection = "keep", valuetype = "fixed", padding=TRUE ) # fixed for exact matching
        
        dfmToks1CAllSW85 <- dfm(toksCAllSW85, remove="")
        colSumToksCAllSW85 <- colSums(dfmToks1CAllSW85)
        featNamesToksCAllSW85 <- names(colSumToksCAllSW85)
        nrWordCAllSW85 <- length(featNamesToksCAllSW85)
        
        wordsSW85Df <- data.frame(word = featNamesToksCAllSW85, freq = colSumToksCAllSW85) %>%
        arrange(word)
        row.names(wordsSW85Df) <- NULL
        
# Token words representing 80% of the vocabulary   
        toksCAllSW80 <- tokens_select(x = toksCAllSW, pattern = featFreq80ToKeepDf$ngrams, selection = "keep", valuetype = "fixed", padding=TRUE ) # fixed for exact matching
        
        dfmToks1CAllSW80 <- dfm(toksCAllSW80, remove="")
        colSumToksCAllSW80 <- colSums(dfmToks1CAllSW80)
        featNamesToksCAllSW80 <- names(colSumToksCAllSW80)
        nrWordCAllSW80 <- length(featNamesToksCAllSW80)
        
        wordsSW80Df <- data.frame(word = featNamesToksCAllSW80, freq = colSumToksCAllSW80) %>%
        arrange(word)
        row.names(wordsSW80Df) <- NULL
        
# Token words representing 70% of the vocabulary   
        toksCAllSW70 <- tokens_select(x = toksCAllSW, pattern = featFreq70ToKeepDf$ngrams, selection = "keep", valuetype = "fixed", padding=TRUE ) # fixed for exact matching
        
        dfmToks1CAllSW70 <- dfm(toksCAllSW70, remove="")
        colSumToksCAllSW70 <- colSums(dfmToks1CAllSW70)
        featNamesToksCAllSW70 <- names(colSumToksCAllSW70)
        nrWordCAllSW70 <- length(featNamesToksCAllSW70)
        
        wordsSW70Df <- data.frame(word = featNamesToksCAllSW70, freq = colSumToksCAllSW70) %>%
        arrange(word)
        row.names(wordsSW70Df) <- NULL
        
# Token words representing 60% of the vocabulary   
        toksCAllSW60 <- tokens_select(x = toksCAllSW, pattern = featFreq60ToKeepDf$ngrams, selection = "keep", valuetype = "fixed", padding=TRUE ) # fixed for exact matching
        
        dfmToks1CAllSW60 <- dfm(toksCAllSW60, remove="")
        colSumToksCAllSW60 <- colSums(dfmToks1CAllSW60)
        featNamesToksCAllSW60 <- names(colSumToksCAllSW60)
        nrWordCAllSW60 <- length(featNamesToksCAllSW60)
        
        wordsSW60Df <- data.frame(word = featNamesToksCAllSW60, freq = colSumToksCAllSW60) %>%
        arrange(word)
        row.names(wordsSW60Df) <- NULL
        
# Token words representing 50% of the vocabulary   
        toksCAllSW50 <- tokens_select(x = toksCAllSW, pattern = featFreq50ToKeepDf$ngrams, selection = "keep", valuetype = "fixed", padding=TRUE ) # fixed for exact matching
        
        dfmToks1CAllSW50 <- dfm(toksCAllSW50, remove="")
        colSumToksCAllSW50 <- colSums(dfmToks1CAllSW50)
        featNamesToksCAllSW50 <- names(colSumToksCAllSW50)
        nrWordCAllSW50 <- length(featNamesToksCAllSW50)
        
        wordsSW50Df <- data.frame(word = featNamesToksCAllSW50, freq = colSumToksCAllSW50) %>%
                arrange(word)
                row.names(wordsSW50Df) <- NULL
        
        
# Check nr word        
        nrWordCAllSW; nrWordCAllSW98; nrWordCAllSW95; nrWordCAllSW90; nrWordCAllSW85; nrWordCAllSW80; nrWordCAllSW70; nrWordCAllSW60; nrWordCAllSW50;
        # [1] 778654
        # [1] 60599
        # [1] 19949
        # [1] 7905
        # [1] 4184
        # [1] 2448
        # [1] 941
        # [1] 366
        # [1] 138
        
# Save
        saveRDS(toksCAllSW95, "./data/processedData/toksCAllSW95.RDS")
        saveRDS(toksCAllSW98, "./data/processedData/toksCAllSW98.RDS")
        
        saveRDS(wordsSW50Df, "./data/processedData/wordsSW50Df.RDS")
        saveRDS(wordsSW60Df, "./data/processedData/wordsSW60Df.RDS")
        saveRDS(wordsSW70Df, "./data/processedData/wordsSW70Df.RDS")
        saveRDS(wordsSW80Df, "./data/processedData/wordsSW80Df.RDS")
        saveRDS(wordsSW85Df, "./data/processedData/wordsSW85Df.RDS")
        saveRDS(wordsSW90Df, "./data/processedData/wordsSW90Df.RDS")
        
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
 
