       #Quiz:       
        # Question 4: In the en_US twitter data set,Divide the number of lines where the word "love" (all lowercase) occurs by the number of lines the word "hate" (all lowercase) occurs, about what do you get?
                
                # sum(as.numeric(grep("love", twitterLines)))/sum(as.numeric(grep("hate", twitterLines)))
        
        # Q5: The one tweet in the en_US twitter data set that matches the word “biostats” says what?
        
                # grep("biostats", twitterLines, value = TRUE)
        
        # Q6: Question 6: How many tweets have the exact characters "A computer once beat me at chess, but it was no match for me at kickboxing". (I.e. the line matches those characters exactly.)
                
                # length(grep("A computer once beat me at chess, but it was no match for me at kickboxing", twitterLines))

 
# 1. **How do you evaluate how many of the words come from foreign languages?** 
# This can be done by using a foreign language dictionary and filtering out the words that belongs to it. It goes in the same direction than the work done with the removal of profanity words on the base of a special dictionary.
# 
# 2. **Can you think of a way to increase the coverage -- identifying words that may not be in the corpora or using a smaller number of words in the dictionary to cover the same number of phrases?**
#      i) Using a smaller number of words in the dictionary to cover the same number of phrase can simply be done by removing the dictionary low-frequency words. It can also be done by reducing the number of low frequency words by stemming.
#      i) Increasing the coverage can be done by comparing the corpus dictionary with a full language dictionary, taking the delta and thinking about why this words were not in our original corpus. This will give indication at whether we should include other types of data sources (blogs of different types, etc.) in our actual corpus.
#      
#      
# 3. **How can you efficiently store an n-gram model (think Markov Chains)?** The main idea is to be able to produce the probability of a word w given some history h. The intuition with n-gram model is to approximate the probability of a word not given its entire history but to approximate its history by just the last few words. It sticks with the Markov model assumption.The efficient storage of a markov chain model is that it stores the probability in a sequence of events based on the state attained in the previous event. Thus the clear advantage is to promote efficiency in the storage of the model. It suits perfectly for sequence processing as done in natural language processing.
#      
# 4. **How can you use the knowledge about word frequencies to make your model smaller and more efficient?** By concentrating on the most frequent words first for model prediction, leaving outliers aside.
# 
# 5. **How many parameters do you need (i.e. how big is n in your n-gram model)?** Bigram will be the start, altough that in the field it's more common to use trigram models that condition on the previous two words or 4-grams that condition on previous three words. As we increase the value of N, the accuracy of the n-gram model increases because the choice of the next word becomes increasingly constrained. 
# 
# 6. **Can you think of a simple way to smooth the probabilities (think about giving all n-grams a non-zero probability even if they aren't observed in the data) ?** The mains problem are the following:
#     i) A small number of words occur very frequently and that a large number are seen only once. They are said to follow a Zipfian distribution.
#     i)  Zero probabilities on one bigram will cause a zero probability on the entire sequence
#     i) The likelihood of unseen n-grams need to be estimated as well
# 
# Smoothing will allow to flatten spiky distribution to get a better generalization. The main different forms of smoothing are :
#     i)	**Laplace smoothing**: Add 1 to every word count
#     i)	**Good-Turing Discounting** : Re-estimate amount of probability mass for zero or low count ngrams by looking at ngram with higher counts
#     i)	**Backoff Methods (Kazt)** : Compute unigram, bigram and trigram probability. Start with trigram, if not available back of to bigram and finally unigram if necessary. This will be the type of model developed in this work.
# 
# 
# 7. **How do you evaluate whether your model is any good?** By developping the model on a training data set (75% of original data) and testing it on a test data set (25% of original data)
# 
# 8. **How can you use backoff models to estimate the probability of unobserved n-grams?** The Katz back-off model redistributes the probability mass from observed bigrams or trigram to those which are unobserved.
