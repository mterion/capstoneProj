# #=========================================
# # Intro
# #=========================================
# 
#         rm(list = ls())
#         library(quanteda)
#         library(dplyr)
#         library(stringi)
#         library(stringr)
#         library(crayon) # for cat colors green
#         
#         source("./rcode/functionKBO1.R")
#         
# #=========================================
# # Corpus creation
# #=========================================
# 
#         ltcorpus <- readLines("./data/testCorpus1.txt")
#         ltcorpus
#         toks <- tokens(ltcorpus, remove_punct = TRUE)
#         toks <- tokens_tolower(toks)
#     
# #=========================================
# # Function to create ngram frequency tables from the corpus
# #=========================================
#         
#     ngramFreqDfFun <- function(tokensOfTheCorpus, ngramValue){
#         tokNgram <- tokens_ngrams(tokensOfTheCorpus, ngramValue)
#         ngramDfm <- dfm(tokNgram)
#         featNames <- featnames(ngramDfm)
#         freq <- colSums(ngramDfm)
#         ngramFreqDf <- data.frame(featNames, freq)
#                 rm(ngramDfm, featNames, freq)
#                 rownames(ngramFreqDf) <- c() # Remove row names and replace them with ID nr   
#         
#         return(ngramFreqDf)
#         }
# 
#     ngram1FreqDf <- ngramFreqDfFun(toks, 1)
#     ngram2FreqDf <- ngramFreqDfFun(toks, 2)
#     ngram3FreqDf <- ngramFreqDfFun(toks, 3)
#           ngram1FreqDf; ngram2FreqDf; ngram3FreqDf


    
#=========================================
    # Main function    
#=========================================
###
        # userInput_ <- "I want to fuck a"
        # gamma2Discount_ = 0.5
        # gamma3Discount_ = 0.5
        # kValue_= 2
###        

