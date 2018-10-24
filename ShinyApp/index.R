rm(list=ls())

#This File combines everything
#run the app from this file

library(shiny)

source('ui.R', local = TRUE)
source('server.R')

require(httr)
library(jsonlite)
library(DT)



shinyApp(
  ui = myUI,
  server = myServer
)
