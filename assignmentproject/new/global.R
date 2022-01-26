library(httr)
library(shiny)
library(shinyjs)
library(shinyBS)
library(tidyverse)
library(shinymaterial)
library(tibble)
library(highcharter)
library(RColorBrewer)
library(shinycssloaders)
library(htmltools)
library(lubridate)
library(lazyeval)
library(spotifyr)

rm(list = ls())

source('helpers.R')

jscode <-
  '$(document).on("shiny:connected", function(e) {
  var jsWidth = screen.width;
  Shiny.onInputChange("GetScreenWidth",jsWidth);
});
'
base_url <- 'https://api.spotify.com/v1/'

neon_colors <- c(
  '#84DE02'
  , '#4cb88f'
  , '#9fe8c2'
  , '#223a4c'
  , '#90d2d8'
  , '#b7e0dc'
  , '#c2f2d0'
  , '#abe9b8'
  , '#ffecb8'
  , '#008917'
  , '#462c87'
  , '#bec69e'
  , '#b2e6ae'
  , '#94e88d'
  , '#cbedfb'
)

pca_vars <- c('danceability', 'energy', 'loudness', 'speechiness', 'acousticness', 'instrumentalness', 'liveness', 'valence', 'tempo', 'duration_ms')