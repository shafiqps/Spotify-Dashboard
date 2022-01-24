library(shiny)
library(shinythemes)
library(spotifyr)
library(tidyverse)
library(DT)
library(reshape2)
library(plotly)
library(ggridges)
library(httr)
library(remotes)
library(dplyr)
library(waffle)
library(ggplot2)
library(RColorBrewer)

## Authentification function
authenticate <- function(id, secret) {
  # authenticate the spotify client stuff
  Sys.setenv(SPOTIFY_CLIENT_ID = id)
  Sys.setenv(SPOTIFY_CLIENT_SECRET = secret)
  
  access_token <- get_spotify_access_token()
}

## favorite artists table function
fav_artists <- function() {
  as.data.frame(get_my_top_artists_or_tracks(type = 'artists', 
                                             time_range = 'long_term', 
                                             limit = 25) %>% 
                  rename(followers = followers.total) %>% 
                  select(.data$genres, .data$name, .data$popularity, .data$followers) %>% 
                  rowwise %>% 
                  mutate(genres = paste(.data$genres, collapse = ', ')) %>% 
                  ungroup
  )
}

## datatableify fav_artists
fav_artists_datatable <- function() {
  datatable(fav_artists()) %>% formatStyle(c('name', 'genres', 'popularity', 'followers'), color = 'black')
}

# audio features for top artists table function
audio_features_fav_artist <- function(artist_name) {
  get_artist_audio_features(artist = artist_name, return_closest_artist = TRUE) %>% 
    rename(positivity = valence) %>% 
    select(.data$artist_name, .data$track_name, .data$album_name, .data$danceability, .data$energy, .data$loudness, .data$speechiness, .data$acousticness, .data$liveness, .data$positivity, .data$tempo) %>% 
    distinct(.data$track_name, .keep_all= TRUE)
}

song_sentiment_data <- function(){
  as.data.frame(get_artist_audio_features(artist = artist_name, return_closest_artist = TRUE) %>% 
                  rename(positivity = valence) %>% 
                  select(.data$danceability, .data$energy, .data$loudness, .data$speechiness, .data$acousticness, .data$liveness, .data$positivity, .data$tempo) %>% 
                  distinct(.data$track_name, .keep_all= TRUE)
                )
}


## datatablify audio_features
sentiment_datatable <- function(artist_name) {
  datatable(audio_features_fav_artist(artist_name)) %>% formatStyle(c('artist_name', 'track_name', 'album_name', 'danceability', 'energy', 'loudness', 'speechiness', 'acousticness', 'liveness', 'positivity', 'tempo') ,color = 'black')
}

# ## favorite tracks table function
# fav_tracks <- function() {
#     ceiling(get_my_top_artists_or_tracks(type = 'tracks', include_meta_info = TRUE)[['total']] / 50) %>%
#         seq() %>%
#         map(function(x) {
#             get_my_top_artists_or_tracks(type = 'tracks', limit = 50, offset = (x - 1) * 50)
#         }) %>% reduce(rbind)
# }

## favorite artists join from previous function
# fav_tracks_artists <- function(prev) {
#     temp <-
#     prev %>%
#         select(artists) %>%
#         reduce(rbind) %>%
#         reduce(rbind) %>%
#         select(name)
#     
#     temp <-
#     temp %>%
#         select(name, album.name, popularity)
#     
#     prev <- temp %>%
#         full_join(prev, by = 'id') # %>%
#        # count(id, sort = TRUE) %>%
#        # unique() %>%
#        # select(-id) %>%
#        # top_n(20, n)
#     
#     prev <- prev %>%
#         full_join(temp, by = 'id') %>%
#         select(name, name.x, album.name.y, popularity.y)
#     
#     return(prev)
# }



Sys.setenv(SPOTIFY_CLIENT_ID = "a9ddd67c426941c78b7744913d619b05")
Sys.setenv(SPOTIFY_CLIENT_SECRET = "42e668de12ca4b1abd81cee80f060846")

access_token <- get_spotify_access_token()

