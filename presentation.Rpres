Spotify Music Sentiment Analyzer
======================================================== 
WIA1007 Intro to Data Science ( Group P )
#### The ListenR’s

27 January 2022

Group Members: 
- Muhammad Shafiq Aiman Bin Nu Mahamad @ Marzuki (U2000428) 
- Nurhan Nufa'il Bin Azman (U2000483)
- Muhammad Tareq Adam Bin Ellias (U2001228)
- Masyitah  Binti Mohd Hafidz (U2000518)

***

![Rstudio](RStudio.png)

![Spotify](Spotify.png)

<style>

body {
  background-color: #EFFFFB;
  max-height: none}

.reveal{
  font-size: 20px;
  line-height: 25px;
}

.reveal h4 { 
  font-size: 80px;
  font-weight: bold;
  color: #116530;
}

.reveal h3 { 
  font-size: 60px;
  font-weight: bold;
  color: #116530;
}

.reveal .slides section .slideContent h2 {
   font-size: 40px;
   line-height: 45px;
   color: black;
}

.reveal .slides section .slideContent h1 {
   font-size: 30px;
   line-height: 35px;
   color: black;
}

.reveal ul, 
.reveal ol {
    font-size: 25px;
    line-height: 30px;
    color: black;
    list-style-type: square;
}

.reveal section img {
   width: 45%;
}


</style>

Project Introduction
========================================================
# This presentation reports the Shiny Application and Reproducible Pitch Group Project of the __Intro to Data Science Course WIA1007__

# The Shiny app is built entirely in R, and the analyzation are made based on the user's activity from the Spotify.

# **Aim of the project** :
# Create a platform for the user to :
- Analyze their music sentiment
- Identify their top artist based on popularity
- Analyze the sentiment of each artist

***

# **Questions** :

- What does a person's music taste have in correlation with their personality?
- Which sentiment is most presented among music artists?

# **Project's Stakeholder** :

+ Music Lovers
+ Songwriter
+ Music Producer

Dataset Description
========================================================
</style>
- The Spotify API is used to retrieve data.
- Data is processed by extracting only the relevant features.
- We visualize our data using multiple charts (some of them is interactive).
- We do not use any specific dataset, we extract user-specific data from their API client and use that data. In other words, our dataset will be different for each user that uses our app.
- The data that we extract:
	- users' top artists, tracks, albums
	- the top artists sentiment type and their scores.
	( Positivity/valence, Energy, Loudness, Speechiness, Danceability, Acousticness, Liveness, Tempo )


# **Data Analysis**

# We selected 10 most popular artist from all the artist based on their Spotify IDs to analyze the user's music sentiment.

App Description
========================================================
left: 40%
</style>

The app starts with an empty input. To start this app, users are required to input the Client ID and Client Secret by following the instructions given in the "Instruction" tab.
The app consist of two tab  : __Instruction__ & __Sentiment Analysis__

**Instruction** :  This panel will list out the steps and the link needed for the users to get the Client ID and Client Secret that are required to start the program. It also lists out descriptions for each sentiment type.
  
**Sentiment Analysis** : This panel will display two parts : *Sentiment for Specific Artist* & *User's overall sentiment*

*Sentiment for specific artist* :

This panel will allow the user to see the sentiments of their top 25 artists' albums. The sentiments are based on the audio features set by Spotify. This panel also shows the song with the highest score based on the features chosen by the user.

***

*User's overall sentiment*:

This panel will allow the user to see their music personality according to the user's top 10 most popular artists. The user's music personality will be determined by comparing the score of specific features :
- Positivity vs Energy

![Instruction](Instruction.png)
![Sentiment for Specific Artist](specific artist.jpeg)
![User's overall sentiment](Users Overall Sentiment.jpeg)
![overall sentiment](Users Overall Sentiment 2.jpeg)

Experience using this app
========================================================
# The app fully utilise and analyses the users spotify history accurately and was able to predict the type of music the user likes.
# Since the Spotify package for R (spotifyr) is not capable of user logins, thus the user needs to use the actual Spotify API to be able to see their data (the client id and client secret). 
# The overall experience of completing this data science project was fun and challenging. However, during the making of this app, we faced some problems, which we were able to solve in some way. Overall, we planned the program and divided the tasks for the project quite well, so we managed to finish it on time.

Here is the link to our project:
- [Github Link](https://github.com/shafiqps/Spotify-Dashboard.git)
- [Spotify Music Sentiment Analyzer Link](http://127.0.0.1:3633)

## Thank you for your time.

