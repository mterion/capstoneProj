# 
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
#         source("./rcode/functionSBO.R")
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
#     ngram1FreqDf <- ngramFreqDfFun(toks, 1)
#     ngram2FreqDf <- ngramFreqDfFun(toks, 2)
#     ngram3FreqDf <- ngramFreqDfFun(toks, 3)
#           ngram1FreqDf; ngram2FreqDf; ngram3FreqDf
# 





 
# #=========================================
#     # Main function    
# #=========================================
#           # userInput_ <- "I want to buy the"
#           # backOffFactorAlpha_ = 0.4

getBestSBODf <- function(userInput_, backOffFactorAlpha_ = 0.4){
  
        # Make var global for secundary to have an access to its value
        backOffFactorAlpha <<-backOffFactorAlpha_      
  
    
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
                
        if(nrow(ngram3HitFreqDf) != 0){
                                cat(green("ngram3 found\n"))
                                # get value: freq(wi-2, wi-1) in ngram2
                                ngram2HitFreq <- getNgram2HitFreq(ngram2Prefix, ngram2FreqDf)
                                
                                # get df sbo scores for ngram3: freq(wi-2, wi-1, wi) / freq(wi-2, wi-1)
                                ngram3FreqScoresDf <- getNGram3FreqScoresDf(ngram2HitFreq, ngram3HitFreqDf)
                                
                                # get df wi and the scores in descending order
                                wiScoresDfNgram3 <- getWiScoresDfngram3(ngram3FreqScoresDf) %>% 
                                slice_head(n = 10)
                        
                                cat(green("ngram3 best score df:\n"))
                                return(wiScoresDfNgram3)
        
        } else {
                # get df: freq(wi-1, wi)        
                ngram2HitFreqDf <- getNgram2HitFreqtDf(ngram2Prefix, ngram2FreqDf)
                
                if(nrow(ngram2HitFreqDf) != 0){
                        cat(green("ngram2 found\n"))
                        # get value: freq(wi-1) in ngram1
                        ngram1HitFreq <- getNgram1HitFreq(ngram2Prefix, ngram1FreqDf)
                        
                        # get df sbo scores for ngram2: freq(wi-1, wi) / freq(wi-1)
                        ngram2FreqScoresDf <- getNGram2FreqScoresDf(ngram1HitFreq, ngram2HitFreqDf, backOffFactorAlpha)
                        
                        # get df wi and the scores in descending order
                        wiScoresDfNgram2 <- getWiScoresDfngram2(ngram2FreqScoresDf)%>% 
                        slice_head(n = 10)
                        wiScoresDfNgram2
                        
                        cat(green("ngram2 best score df:\n"))
                        return(wiScoresDfNgram2)
                        
                  
                } else {
                        cat(green("ngram1 best score df:\n"))
                        ngram1HitFreqDf <- getNgram1HitFreqtDf(ngram1FreqDf, backOffFactorAlpha)%>% 
                        slice_head(n = 10)
                        return(ngram1HitFreqDf)
                }
        }
} # end get best score Df        

    
        
# getBestSBODf("I want to sell")
    
#=========================================    
#=========================================
# ngram3 <- 0
# ngram2 <- 0
# ngram1 <- 1
#     
# if(ngram3 == 1){
#         print("ngram3")
# } else {
#         if(ngram2 == 1){
#                 print("ngram2")
#         } else {
#                 if(ngram1 ==1){
#                         print("ngram1")
#                 }
#         }
# }
        
    