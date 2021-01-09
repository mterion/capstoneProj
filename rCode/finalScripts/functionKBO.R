# 1.1   ngram3 hit freq df
#=====
        # Fun returns:
            # df with 2 col (featNames, freq)
                # contain ngram3 values starting with ngram2Prefix
                        # if no trigrams found with ngram2Prefix -> return empty Df
                
            getNgram3HitFreqtDf <- function(ngram2Prefix, ngram3FreqDf){
                     # create empty Df with col featNames and freq
                    hitIndexDf <- data.frame(featNames = character(), freq = integer())
                    
                    # make regex to grab the first words (biPrefix) in the trigrams df
                    regex <- sprintf("%s%s%s", "^", ngram2Prefix, "_")
                    
                    # vect with indices of the hit
                    ngram3_indices <- grep(regex, ngram3FreqDf$featNames)
                    
                        if(length(ngram3_indices) > 0) {
                            hitIndexDf <- ngram3FreqDf[ngram3_indices, ] %>%
                                    arrange(desc(freq))
                        }
                return(hitIndexDf)
            }
            
# 1.2   Discount probability mass
#=====
        # Fun returns:
                # df with 3 cols (featNames, freq, proba)
                        # proba = q_bo(w_i|w_i_-2, w_i_-1)
                # contains trigrams starting with ngram2Prefix
                        # if no ngram3 found with ngram2Prefix -> NULL returned
        
        # Explanation:
            # bigram proba mass:
                # sum of all words in set which terminate with wi-1 -> c(wi-1, wi) / c(wi-1)
            # trigram proba mass:
                # sum of all words in set which terminate with (wi-2, wi-1) -> c(wi-2, wi-1, wi) / c(wi-2, wi-1)
            # gama -> here given 0.5, but in reality would be obtained by cross-validation
                # amount of discount taken from trigrams counts or bigram counts
                    # new discount taken from bigram counts
                        # c(wi-1, w) - gamma
            
                    # new discount taken from trigram counts
                        # c(wi-2, wi-1, w) - gamma
            # Proba
                # bigrams
                    # new discount taken from bigram count / c(wi-1)
                # trigrams
                    # new discount trigram from trigram count / c(wi-2, wi-1)

# ML version without discount (to gain computing time)
        getObservedNgram3ProbWithoutDisc <- function(ngram3HitFreqDf_, ngram2FreqDf_, ngram2Prefix_, gamma3Disc_) {
                if(nrow(ngram3HitFreqDf_) < 1)
                    return(NULL)

                hitPrefFrequency <- filter(ngram2FreqDf_, featNames==ngram2Prefix_)$freq[1] # Extract only the frequency from the 1st row as safety measure
                observedNgram3ProbDf <- mutate(ngram3HitFreqDf_, freq=((freq) / hitPrefFrequency))
                colnames(observedNgram3ProbDf) <- c("featNames", "prob")
                return(observedNgram3ProbDf)
        }            

#=========================================
# Proba of words completing unobserved trigrams
#=========================================

# Return a char vect of n1gram words not observed as last word in n3grams hit
        # Select the last word of the trigram hit
        # Get all n1grams words not corresponding to it

# ML Version with discount
getObservedNgram3Prob <- function(ngram3HitFreqDf_, ngram2FreqDf_, ngram2Prefix_, gamma3Disc_) {
        if(nrow(ngram3HitFreqDf_) < 1)
            return(NULL)

        hitPrefFrequency <- filter(ngram2FreqDf_, featNames==ngram2Prefix_)$freq[1] # Extract only the frequency from the 1st row as safety measure
        observedNgram3ProbDf <- mutate(ngram3HitFreqDf_, freq=((freq - gamma3Disc_) / hitPrefFrequency))
        colnames(observedNgram3ProbDf) <- c("featNames", "prob")
        return(observedNgram3ProbDf)
}

