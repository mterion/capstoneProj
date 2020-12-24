
domainNamesDf <- read.table("./data/rawData/domainName.txt", sep = "\n", quote = "", header = F, colClasses = "character", encoding="UTF-8")
        
        domainNamesDf <- domainNamesDf %>%
                rename(names = V1) %>%
                mutate(names = tolower(names)) %>%
                mutate(regEx = paste0("[^ ]+.", names,"$")) %>%
                filter(names %in% "com" | names %in% "org")
                        #head(domainNamesDf)
        

	[^ ]+.ing$

str <- "This is domaine.org of a string, with alea.com included into it, and osteo.fr as well"
strTok <- tokens(str)

head(strTok)

result <- tokens_remove(strTok, pattern = "[^ ]+.com$", valuetype = "regex", padding=TRUE )
head(result)

result <- tokens_remove(strTok, pattern = "[^ ]+(\\.ing)$", valuetype = "regex", padding=TRUE )
head(result)

result <- tokens_remove(strTok, pattern = domainNamesDf$regEx, valuetype = "regex", padding=TRUE )
head(result)

	[^ ]+.com$
domainNamesDf$regEx
#===========================


        
        toksCAllSW <- tokens_remove(toksCAll6, pattern = unsigWordsDf$word, valuetype = "fixed", padding=TRUE ) # fixed for exact matching
                rm(toksCAll6, unsigWords, unsigWordsDf)
                # head(toksCAllSW, 3)


                
myStr <- "The U.S. final is #in a FB account during the W/E! What's that CC." 
myStr <- tolower(myStr)

toks <- tokens(myStr, remove_punct = TRUE, remove_symbols = TRUE, remove_numbers = TRUE, remove_url = TRUE, remove_separators = TRUE)
toks

toks <- tokens(myStr, remove_punct = FALSE, remove_symbols = FALSE, remove_numbers = FALSE, remove_url = FALSE, remove_separators = FALSE)
toks <- tokens_tolower(toks)
print(toks, max_ntoken= 100)


twitterAbbr <- c(
        "CC","CX","CT","DM","HT","MT","PRT","RT","EM","EZine","FB","LI","SEO","SM","SMM","SMO","SN","SROI","UGC","YT","AB","ABT","AFAIK","AYFKMWTS",
        "B4","BFN","BGD","BH","BR","BTW","CD9","CHK","CUL8R","DAM","DD","DF","DP","DS","DYK","EM","EML","EMA","F2F","FTF","FB","FF","FFS","FM","FOTD",
        "FTW","FUBAR","FWIW","GMAFB","GTFOOH","GTS","HAGN","HAND","HOTD","HT","HTH","IC","ICYMI","IDK","IIRC","IMHO","IR","IWSN","JK","JSYK","JV","KK",
        "KYSO","LHH","LMAO","LMK","LO","LOL","MM","MIRL","MRJN","NBD","NCT","NFW","NJoy","NSFW","NTS","OH","OMFG","OOMF","ORLY","PLMK","PNP","QOTD","RE",
        "RLRT","RTFM","RTQ","SFW","SMDH","SMH","SNAFU","SO","SOB","SRS","STFU","STFW","TFTF","TFTT","TJ","TL","TLDR","TL;DR","TMB","TT","TY","TYIA","TYT",
        "TYVW","W","W/","W/E","WE","WTV","YGTR","YKWIM","YKYAT","YMMV","YOLO","YOYO","YW","ZOMG",
        "#BrandChat","#CMAD","#CMGR","#FB","#FF","#in","#LI","#LinkedInChat","#Mmchat","#Pinchat","#SMManners","#SMMeasure","#SMOchat","#SocialChat","#SocialMedia" 
        )

tA <- "\\b(CC|FB|w/e|#cmad|w/)\\b"

twitterAbbrRegEx <-tolower("\\b(
        CC|CX|CT|DM|HT|MT|PRT|RT|EM|EZine|FB|LI|SEO|SM|SMM|SMO|SN|SROI|UGC|YT|AB|ABT|AFAIK|AYFKMWTS|
        B4|BFN|BGD|BH|BR|BTW|CD9|CHK|CUL8R|DAM|DD|DF|DP|DS|DYK|EM|EML|EMA|F2F|FTF|FB|FF|FFS|FM|FOTD|
        FTW|FUBAR|FWIW|GMAFB|GTFOOH|GTS|HAGN|HAND|HOTD|HT|HTH|IC|ICYMI|IDK|IIRC|IMHO|IR|IWSN|JK|JSYK|JV|KK|
        KYSO|LHH|LMAO|LMK|LO|LOL|MM|MIRL|MRJN|NBD|NCT|NFW|NJoy|NSFW|NTS|OH|OMFG|OOMF|ORLY|PLMK|PNP|QOTD|RE|
        RLRT|RTFM|RTQ|SFW|SMDH|SMH|SNAFU|SO|SOB|SRS|STFU|STFW|TFTF|TFTT|TJ|TL|TLDR|TL;DR|TMB|TT|TY|TYIA|TYT|
        TYVW|W/E|W/|W|WE|WTV|YGTR|YKWIM|YKYAT|YMMV|YOLO|YOYO|YW|ZOMG|
        #BrandChat|#CMAD|#CMGR|#FB|#FF|#in|#LI|#LinkedInChat|#Mmchat|#Pinchat|#SMManners|#SMMeasure|#SMOchat|#SocialChat|#SocialMedia
        )\\b")



tA <- tolower(tA)

        twittAbbrDf <- data.frame(twitterAbbr, stringsAsFactors = F) %>%
                rename(abbr = twitterAbbr) %>%
                mutate(abbr = tolower(abbr))

        myStrDf <- data.frame(myStr, stringsAsFactors = F)
        myStrDf
        
        
        newStrDf <- myStrDf %>%
                mutate(myStr = stri_replace_all_regex(myStr, twitterAbbrRegEx, ''))
        newStrDf
                

        s <- "The U.S. final is #in a FB account during the W/E! What's that CC."
        s <- tolower(s)
        stri_replace_all_regex(s, "(fb|cc|w/|w/e|#cmad)", '_')

        
        

indivCharRemovalRegEx <- "[>|<|=|~|#|([0-9]+-[0-9]+)|%]" # clean characters and not word. Words, punct, emojis are done later at the level of tokenization

# Df
        myStrDF <- blogsDf %>% 
                rename(text = as.character.blogsLines.) %>%
                mutate(text = as.character(text)) %>%
                #mutate(text = stri_replace_all_regex(text, '\"', ' ')) %>% # use stringi because much faster than gsub   
                #mutate(text = stri_replace_all_regex(text, indivCharRemovalRegEx , " ")) %>% #need to replace with one space, if not will make a word out of 2 word when removing the unwanted char
                mutate(doc_id = "enBlogs") %>%
                mutate(type = "blogs")


















