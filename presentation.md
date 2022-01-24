Spotify Music Sentiment Analyzer
======================================================== 
author: Syafiq Aiman, Nurhan Nufa'il, Muhammad Tareq Adam, Masyitah Humaira
date: 24 January 2022
autosize: true

Project introduction
========================================================
<style>

body {
  background-color: #EEEEEE; }

.reveal{
  font-size: 50px;
}

/* slide titles */
.reveal h3 { 
  font-size: 90px;
  font-weight: bold;
  color: #116530;
}

/* heading for slides with two hashes ## */
.reveal .slides section .slideContent h2 {
   font-size: 60px;
   color: black;
}

/* ordered and unordered list styles */
.reveal ul, 
.reveal ol {
    font-size: 50px;
    color: black;
    list-style-type: square;
}

</style>


## This presentation reports the Shiny Application and Reproducible Pitch Group Project of the __Data Science Course WIA1007__

## The goal of this project is to create a shiny apps that relates to Data Science.

## The Shiny app is built entirely in R, and the analyzation are made based on the user's activity from the Spotify.


- The Spotify API is used to retrieve data about artists, albums, and tracks based on the user's activity.
- The user needs the actual Spotify API to be able to see their data (the client id and client secret)

Description Algorithm
========================================================

- Sentiment for specific artist
- User's overall sentiment


App Description
========================================================
left: 40%
</style>

- The app starts with an empty input
- To start this app, user are required to input the Client ID and Client Secret by following the instructions given in the "Instruction" tab.
- The app consist of two tab  :
  - Instruction
  - by the ListenRs

***

**Instruction** : 

this panel will list out the steps and link needed for the users to get the Client ID and Client Secret that is required to start the program.

![Instruction](Instruction.png)

========================================================
  
**by the ListenRs** :

- The program will display:
  - Sentiment for specific artist
  - User's overall sentiment


*Sentiment for specific artist* :

This panel will allow the user to see the sentiments of their top 25 artists' albums. The sentiments are based on the audio features set from Spotify :

Danceability, Energy, Loudness, Speechiness, Acousticness, Liveness, Positivity, Tempo


This panel also shows the song with the highest score based on the features chosen by the user.

![Sentiment for Specific Artist](Instruction.png)
  
***

*User's overall sentiment*:

This panel will allow the user to see their music personality according to the user's top 10 most popular artist. The user's music personality will be determined by comparing the score of specific features :

- Positivity vs Energy
- Speechness vs Danceability

![User's overall sentiment](Instruction.png)

Experience using this app
========================================================


Spotify Music Sentiment Analyzer Link : http://127.0.0.1:3342

Thank you for your time.