#=============================
## Ngram3
#=============================

# get df: freq(wi-2, wi-1, wi)
        getNgram3HitFreqtDf <- function(ngram2Prefix_, ngram3FreqDf_){
                # create empty Df with col featNames and freq
                hitIndexDf <- data.frame(featNames = character(), freq = integer())
                
                # make regex to grab the first words (biPrefix) in the trigrams df
                regex <- sprintf("%s%s%s", "^", ngram2Prefix_, "_")
                
                # vect with indices of the hit
                ngram3_indices <- grep(regex, ngram3FreqDf_$featNames)
                
                if(length(ngram3_indices) > 0) {
                    hitIndexDf <- ngram3FreqDf_[ngram3_indices, ]
                }
                return(hitIndexDf)
        }
    
# get value: freq(wi-2, wi-1) in ngram2
        getNgram2HitFreq <- function(ngram2Prefix_, ngram2FreqDf_){
                hitPrefFrequency <- filter(ngram2FreqDf_, featNames==ngram2Prefix_)$freq[1]
                return(hitPrefFrequency)
        }
        
# get df sbo freq scores for ngram3: freq(wi-2, wi-1, wi) / freq(wi-2, wi-1)
        getNGram3FreqScoresDf <- function(ngram2HitFreq_, ngram3HitFreqDf_){
                # call and modify ngram3hitFreqDf to add a score col
                getNgram3HitScoretDf <- ngram3HitFreqDf_ %>%
                        mutate(score = freq / ngram2HitFreq_)
                return(getNgram3HitScoretDf)
        }
        
# get df sbo scores for ngram3: freq(wi-2, wi-1, wi) / freq(wi-2, wi-1)
        getWiScoresDfngram3 <- function(ngram3FreqScoresDf_){
                # call and modify ngram3hitFreqDf to add a score col
                wiScoresDfngram3 <- ngram3FreqScoresDf_ %>%
                        arrange(desc(score)) %>%
                        mutate(featNames = str_split_fixed(featNames, "_", 3)[, 3]) %>%
                        select(-freq)
                return(wiScoresDfngram3)
        }
        
#=============================
## Ngram2
#=============================
# get df: freq(wi-1, wi)
        getNgram2HitFreqtDf <- function(ngram2Prefix_, ngram2FreqDf_){
                # create empty Df with col featNames and freq
                hitIndexDf <- data.frame(featNames = character(), freq = integer())
                
                # Get the first word fom the ngram2prefix
                ngram2PrefixLastWord <- str_split(ngram2Prefix_, "_")[[1]][2]
                
                # make regex to grab the first words (biPrefix) in the trigrams df
                regex <- sprintf("%s%s%s", "^", ngram2PrefixLastWord, "_")
                
                # vect with indices of the hit
                ngram2_indices <- grep(regex, ngram2FreqDf_$featNames)
                
                if(length(ngram2_indices) > 0) {
                    hitIndexDf <- ngram2FreqDf_[ngram2_indices, ]
                }
                return(hitIndexDf)
        }

# get value: freq(wi-1) in ngram1 
        getNgram1HitFreq <- function(ngram2Prefix_, ngram1FreqDf_){
                # Get the first word fom the ngram2prefix
                ngram2PrefixLastWord <- str_split(ngram2Prefix_, "_")[[1]][2]
                hitPrefFrequency <- filter(ngram1FreqDf_, featNames==ngram2PrefixLastWord)$freq[1]
                return(hitPrefFrequency)
        }
        
# get df sbo freq scores for ngram2: freq(wi-1, wi) / freq(wi-1)
        getNGram2FreqScoresDf <- function(ngram1HitFreq_, ngram2HitFreqDf_, backOffFactorAlpha_){
                # call and modify ngram3hitFreqDf to add a score col
                getNgram2HitScoretDf <- ngram2HitFreqDf_ %>%
                        mutate(score = freq / ngram1HitFreq_) %>% 
                        mutate(alphaScore = score * backOffFactorAlpha) %>%
                        arrange(desc(alphaScore))
                return(getNgram2HitScoretDf)
        }
        
# get df sbo scores for ngram2: freq(wi-1, wi) / freq(wi-1)
        getWiScoresDfngram2 <- function(ngram2FreqScoresDf_){
                # call and modify ngram3hitFreqDf to add a score col
                wiScoresDfngram2 <- ngram2FreqScoresDf_ %>%
                        arrange(desc(score)) %>%
                        mutate(featNames = str_split_fixed(featNames, "_", 2)[, 2]) %>%
                        select(-freq)
                return(wiScoresDfngram2)
        }
        
        
#=============================
## ML ngram1
#=============================
# get df: freq(wi)
        getNgram1HitFreqtDf <- function(ngram1FreqDf_, backOffFactorAlpha_){
                # create empty Df with col featNames and freq
               ngram1FreqScoresDf <-  ngram1FreqDf_ %>%
                        mutate(score = freq / sum(freq)) %>%
                        mutate(alphaScore = score * backOffFactorAlpha) %>%
                        arrange(desc(alphaScore))
                return(ngram1FreqScoresDf)
        }
    
#=============================
## Return best score
#=============================
        # wiScoresDfNgram3
        # wiScoresDfNgram2
        # 
        # getBestScoreRowNgram3Df <- function(wiScoresDf_){
        #     bestScoreRowDf <- wiScoresDf_ %>%
        #                     mutate(featNames = str_split_fixed(featNames, "_", 2)[, 2]) %>%
        #                     filter(row_number()==1)
        # return(bestScoreRowDf)
        # }
        # 
        # # get df sbo scores but just first row
        # getBestScoreRowNgram2Df <- function(wiScoresDf_){
        #     bestScoreRowDf <- wiScoresDf_ %>%
        #                     filter(row_number()==1)
        # return(bestScoreRowDf)
        # }
        
        

        
        