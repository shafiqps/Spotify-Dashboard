library(shiny)

port <- Sys.getenv('PORT')

shiny::runApp(
  appDir = getwd()
)