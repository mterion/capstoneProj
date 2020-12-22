
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
fcmat_news <- fcm(dfmat_news)
dim(fcmat_news)
feat <- names(topfeatures(fcmat_news, 50))
fcmat_news_select <- fcm_select(fcmat_news, pattern = feat, selection = "keep")
dim(fcmat_news_select)
size <- log(colSums(dfm_select(dfmat_news, feat, selection = "keep")))
set.seed(144)
textplot_network(fcmat_news_select, min_freq = 0.8, vertex_size = size / max(size) * 3)
##
install.packages("texplot_network")

set.seed(100)
toks <- data_char_ukimmig2010 %>%
    tokens(remove_punct = TRUE) %>%
    tokens_tolower() %>%
    tokens_remove(pattern = stopwords("english"), padding = FALSE)
fcmat <- fcm(toks, context = "window", tri = FALSE)
feat <- names(topfeatures(fcmat, 30))
fcm_select(fcmat, pattern = feat) %>%
    textplot_network(min_freq = 0.5)

##
# Create Dfm
        toksCNews <- readRDS("./data/processedData/toksCNews.RDS")
        toksCNewsDfm <- dfm(toksCNews)
# Trim
        toksCNewsDfm <- dfm_trim(toksCNewsDfm, min_termfreq = 100)
                head(toksCNewsDfm)
                topfeatures(toksCNewsDfm)

        toksCNewsFcm <- fcm(toksCNewsDfm)
                dim(toksCNewsFcm)
                
# Select 50 top features
        topFeatures <- names(topfeatures(toksCNewsFcm, 50))
        
# Filter them from the Fcm
        tokCNewsFcmFilt <- fcm_select(toksCNewsFcm, pattern = topFeatures, selection = "keep")
                dim(tokCNewsFcmFilt)        
    
# Visualize
        size <- log(colSums(dfm_select(toksCNewsDfm, topFeatures, selection = "keep")))

        set.seed(144)
        textplot_network(tokCNewsFcmFilt, min_freq = 0.8, vertex_size = size / max(size) * 3)
        