getBestKBODf <- function(userInput_, kValue_ = 2, gamma1Discount_ = 0.5, gamma2Discount_ = 0.5, gamma3Discount_ = 0.5){
        gamma2Disc <<- gamma2Discount_
        gamma3Disc <<- gamma3Discount_
        rm(gamma2Discount_, gamma3Discount_)
  
  
    
        #=========================================
            # User input    
        #=========================================
        #userInput <- "I would like to fuck a"
            usInpTok <- tokens(userInput_, remove_punct = TRUE)
            usInpTok <- tokens_tolower(usInpTok)
            usInpTok
            lengthUserInput <- ntoken(usInpTok)
            usInpTokStr <- unlist(usInpTok)
        
            
            if(lengthUserInput >= 2){
                    ngram2Prefix <- sprintf("%s%s%s", usInpTokStr[lengthUserInput-1], "_", usInpTokStr[lengthUserInput])
            } else{
                 return("Minimal word for prediction is 2")
            }
            
            
        #=========================================
            # ngrams   
        #=========================================
        ### ngram3 ###
        # get df: freq(wi-2, wi-1, wi)
        ngram3HitFreqDf <- getNgram3HitFreqtDf(ngram2Prefix, ngram3FreqDf)

        if((nrow(ngram3HitFreqDf) != 0) & (ngram3HitFreqDf$freq[1] > kValue_)){
                  cat(green("Observed ngram3\n"))
                  # Consider only ML without discounting to gain computing time
                  observedNgram3HitFreqDf <- getObservedNgram3ProbWithoutDisc(ngram3HitFreqDf, ngram2FreqDf, ngram2Prefix, gamma3Disc) %>%
                        mutate(featNames = str_split_fixed(featNames, "_", 3)[, 3])
                  return(observedNgram3HitFreqDf)
                  
        } else {
          # If not ngram3 hits, then it takes into account observed + unobserved with a discount rate
                  # Computing time is higher
          
          # observed ngram3
                  ngram3HitFreqDf <- getNgram3HitFreqtDf(ngram2Prefix, ngram3FreqDf)
                  ngram3DiscProbaDf <- getObservedNgram3Prob(ngram3HitFreqDf, ngram2FreqDf, ngram2Prefix, gamma3Disc)
                  ngram3DiscProbaDf
          
          # unobserved
                  #ngram2:
                  # Get unobserved ngram3 tail words
                  ngram3HitFreqDf <- getNgram3HitFreqtDf(ngram2Prefix, ngram3FreqDf)
                  unobservedNGram3TailWords <- getUnobservedNgram3TailWords(ngram3HitFreqDf, ngram1FreqDf)
                  unobservedNGram3TailWords
                  
                  # Discount probability mass ngram2
                  alphaNgram2 <- getAlphaNgram2(ngram2Prefix, ngram2FreqDf, ngram1FreqDf, gamma2Disc)
                  alphaNgram2
                  
                  # Backed off probability for ngram2
                  # Get char vect of backed off all ngram2 of the "inverted prefix type" w2_w1
                  boNgram2 <- getBoNgram2(ngram2Prefix, unobservedNGram3TailWords)
                          
                          # Get the observed ones (df with freq)
                          obsBoNgram2FreqDf <- getObsBoNgram2(ngram2Prefix, unobservedNGram3TailWords, ngram2FreqDf)
                          obsBoNgram2FreqDf
                          
                          # Get the unobserved ones (char vect)
                          unobsBoNgram2 <- getUnobsBoNgram2(ngram2Prefix, unobservedNGram3TailWords, obsBoNgram2FreqDf)
                          unobsBoNgram2
                          
                          # Get proba for observed ones
                          obsBoNgram2ProbDf <- getObsBoNgram2Prob(obsBoNgram2FreqDf, ngram1FreqDf, gamma2Disc)
                          obsBoNgram2ProbDf
                          
                          # Get proba for unobserved ones
                          unobsBoNgram2Prob <- getUnobsBoNgram2Prob(unobsBoNgram2, ngram1FreqDf, alphaNgram2)
                          unobsBoNgram2Prob
                          
                          # Link both obs and unobserved backed off ngram2 proba
                          boNgram2ProbDf <- rbind(obsBoNgram2ProbDf, unobsBoNgram2Prob)
                                  # Make sure porba are in desc order
                                  boNgram2ProbDf <- boNgram2ProbDf[order(-boNgram2ProbDf$prob), ]
                          
                          boNgram2ProbDf
       
                                  # Check ngram2 calculations
                                          # if we sum all unobserved ngram proba, we shoud get the ngram2 discount alpha(wi-1)
                                  unobserved <- boNgram2ProbDf[-1,]
                                  sum(unobserved$prob)
                
        #ngram3:
                #Discount probability mass ngram3
                alphaNgram3 <- getAlphaNgram3(ngram3HitFreqDf, ngram2Prefix, ngram2FreqDf, gamma3Disc)   
                alphaNgram3
                
                # Get proba for observed ones
                unobsBoNgram3ProbDf <- getUnobsBoNgram3Prob(ngram2Prefix, boNgram2ProbDf, gamma3Disc, alphaNgram3)
                unobsBoNgram3ProbDf
                          
                cat(green("Unobserved ngram3\n"))
                boNgram3ProbDf <- rbind(unobsBoNgram3ProbDf, ngram3DiscProbaDf) %>%
                        arrange(desc(prob)) %>%
                        mutate(featNames = str_split_fixed(featNames, "_", 3)[, 3])  %>% 
                        slice_head(n = 10)
                
                        # Check
                        sum(boNgram3ProbDf$prob)
                        
                        # If both prefix words unknown in the whole vocabulary
                        if (is.na(sum(boNgram3ProbDf$prob))) { # this means that both words of the ngram2Prefix are unknown in the whole vocabulary, then simply need to take the highest ngram1 proba 
                                ngram1ProbDf <- getNgram1Prob(ngram1FreqDf)%>% 
                                slice_head(n = 10)
                                return(ngram1ProbDf)
                        } else {
                                return(boNgram3ProbDf)  
                        }
        } # end else
} # end fun

    
        
# getBestKBODf("I want to buy a") 
