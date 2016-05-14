install.packages("twitteR")
install.packages("ROAuth")
library("twitteR")
library("ROAuth")
library(RCurl)
require(RCurl)
library(httr)


# Download "cacert.pem" file
download.file(url="http://curl.haxx.se/ca/cacert.pem",destfile="cacert.pem")

#create an object "cred" that will save the authenticated object that we can use for later sessions
cred <- OAuthFactory$new(consumerKey='6G5bqTU8LidlqUVYT3vYzIK58',
                         consumerSecret='5v9xCKnXU6R8y9Jj2cRVBeHlye6QLeXNJOvRzJQLFjsP4supya',
                         requestURL='https://api.twitter.com/oauth/request_token',
                         accessURL='https://api.twitter.com/oauth/access_token',
                         authURL='https://api.twitter.com/oauth/authorize')

# Executing the next step generates an output --> To enable the connection, please direct your web browser to: <hyperlink> . Note:  You only need to do this part once
cred$handshake(cainfo="cacert.pem")
4625883


#save for later use for Windows
save(cred, file="twitter authentication.Rdata")
load("twitter authentication.Rdata")
registerTwitterOAuth(cred)
##############

library(streamR)
filterStream("tweets.json", track = c("Obama", "Biden"), timeout = 120,oauth = cred)

#############  
reqURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "https://api.twitter.com/oauth/access_token"
authURL <- "https://api.twitter.com/oauth/authorize"
consumerKey <- "6G5bqTU8LidlqUVYT3vYzIK58"
consumerSecret <- "5v9xCKnXU6R8y9Jj2cRVBeHlye6QLeXNJOvRzJQLFjsP4supya"
twitCred <- OAuthFactory$new(consumerKey = consumerKey,consumerSecret = consumerSecret,requestURL = reqURL,accessURL = accessURL,authURL = authURL)

api_key <- "6G5bqTU8LidlqUVYT3vYzIK58"
api_secret <- "5v9xCKnXU6R8y9Jj2cRVBeHlye6QLeXNJOvRzJQLFjsP4supya"
access_token <- "143709642-rZmpKLCgYAUyPgih4Xqx2yzOZqlKSlhX60U1Espb"
access_token_secret <- "khqRJuCMjmfw8FnxkEez4RhoJ3jEKUIRwEmjgjeiSQdAC"
setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)
1
2
tinstall.packages(c("devtools", "rjson", "bit64", "httr"))

#RESTART R session!

library(devtools)
install_github("geoffjentry/twitteR")
library(twitteR)
