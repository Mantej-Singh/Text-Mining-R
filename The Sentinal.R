# required pakacges
library(twitteR)
library(Rstem)
library(sentiment)
library(qdap)
library(plyr)
library(ggplot2)
library(wordcloud)
library(RColorBrewer)
install.packages('sentiment')
 install.packages("tm.lexicon.GeneralInquirer", repos="http://datacube.wu.ac.at", type="source")
library(tm.lexicon.GeneralInquirer)
 install.packages("tm.plugin.sentiment", repos="http://R-Forge.R-project.org")
library(tm.plugin.sentiment) # posted comments on SO about this not working
library(tm)
 
 setwd("E://NJIT College//SEM 1//IHLP//Mantej Singh//Mini Proj//Text Mining- R")
 
 api_key <- "6G5bqTU8LidlqUVYT3vYzIK58"
 api_secret <- "5v9xCKnXU6R8y9Jj2cRVBeHlye6QLeXNJOvRzJQLFjsP4supya"
 access_token <- "143709642-rZmpKLCgYAUyPgih4Xqx2yzOZqlKSlhX60U1Espb"
 access_token_secret <- "khqRJuCMjmfw8FnxkEez4RhoJ3jEKUIRwEmjgjeiSQdAC"
 setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)
 1
 
 # harvest some tweets
 some_tweets = searchTwitter("starbucks", n=50, lang="en")
 
 # get the text
 some_txt = sapply(some_tweets, function(x) x$getText())
 head(some_txt)
 
 # remove retweet entities
 some_txt = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", some_txt)
 # remove at people
 some_txt = gsub("@\\w+", "", some_txt)
 # remove punctuation
 some_txt = gsub("[[:punct:]]", "", some_txt)
 # remove numbers
 some_txt = gsub("[[:digit:]]", "", some_txt)
 # remove html links
 some_txt = gsub("http\\w+", "", some_txt)
 # remove unnecessary spaces
 some_txt = gsub("[ \t]{2,}", "", some_txt)
 some_txt = gsub("^\\s+|\\s+$", "", some_txt)
 
 # define "tolower error handling" function 
 try.error = function(x)
 {
   # create missing value
   y = NA
   # tryCatch error
   try_error = tryCatch(tolower(x), error=function(e) e)
   # if not an error
   if (!inherits(try_error, "error"))
     y = tolower(x)
   # result
   return(y)
 }
 # lower case using try.error with sapply 
 some_txt = sapply(some_txt, try.error)
 
 # remove NAs in some_txt
 some_txt = some_txt[!is.na(some_txt)]
 names(some_txt) = NULL
 
 # classify emotion
 class_emo = classify_emotion(some_txt, algorithm="bayes", prior=1.0)
 # get emotion best fit
 emotion = class_emo[,7]
 # substitute NA's by "unknown"
 emotion[is.na(emotion)] = "unknown"
 
 # classify polarity
 class_pol = classify_polarity(some_txt, algorithm="bayes")
 # get polarity best fit
 polarity = class_pol[,4]
 
 # data frame with results
 sent_df = data.frame(text=some_txt, emotion=emotion,
                      polarity=polarity, stringsAsFactors=FALSE)
 
 # sort data frame
 sent_df = within(sent_df,
                  emotion <- factor(emotion, levels=names(sort(table(emotion), decreasing=TRUE))))
 
 
 # plot distribution of emotions
 ggplot(sent_df, aes(x=emotion)) +  geom_bar(aes(y=..count.., fill=emotion)) +
   scale_fill_brewer(palette="Dark2") +
   ggtitle("Sentiment Analysis of Tweets about Starbucks\n(classification by emotion") +
      theme(legend.position="right") + ylab("Number of Tweets") + xlab("Emotion Categories")
        
dev.off() 

 #####
#opts(title = "Sentiment Analysis of Tweets about Starbucks\n(classification by emotion)",