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

song_sentiment_datatable <- function(artist_name) {
  datatable(audio_features_fav_artist(artist_name)) %>% formatStyle(c('artist_name', 'track_name', 'album_name', 'danceability', 'energy', 'loudness', 'speechiness', 'acousticness', 'liveness', 'positivity', 'tempo') ,color = 'black')
}




shinyServer(function(input, output, session) {
  
  validate <- eventReactive(input$btn, {authenticate(input$id, input$secret)})
  output$validate_message <- renderText({ validate() })
  

  # TABPANEL #1
  popularity_data <- reactive({ fav_artists() })
  

  
  output$favorite_artists_table <- DT::renderDataTable({ fav_artists_datatable() }) %>% bindEvent(validate)
  
  # Tab "Sentiment for Specific Artist"
  sentiment_data <- reactive({ audio_features_fav_artist(as.character(input$artist_name)) })
  sentiment_datatable_reactive <- reactive({ sentiment_datatable(input$artist_name) })
  
  output$sentiment_text <- renderText({ input$sentiment_type })
  
  output$sentiment_plot_output <- renderPlot({ 
    text1 <- text
    text <- casefold(input$sentiment_type, upper = FALSE)
    data <- sentiment_data() %>% arrange(desc(.data[[text]])) ##arrange in descending order
    ggplot(data = data, aes(x = .data[[text]], y = fct_rev(album_name), fill = stat(x))) + 
      geom_density_ridges_gradient(stat = "binline", bins = 20, scale = 2) +
      scale_fill_viridis_c(name = text, option = "C") + 
      theme_ridges(font_size = 12, center_axis_labels = TRUE) + 
      scale_x_continuous(expand = c(0.01, 0)) + 
      labs(y ="Album", x = .data[[text]])
  })

  ## Tab "User's Overall Sentiment
  output$most_sentiment <- renderText({
    text <- casefold(input$sentiment_type, upper = FALSE)
    data <- sentiment_data() %>% arrange(desc(.data[[text]]))
    paste(paste(data$track_name[1], " with a score of ", sep=""), data[[text]][1], sep="")
  })
  
  output$least_sentiment <- renderText({
    text <- casefold(input$sentiment_type, upper = FALSE)
    data <- sentiment_data() %>% arrange(.data[[text]])
    paste(paste(data$track_name[1], " with a score of ", sep=""), data[[text]][1], sep="")
  })
  
  # TABPANEL #3
  ## hella important, basically a global variable lowkey
  top_artist_sentiment_data <- reactive({
    names <- rev(popularity_data()$name)
    top_artist_sentiment <- as.data.frame(audio_features_fav_artist(names[1]))
    # 2:length(names) for all artists 
    for (i in 2:10) { 
      tryCatch(
        expr = {
          top_artist_sentiment <- rbind(top_artist_sentiment, as.data.frame(audio_features_fav_artist(names[i])))
        },
        error = function(e){
          print(e)
        }
      )
      # dynamicVariableName <- paste("fav_artist", i, sep="_")
    }
    return (top_artist_sentiment)
  })
  
  output$energy_bar_output <- renderPlot({
    ggplot(data = top_artist_sentiment_data(), aes(x = artist_name, y = energy)) +
      geom_bar(width = 1, stat="identity",aes(fill = as.factor(artist_name))) + 
      scale_fill_brewer("Artists", palette = "Spectral")+
      coord_polar() + 
      theme(
        axis.title = element_blank(),
        axis.ticks = element_blank(),
        axis.text.y = element_blank()
      ) +
      labs(
        title = "Energy sentiment for your top artists"
      ) + 
      theme(plot.title = element_text(face = "bold", size = 25, hjust = 0.5))
  })
  
  output$positivity_bar_output <- renderPlot({
    ggplot(data = top_artist_sentiment_data(), aes(x = artist_name, y = positivity)) +
      geom_bar(width = 1, stat="identity",aes(fill = as.factor(artist_name))) + 
      scale_fill_brewer("Artists", palette = "Spectral")+
      coord_polar() + 
      theme(
        axis.title = element_blank(),
        axis.ticks = element_blank(),
        axis.text.y = element_blank()
      ) +
      labs(
        title = "Positivity sentiment for your top artists"
      )+ 
      theme(plot.title = element_text(face = "bold", size = 25, hjust = 0.5))
  })
  
  output$energy_vs_positivity_plot_output <- renderPlot({
    # PLOT EMOTIONAL QUADRANT TOP FOUR ARTISTS
    ggplot(data = top_artist_sentiment_data(), aes(x = positivity, y = energy, size = artist_name)) +
      geom_point(alpha=0.7,color='firebrick') + 
      scale_color_viridis_d("Artists") +
      geom_vline(xintercept = 0.5) +
      geom_hline(yintercept = 0.5) +
      scale_x_continuous(limits = c(0, 1)) +
      scale_y_continuous(limits = c(0, 1)) +
      annotate('text', 0.25 / 2, 1, label = "Aggressive") +
      annotate('text', 1.75 / 2, 1, label = "Joyful") +
      annotate('text', 1.75 / 2, 0, label = "Chill") +
      annotate('text', 0.25 / 2, 0, label = "Sad") +
      labs(title = "Energy vs Positivity" ,x= "Positivity", y= "Energy") +
      theme_light() + 
      theme(plot.title = element_text(face = "bold", size = 25, hjust = 0.5)) +
      theme(legend.position = "none")
  })
  
  output$energy_vs_positivity <- renderText({
    temp1 <- top_artist_sentiment_data()
    temp <- cbind(temp1$energy, temp1$positivity) 
    if(mean(temp[,1], na.rm = TRUE) < 0.500 & mean(temp[,2], na.rm = TRUE) < 0.500) {
      "You are an emotional and sensitive person. Music helps you sort your feelings."
    } else if (mean(temp[,1], na.rm = TRUE) < 0.500 & mean(temp[,2], na.rm = TRUE) > 0.500) {
      "You are an easy-going person, or at least music helps you relax and de-stress."
    } else if (mean(temp[,1], na.rm = TRUE) > 0.500 & mean(temp[,2], na.rm = TRUE) < 0.500) {
      "You vent your feelings through loud and powerful music. It makes you feel empowered."
    } else {
      "You are a happy-go-lucky person!! People often looks at you and think about how kind you are."
    }
  })
  

}) # server