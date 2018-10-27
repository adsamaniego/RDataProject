library(shiny)

library(tidyverse)
library(ggplot2)
library(httr)
library(future)
library(promises)
plan(multisession)






source("./front-end/tab1.R")
source("./front-end/tab2.R")
source("./front-end/tab3.R")


# Define UI for application that plots random distributions 









myUI<- shinyUI(navbarPage("",tab1, tab2, tab3))