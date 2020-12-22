
        #Quiz:       
        # Question 4: In the en_US twitter data set,Divide the number of lines where the word "love" (all lowercase) occurs by the number of lines the word "hate" (all lowercase) occurs, about what do you get?
                
                # sum(as.numeric(grep("love", twitterLines)))/sum(as.numeric(grep("hate", twitterLines)))
        
        # Q5: The one tweet in the en_US twitter data set that matches the word “biostats” says what?
        
                # grep("biostats", twitterLines, value = TRUE)
        
        # Q6: Question 6: How many tweets have the exact characters "A computer once beat me at chess, but it was no match for me at kickboxing". (I.e. the line matches those characters exactly.)
                
                # length(grep("A computer once beat me at chess, but it was no match for me at kickboxing", twitterLines))

 

                     
###
corp_news <- download("data_corpus_guardian")
dfmat_news <- dfm(corp_news, remove = stopwords("en"), remove_punct = TRUE)
dfmat_news <- dfm_remove(dfmat_news, pattern = c("*-time", "updated-*", "gmt", "bst", "|"))
dfmat_news <- dfm_trim(dfmat_news, min_termfreq = 100)

topfeatures(dfmat_news)