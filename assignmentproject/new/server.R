shinyServer(function(input, output, session) {
  
  spotify_access_token <- reactive({
    Sys.setenv(SPOTIFY_CLIENT_ID = "spotifyid")
    Sys.setenv(SPOTIFY_CLIENT_SECRET = "spotifysec")
    get_spotify_access_token()
  })
  
  artist_info <- reactive({
    req(input$artist_search != '')
    search_spotify(input$artist_search, 'artist', authorization = spotify_access_token()) %>% 
      filter(!duplicated(name))
  })
  
  observeEvent(input$artist_search, {
    choices <- artist_info()$name
    names(choices) <- choices
    update_material_dropdown(session, 'select_artist', value = artist_info()$name[1], choices = choices)
  })
  
  output$select_artist_ui <- renderUI({
    req(nrow(artist_info()) > 0)
    tagList(
      withBusyIndicatorUI(
        actionButton('tracks_go', 'See this artist\'s sentiment', class = 'btn-primary', color = 'white')
      ),
      p("Generating the plot can take a couple seconds"),
      material_switch('artist_autoplay', 'Play song preview on hover', color = 'white'),
      br(),
      uiOutput('artist_chart_song_ui')
    )
  })
  
  observeEvent(input$tracks_go, {
    output$artist_image <- renderUI({
      req(nrow(artist_info()) > 0)
      tagList(
        htmlOutput('artist_img')
      )
    })
    
    output$user_sentiment <- renderText({
      temp1 <-  as.data.frame(artist_audio_features())
      temp <- cbind(temp1$energy, temp1$valence) 
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
  })
  
  
  
  selected_artist <- reactive({
    req(nrow(artist_info()) > 0)
    artist_info() %>% 
      filter(name == input$select_artist) %>% 
      filter(popularity == max(popularity))
  })
  
  observeEvent(input$select_artist, {
    
    req(nrow(artist_info()) > 0)
    
    artist_img <- ifelse(!is.na(selected_artist()$images[[1]]$url[1]), selected_artist()$images[[1]]$url[1], 'https://pbs.twimg.com/profile_images/509949472139669504/IQSh7By1_400x400.jpeg')
    
    output$artist_img <- renderText({
      HTML(str_glue('<img src={artist_img} height="200">'))
    })
    
  })
  
  artist_audio_features <- eventReactive(input$tracks_go, {
    df <- get_artist_audio_features(selected_artist()$name, authorization = spotify_access_token()) %>% 
      mutate(album_img = map_chr(1:nrow(.), function(row) {
        .$album_images[[row]]$url[1]
      }))
    if (nrow(df) == 0) {
      stop("Sorry, couldn't find any tracks for that artist's albums on Spotify.")
    }
    return(df)
  })
  
  output$artist_quadrant_chart <- renderHighchart({
    artist_quadrant_chart(artist_audio_features()) %>% 
      hc_add_event_point(event = 'mouseOver')
  })
  
  output$artist_chart_song_ui <- renderUI({
    
    req(input$artist_quadrant_chart_mouseOver, input$artist_autoplay == TRUE)
    
    artist_track_hover <- input$artist_quadrant_chart_mouseOver
    track_preview_url <- artist_audio_features() %>% filter(
      album_name == artist_track_hover$series,
      valence == artist_track_hover$x,
      energy == artist_track_hover$y
    ) %>% pull(track_preview_url)
    
    if (!is.na(track_preview_url)) {
      tagList(
        tags$audio(id = 'song_preview', src = track_preview_url, type = 'audio/mp3', autoplay = NA, controls = NA),
        tags$script(JS("myAudio=document.getElementById('song_preview'); myAudio.play();"))
      )
    } else {
      h5('No preview for this track on Spotify')
    }
  })
  
  observeEvent(input$tracks_go, {
    output$artist_plot <- renderUI({
      if (input$GetScreenWidth >= 800) {
        withSpinner(highchartOutput('artist_quadrant_chart', width = '820px', height = '800px'), type = 5, color = 'black')
      } else {
        withSpinner(highchartOutput('artist_quadrant_chart'), type = 5, color = 'black')
      }
    })
  })
  
})