# Define UI
shinyUI(fluidPage(theme = shinytheme("superhero"),
                  sidebarLayout(
                    sidebarPanel(
                      "",
                      h1("Spotify Music Sentiment Analyzer"),
                      tags$h3("API authentification"),
                      textInput("id", "Client ID: ", ""), # txt1 sent to the server
                      textInput("secret", "Client Secret: ", ""),    # txt2 sent to the server
                      h6("Refer to instruction tab on how to get client ID and Client secret."),
                      actionButton("btn", "See my music sentiment"),
                      textOutput("validate_message"),
                      #h1("Welcome to the Spotify User Analysis tool!"),
                      #h6("Here you can see different analyses on your own music, as well as artists you follow, and what type of music you are interested in. Here are a couple first steps:"),
                      br()
                    ),
                    mainPanel(
                      navbarPage(
                        #theme = "cerulean",  # <--- To use a theme, uncomment this
                        "by the ListenRs",
                        # Navbar 2, tabPanel
                        #tabPanel("Popularity",
                        #         mainPanel(
                        #           h4("Let's see how popular your favorite artists are on spotify"),
                        #           plotOutput(outputId = "popularity_plot_output"),
                        #           h4("We can also see how they compare to eachother, in terms of amount of followers"),
                        #           plotlyOutput(outputId = "follower_plot_output"),
                        #           br(), br(), br(), br(), br(), br(), br(), br(), 
                        #           h4("Some more insight on your top artists:"),
                        #           DT::dataTableOutput("favorite_artists_table"),
                        #           br(), br()
                        # DT::dataTableOutput("favorite_tracks_table"),
                        #         ), # mainPanel
                        
                        
                        #), # Navbar 3, tabPanel
                        tabPanel( "Sentiment Analysis",
                                  tabsetPanel(
                                    # tabset1 in Sentiment Analyzer
                                    tabPanel("User's overall sentiment",
                                             mainPanel(
                                               h4("To analyze your musical personality, we will mostly look  at the energy and positivity sentiment."),
                                               h4("These two sentiments are usually enough to come up with a general idea of your personality."),
                                               tags$style(
                                                 "p {
                                                 color: gray36;
                                                 }"
                                               ),
                                               p("Please wait while we load your result.."),
                                               plotOutput("energy_bar_output"), 
                                               plotOutput("positivity_bar_output"),
                                               plotOutput("energy_vs_positivity_plot_output"),
                                               tags$style("#energy_vs_positivity
                                               {font-size: 40px;
                                                color: lightblue;
                                                display: block;
                                                text-align: center;
                                                padding-top: 25px;
                                                padding-bottom: 10px}"),
                                               textOutput("energy_vs_positivity")
                                   #           h3("Speechiness vs Danceability"),
                                   #            plotOutput("speechiness_vs_danceability_plot_output"),
                                   #            tags$style("#speechiness_vs_danceability
                                   # {font-size: 40px;
                                   # color: Green;
                                   # display: block;
                                   # text-align: center;
                                   # padding-top: 25px;
                                   # padding-bottom: 10px}"), 
                                   #            textOutput("speechiness_vs_danceability"),
                                               
                                               
                                             ) 
                                    ),# End of "User's Overall Sentiment" tab
                                   tabPanel(
                                     "Sentiment for specific artist",
                                     # absolutePanel(
                                     #     selectInput("artist_name", "Choose one of your top artists: ", fav_artists()$name)
                                     # ), # sidebarPanel
                                     mainPanel(
                                       #("artist_name", "Choose one of your top artists: ", fav_artists()$name),
                                       #selectInput("sentiment_type", "Choose one sentiment type: ", c('Danceability', 'Energy', 'Loudness', 'Speechiness', 'Acousticness', 'Liveness', 'Positivity', 'Tempo')),
                                       
                                         selectInput("artist_name", "Choose one of your top artists: ", fav_artists()$name),
                                         selectInput("sentiment_type", "Choose one sentiment type: ", c('danceability', 'energy', 'loudness', 'speechiness', 'acousticness', 'liveness', 'valence', 'tempo')),
                                       
                                         h4("Who is the artist you are curious about? Let's see their craft work and the sentiment they invoke."),
                                         tags$style("#sentiment_text
                                        {font-size: 30px;
                                        color: white;
                                        display: block;
                                        text-align: center;
                                        padding-bottom: 10px}"),
                                         textOutput("sentiment_text"),
                                         plotOutput(outputId = "sentiment_plot_output"),
                                         br(), br(),
                                         h6("The highest scoring song for this category is:"),
                                         tags$style("#most_sentiment
                                        {font-size: 20px;
                                        color: cornflowerblue;
                                        display: block;
                                        text-align: left;
                                        padding-bottom: 10px}"),
                                         textOutput("most_sentiment"),
                                         br(), br(),
                                         h6("The lowest scoring song for this category is:"),
                                         tags$style("#least_sentiment
                                        {font-size: 20px;
                                        color: cornflowerblue;
                                        display: block;
                                        text-align: left;
                                        padding-bottom: 10px}"),
                                         textOutput("least_sentiment"),
                                         
                                         
                                         # h3("Positivity (Valence)"),
                                         # plotOutput(outputId = "valence_plot_output"),
                                         # h5("The most positive song by this artist is:"),
                                         # textOutput("most_positive"),
                                         # h5("The least positive song by this artist is:"),
                                         # textOutput("least_positive"),
                                         # DT::dataTableOutput("sentiment_table"),
                                         
                                         br(), br()
                                         
                                         
                                       
                                     )
                                   ) # End of "Sentiment for specific artist" tab
                                  
                                  )
                        ),  # "Sentiment Analaysis" main navbar tab
                        tabPanel(
                          "Instruction",
                          mainPanel(
                            h3("1) Log in to https://developer.spotify.com/dashboard/ with your Spotify"),
                            h3("2) Click on Dashboard tab, and click \"Create an app\""),
                            h3("3) After done creating an app, locate the ID and Secret"),
                            tags$head(tags$style('h5 {color:teal;}')),
                            h5("*Spotify might take a while to authenticate your ID"),
                            # h3("Step 4: When prompted with the message are you ..., make sure to click NOT YOU and login yourself. Now you're good to go! "),
                            # verbatimTextOutput("txtout"), # generated from the server
                            h4("Positivity - describes the musical positiveness conveyed by a track."),
                            br(),
                            h4("Energy - represents a perceptual measure of intensity and activity."),
                            br(),
                            h4("Danceability - measured using a mixture of song features such as beat strength, tempo stability, and overall tempo."),
                            br(),
                            h4("Loudness - related to sound pressure level (SPL), frequency content and duration of a sound."),
                            br(),
                            h4("Speechiness - detects the presence of spoken words in a track"),
                            br(),
                            h4("Acousticness - A confidence measure from 0.0 to 1.0 of whether the track is acoustic."),
                            br(),
                            h4("Liveness - Detects the presence of an audience in the recording. Higher liveness values represent an increased probability that the track was performed live."),
                            br(),
                            h4("Tempo - The overall estimated tempo of a track in beats per minute (BPM).")
                          )
                        )
                      ) # navbar page
                    )
                  )
                  )
)
