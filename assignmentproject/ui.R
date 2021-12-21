#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)
library(spotifyr)
library(plotly)
library(dplyr)

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

## datatablify audio_features
sentiment_datatable <- function(artist_name) {
  datatable(audio_features_fav_artist(artist_name)) %>% formatStyle(c('artist_name', 'track_name', 'album_name', 'danceability', 'energy', 'loudness', 'speechiness', 'acousticness', 'liveness', 'positivity', 'tempo') ,color = 'black')
}
# Define UI for application that draws a histogram
shinyUI(fluidPage(theme = shinytheme("cyborg"),
                  navbarPage(
                    # theme = "cerulean",  # <--- To use a theme, uncomment this
                    "Spotify User Analysis",
                    # Havbar 1, tabPanel
                    tabPanel("Intro",
                             sidebarPanel(
                               tags$h3("Input:"),
                               textInput("id", "Client ID: ", ""), # txt1 sent to the server
                               textInput("secret", "Client Secret: ", ""),    # txt2 sent to the server
                               actionButton("btn", "validate"),
                               textOutput("validate_message")
                             ), # sidebarPanel
                             mainPanel(
                               h1("Welcome to the Spotify User Analysis tool!"),
                               h6("Here you can see different analyses on your own music, as well as artists you follow, and what type of music you are interested in. Here are a couple first steps:"),
                               br(),
                               h6("Step 1: Go to https://developer.spotify.com/dashboard/ and login with your Spotify information"),
                               h6("Step 2: Create an app with name and description temp, then find the client ID and Client Secret"),
                               h6("Step 3: Copy and paste the ID and Secret into the designated dialog boxes, and click validate."),
                               h6("Step 4: Allow spotify to authenticate your account"),
                               h6("Now you should be good to go! Click one of the tabs above and learn more about your music"),
                               # h6("Step 4: When prompted with the message are you ..., make sure to click NOT YOU and login yourself. Now you're good to go! "),
                               # verbatimTextOutput("txtout"), # generated from the server
                             ) # mainPanel
                    ), # Navbar 2, tabPanel
                    tabPanel("Popularity",
                             mainPanel(
                               h4("Let's see how popular your favorite artists are on spotify"),
                               plotOutput(outputId = "popularity_plot_output"),
                               h4("We can also see how they compare to eachother, in terms of amount of followers"),
                               plotlyOutput(outputId = "follower_plot_output"),
                               br(), br(), br(), br(), br(), br(), br(), br(), 
                               h4("Some more insight on your top artists:"),
                               DT::dataTableOutput("favorite_artists_table"),
                               br(), br()
                               # DT::dataTableOutput("favorite_tracks_table"),
                             ), # mainPanel
                    ), # Navbar 3, tabPanel
                    tabPanel("Sentiment",
                             # absolutePanel(
                             #     selectInput("artist_name", "Choose one of your top artists: ", fav_artists()$name)
                             # ), # sidebarPanel
                             mainPanel(
                               fluidRow(
                                 column(width = 6,
                                        selectInput("artist_name", "Choose one of your top artists: ", fav_artists()$name),
                                 ),
                                 column(width = 6,
                                        selectInput("sentiment_type", "Choose one sentiment type: ", c('Danceability', 'Energy', 'Loudness', 'Speechiness', 'Acousticness', 'Liveness', 'Positivity', 'Tempo'))
                                 ),
                               ),
                               # absolutePanel(
                               #     selectInput("artist_name", "Choose one of your top artists: ", fav_artists()$name),
                               #     selectInput("sentiment_type", "Choose one sentiment type: ", c('danceability', 'energy', 'loudness', 'speechiness', 'acousticness', 'liveness', 'valence', 'tempo')),
                               h4("Let's take a look at the audio features for your most popular artists"),
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
                                    color: Chartreuse;
                                    display: block;
                                    text-align: left;
                                    padding-bottom: 10px}"),
                               textOutput("most_sentiment"),
                               numericInput("most", "", 1),
                               h6("Use the dialog box above to see other songs and their scores!"),
                               
                               br(), br()
                             ), # mainPanel
                    ), # Navbar 4, tabPanel
                    tabPanel("User Stats",
                             mainPanel(
                               h4("Let's take a look at type of music you listen to overall, based on your top artists"),
                               tags$style(
                                 "p { 
                                      color: red;
                                     }"
                               ),
                               p("Be patient, this could take a minute or two"),
                               h3("Positivity vs Energy"),
                               plotOutput("energy_vs_positivity_plot_output"),
                               tags$style("#energy_vs_positivity
                                    {font-size: 40px;
                                    color: Yellow;
                                    display: block;
                                    text-align: center;
                                    padding-top: 25px;
                                    padding-bottom: 10px}"),
                               textOutput("energy_vs_positivity"),
                               h3("Speechiness vs Danceability"),
                               plotOutput("speechiness_vs_danceability_plot_output"),
                               tags$style("#speechiness_vs_danceability
                                    {font-size: 40px;
                                    color: Yellow;
                                    display: block;
                                    text-align: center;
                                    padding-top: 25px;
                                    padding-bottom: 10px}"), 
                               textOutput("speechiness_vs_danceability")
                             ) 
                    ) 
                    
                  ) # navbarPage
)
)# fluidPage