# 2.1 Get unobserved ngram3 words
#=====      
        getUnobservedNgram3TailWords <- function(ngram3HitFreqDf_, ngram1FreqDf_){
                # get the last word in trigrams hit
                lastWordTrigramHit <- str_split_fixed(ngram3HitFreqDf_$featNames, "_", 3)[, 3]
                
                # get all other words not hit in ngram1
                unobserved_lastWordTrigramHit <- ngram1FreqDf_[!(ngram1FreqDf_$featNames %in% lastWordTrigramHit), ]$featNames
                return(unobserved_lastWordTrigramHit)
        }
        
# 2.2. Discount probability mass ngram2
#=====  
        # Amount of proba mass redistributed to UNOBSERVED ngrams2
                # If no ngrams2 starting with ngram1 exist = 0 returned
        
        ##
        # ngram2Prefix_ <- ngram2Prefix
        # ngram2FreqDf_ <- ngram2FreqDf
        # ngram1FreqDf_ <- ngram1FreqDf 
        # gamma2Disc_ <- gamma2Disc
        ##
        
        getAlphaNgram2 <- function(ngram2Prefix_, ngram2FreqDf_, ngram1FreqDf_, gamma2Disc_) {
            
                # regex made to extract the ngram2PrefixLastWord
                ngram2PrefixLastWord <- str_split(ngram2Prefix_, "_")[[1]][2]
                
                # get its ngram1 frequency
                freqNgram2PrefixLastWord <- ngram1FreqDf_[ngram1FreqDf_$featNames == ngram2PrefixLastWord, ][2]
                
                # regex to later extract all ngram2 starting with the ngram2PrefixLastWord
                regex <- sprintf("%s%s%s", "^", ngram2PrefixLastWord, "_")
                
                # extract the rows from all ngram2 starting with the ngram2PrefixLastWord (ex: "the_book", "the_house")
                ngram2StartingWithN2PrefixLastWord <- ngram2FreqDf_[grep(regex, ngram2FreqDf_$featNames),]
                
                if(nrow(freqNgram2PrefixLastWord) < 1) return(0)
                alphaNgram2 <- 1 - (sum(ngram2StartingWithN2PrefixLastWord$freq - gamma2Disc_) / freqNgram2PrefixLastWord$freq)
                
                return(alphaNgram2)
        }

# 2.3. Backed off probability for ngram2
#=====
        # Get the name vector of backed off ngram2 of the "inverted type" w2_w1
        getBoNgram2 <- function(ngram2Prefix_, unobservedNGram3TailWords_) {
                # regex made to extract the ngram2PrefixLastWord
                ngram2PrefixLastWord <- str_split(ngram2Prefix_, "_")[[1]][2]
                
                boNgram2 <- paste(ngram2PrefixLastWord, unobservedNGram3TailWords_, sep = "_")
                return(boNgram2)
        }
        
        # Get observed backed off ngram2 freq       
        getObsBoNgram2 <- function(ngram2Prefix_, unobservedNGram3TailWords_, ngram2FreqDf_) {
                boNgram2 <- getBoNgram2(ngram2Prefix_, unobservedNGram3TailWords_)
                observedBoNgram2 <- ngram2FreqDf_[ngram2FreqDf_$featNames %in% boNgram2, ]
                return(observedBoNgram2)
        }
        
        # Get a char vector of backed-off ngram2 which are unobserved
        getUnobsBoNgram2 <- function(ngram2Prefix_, unobservedNGram3TailWords_, obsBoNgram2FreqDf_) {
                boNgram2 <- getBoNgram2(ngram2Prefix_, unobservedNGram3TailWords_)
                unobservedNgram2 <- boNgram2[!(boNgram2 %in% obsBoNgram2FreqDf_$featNames)]
                return(unobservedNgram2)
        }

        # Get observed backed off ngram2 proba
        getObsBoNgram2Prob <- function(obsBoNgram2FreqDf_, ngram1FreqDf_, gamma2Disc_) {
                firstWordObsBoNgram2 <- str_split_fixed(obsBoNgram2FreqDf_$featNames, "_", 2)[, 1]
                firstWordFreqDf <- ngram1FreqDf_[ngram1FreqDf_$featNames %in% firstWordObsBoNgram2, ]
                obsNgram2Prob <- (obsBoNgram2FreqDf_$freq - gamma2Disc_) / firstWordFreqDf$freq
                obsNgram2ProbDf <- data.frame(featNames=obsBoNgram2FreqDf_$featNames, prob=obsNgram2Prob)
                return(obsNgram2ProbDf)
        }

        # Get unobserved backed off ngram2 proba
        getUnobsBoNgram2Prob <- function(unobsBoNgram2_, ngram1FreqDf_, alphaNgram2_) {
                # get the unobserved ngram2 tails
                secondWordunobsBoNgram2 <- str_split_fixed(unobsBoNgram2_, "_", 2)[, 2]
                
                # get the df of the ones IN the ngram1FreqDf
                secondWordInNgram1FreqDf <- ngram1FreqDf_[ngram1FreqDf_$featNames %in% secondWordunobsBoNgram2, ]
                # freq sum of the latter 
                secondWordInNgram1FreqSum <- sum(secondWordInNgram1FreqDf$freq)
                
                # create df with prob
                unobsBoNgram2ProbDf <- data.frame(featNames=unobsBoNgram2_,
                                           prob=(alphaNgram2_ * secondWordInNgram1FreqDf$freq / secondWordInNgram1FreqSum))
                return(unobsBoNgram2ProbDf)
        }
        
