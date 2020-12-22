
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
