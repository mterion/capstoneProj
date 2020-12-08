


## For spacy, I have done this
        # https://github.com/quanteda/spacyr/blob/master/README.md
        # Trial with this, it worked
        spacy_initialize()
        
        # To save time and avoid to do this every time, I have added into te RProfile file
        spacy_initialize(save_profile = TRUE)
        
        ## More languages added
        spacy_download_langmodel("de")
        spacy_download_langmodel("fr")
        spacy_download_langmodel("en")

        # Other configuration problem for linking downloaded language files with spacy solved with:
                # "https://stackoverflow.com/questions/53505068/couldn-t-link-model-to-en-core-web-md-on-a-windows-10/53516347"

        # C:\Users\cliva\miniconda3\envs\spacy_condaenv\Lib\site-packages\spacy\data
        # C:\Users\cliva\miniconda3\envs\spacy_condaenv\Lib\site-packages