# 2.4. Discount probability mass ngram3
#=====
        getAlphaNgram3 <- function(ngram3HitFreqDf_, ngram2Prefix_, ngram2FreqDf_, gamma3Disc_) {
                    ngram2PrefixFreqDf <- ngram2FreqDf_[ngram2FreqDf_$featNames %in% ngram2Prefix_, ]
                    if(nrow(ngram3HitFreqDf_) < 1) return(1)
                    alphaNgram3 <- 1 - sum((ngram3HitFreqDf_$freq - gamma3Disc_) / ngram2PrefixFreqDf$freq[1])
                    return(alphaNgram3)
                }

        # Get unobserved backed off ngram3 proba
        getUnobsBoNgram3Prob <- function(ngram2Prefix_, boNgram2ProbDf_, gamma3Disc_, alphaNgram3_) {
              # Sum all prob of backed off ngram2
              boNgram2ProbDfSum <- sum(boNgram2ProbDf_$prob)
              # Get the first word fom the ngram2prefix
              ngram2PrefixFirstWord <- str_split(ngram2Prefix_, "_")[[1]][1]
              
              # Make unobserved ngram3, on the base of merging the prefix first word with all ngram2 (observed and unobserved)
              unobsNgram3 <- paste(ngram2PrefixFirstWord, boNgram2ProbDf_$featNames, sep="_")
              # get proba (amount of discounted proba mass taken from observed ngram3 * proba of all obs-unobserved ngram2 / sum f all obs-unobserved ngram2)
              unobsNgram3Prob <- alphaNgram3_ * boNgram2ProbDf_$prob / boNgram2ProbDfSum
              
              unobsNgram3Df <- data.frame(featNames=unobsNgram3, prob=unobsNgram3Prob)
              
              # Make sure proba are in desc order
              unobsNgram3Df <- unobsNgram3Df[order(-unobsNgram3Df$prob), ]
              
              return(unobsNgram3Df)
          }

# ngram 1 PMLE in the case that both ngram2Prefix words are not found in the vocabulary
        getNgram1Prob <- function(ngram1FreqDf_) {
                                  sumFreq <- sum(ngram1FreqDf_$freq)
                                  ngram1ProbDf <- ngram1FreqDf_ %>%
                                            mutate(prob = freq / sumFreq) %>%
                                            arrange(desc(prob)) %>%
                                            select(-freq)
                                  return(ngram1ProbDf)
                          }     