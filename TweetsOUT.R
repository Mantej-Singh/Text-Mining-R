install.packages("twitteR", "RCurl", "RJSONIO", "stringr")
library(twitteR)
library(RCurl)
library(RJSONIO)
library(stringr)
library("ROAuth")
setwd("E://NJIT College//SEM 1//IHLP//Mantej Singh//Mini Proj//Text Mining- R")

api_key <- "6G5bqTU8LidlqUVYT3vYzIK58"
api_secret <- "5v9xCKnXU6R8y9Jj2cRVBeHlye6QLeXNJOvRzJQLFjsP4supya"
access_token <- "143709642-rZmpKLCgYAUyPgih4Xqx2yzOZqlKSlhX60U1Espb"
access_token_secret <- "khqRJuCMjmfw8FnxkEez4RhoJ3jEKUIRwEmjgjeiSQdAC"
setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)
1
#Diff types of searches 
#tweets <- searchTwitter("Obamacare OR ACA OR 'Affordable Care Act' OR #ACA", n=100, lang="en", since="2014-08-20")

a=searchTwitter("#NJIT", n=100,since = "2012-08-20")
write.csv(twListToDF(a), file="TweetsOUTNJIT.csv")

tweets_df = twListToDF(a) #Convert to Data Frame
install.packages(c("tm", "wordcloud"))
library(tm) 
library(wordcloud)   
b=Corpus(VectorSource(tweets_df$text), readerControl = list(language = "eng"))
b<- tm_map(b, tolower) #Changes case to lower case 
b<- tm_map(b, stripWhitespace) #Strips White Space 
b <- tm_map(b, removePunctuation) #Removes Punctuation
inspect(b) 
tdm <- TermDocumentMatrix(b) 
m1 <- as.matrix(tdm) 
v1<- sort(rowSums(m1),decreasing=TRUE) 
d1<- data.frame(word = names(v1),freq=v1) 
wordcloud(d1$word,d1$freq)