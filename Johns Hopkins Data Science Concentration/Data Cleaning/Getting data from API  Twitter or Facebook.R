## Getting data from API: Twitter or Facebook 

# Accessing Twitter from R
##"twitter" is the name of the application which is up to you. Could
##be anything you want. Doesn't have to match anything on the website.
##Keys and tokens should be on the webpage you created on the developer
##website.
##sign_oauth1.0 will authorize when GET function called
##api.twitter.com - api url; 1.1 version of api; rest of url is what
##info you want from the api.
##He got GET complete url from documentation under REST API 
##on dev.twiiter.com. On the page, url was under Resource URL.
library(httr)
myapp = oauth_app("twitter",
                  key="yourConsumeKeyHere", secret="yourConsumerSecretHere")
sig = sign_oauth1.0(myapp,
                    token="yourTokenHere",
                    token_secret="yourTokenSecretHere")
homeTL = GET("https://api.twitter.com/1.1/statuses/home_timeline.json",sig)

# Converting the json object
##content extracts the data; will recognize its in json format and
##return a structured R object.
##This R object is hard to read so toJSON converts back to JSON
##jsonlite::fromJSON converts it to a dataframe. I think fromJSON is
##is the argument portion of jsonlite. Weird syntax.
##In this instance, each row will correspond to a tweet in his timeline.
##subsetted first row, first four columns
library(jsonlite)
json1 = content(homeTL)
json2 = jsonlite::fromJSON(toJSON(json1))
json2[1,1:4]
# check HTTR demo component on Github