library(shiny)



source("functions.R")



# Define UI for application that plots random distributions 
yrs<- api_dynamic_year_list()
sts<-api_dynamic_state_list()
print(sts)
myUI<- shinyUI(fluidPage(
  
  
  #Title
  titlePanel("Data Programing in R"),
  #Sidebar
  sidebarLayout(
    sidebarPanel( "sidebar panel",
                  #drop down for years
                  selectInput('changeyear', label='Select Year:', choice=yrs),
                  #drop down for states
                  selectInput('element_id', label = 'Select one option', choices = c(sts)),
                  #Shows counties
                  checkboxInput("checkbox", label = "Show Counties", value = FALSE),
                  #creates a Year range only effects second tab
                  sliderInput("yearrange", "Year Range:",
                              min =min(as.numeric(yrs)), max=max(as.numeric(yrs)),
                              value = c(min(as.numeric(yrs)), max(as.numeric(yrs))),
                              sep = "", ticks=TRUE, step=1),
                  #save button
                  actionButton("button", "Save All STATE Data")


                  ),
    #Main Panel
    mainPanel("main panel", 
              h1('Report'), 
              #creates Tabs
              tabsetPanel(type="tabs",
                          tabPanel("dfTable",DT::dataTableOutput("df")),
                          tabPanel("allStatestable",dataTableOutput('table')))
              
              
              
    )
  )))

