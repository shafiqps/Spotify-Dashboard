function(request) {
  material_page(title = HTML('<span style="color:white">Spotify Music Sentiment AnalyzR</span> <span style="font-size:12px"><a>by the ListenRs</a></span>'),
                nav_bar_color = 'black',
                font_color = 'black',
                background_color = 'white',
                tags$head(tags$link(rel = 'icon', type = 'image/png', href = 'green_music_note.png'),
                          tags$title('Music Sentiment AnalyzR')),
                useShinyjs(),
                tags$script(jscode),
                tags$style(appCSS),
                tags$head(tags$link(rel = 'stylesheet', type = 'text/css', href = 'style.css'),
                          tags$head(includeScript('www/ga.js')),
                          tags$head(includeScript('www/hotjar.js'))),
                material_tabs(
                  tabs = c(
                    "Artist's Sentiment Analysis" = "first_tab",
                    "About" = "second_tab"
                  )
                ),
                # Define tab content
                material_tab_content(
                  tab_id = "first_tab",{
                    material_row(
                      material_column(
                        width = 3,
                        material_card(
                          title = '',
                          depth = 4,
                          material_text_box('artist_search', "Type an artist name", color = 'black'),
                          conditionalPanel("input.artist_search !== ''", material_dropdown('select_artist', 'Choose an artist from these matches on Spotify', '', color = 'black')),
                          uiOutput('select_artist_ui')
                        ),
                        material_card(
                          uiOutput('artist_image'),
                          shiny::tags$h4("If you like this artist, you are: "),
                          tags$style("#user_sentiment
                                               {font-family: 'times';
                                                font-size: 20px;
                                                color: black;
                                                display: block;
                                                text-align: center;
                                                padding-top: 25px;
                                                padding-bottom: 10px}"),
                          textOutput('user_sentiment')
                        )
                      ),
                      material_column(
                        width = 9,
                        uiOutput('artist_plot')
                      )
                    )
                  }
                ),
                material_tab_content(
                  tab_id = "second_tab",
                  tags$h3("The ListenRs"),
                  tags$h4("A little bit about our project."),
                  p("Our apps implemented Spotify API to fetch data from the actual spotify app and analyze the 
                        sentiment for each songs by different artists.", style = "font-family: 'times'; font-size: 16pt"),
                  p("Initially, we wanted to make our app more user based. Which is to prompt the user to enter their client ID and client Secret from their
                      spotify API in order to fetch their listening data trends.But after attempting to deploy the 
                        app we realized that direct authentication cannot be done inside shinyapps. There will 
                        be errors stating \" invalid CLIENT_id \" and the app could not run at all. And so in attempt to fix this problem in the last minute, 
                        we were forced to scrape our original idea and make a new app. Now instead of it being 
                        user based (with log in feature), We analyze it based on the artist that the user choose.", style = "font-family: 'times'; font-size: 16pt"),
                  br(),br(),
                  h5("To use our app"),
                  p("Simply type in the artist's name that you are curious to know about in the text input box and choose your artist from the dropdown selector.
                    Click the \"SEE THIS ARTIST\'S SENTIMENT\" button and wait for your chart to appear. Generating the chart could take a while so please be patient... Enjoy!", style = "font-family: 'times'; font-size: 16pt"),
                  HTML(paste("Credit to team members: ","Muhammad Shafiq Aiman Bin Nu Mahamad @ Marzuki (U2000428), Muhammad Tareq Adam bin Ellias (U2001228), Masyitah Humaira Binti Mohd Hafidz (U2000518), Nurhan Nufa'il bin Azman (U2000483)",sep="<br/>")),
                  br(),br(),br(),br(),br(),br()
                )
  )
}