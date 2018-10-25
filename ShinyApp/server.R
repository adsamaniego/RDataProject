library(shiny)
library(httr)
library(future)
library(promises)
library(DT)
# library(magrittr)
# library(highcharter)
# library(plotly)
# library(shinydashboard)
# library(reshape)
# library(quantmod)
# library(ggplot2)
# library(reshape2)
# library(scales)
plan(multiprocess)

#Starts the server which serves the data
#Everything appears to render first on the server then sent to the UI.
myServer<-shinyServer(function(input, output) {
  source("./functions.R")
  
  
  
  
  
  
  #Changes year
  # observeEvent(input$changeyear,{
  #   newVal <-input$changeyear
  #   output$df<-renderDataTable({api(input$element_id,input$changeyear,input$checkbox )})
  #   output$dynamicText <- renderText({
  #     sprintf('%s',newVal)
  #     print(newVal)
  #     
  #   })
  # })
  
  #creating a reactive element for an api output
  value <- reactiveVal(0) 
  observeEvent(input$element_id, {
    newValue <- input$element_id   # newValue <- rv$value - 1
    value(newValue)
    # rv$value <- newValue
    output$df<-DT::renderDataTable({api(input$element_id,input$changeyear,input$checkbox)})
  })
  
  #example of handling checboxk
  # output$value <- renderPrint({ input$checkbox })
  
  #changes year range on the 2nd tab
  observeEvent({input$yearrange || input$checkbox},{
    newValue <- paste(input$yearrange, collapse = ":")
    #commenting out the counties for right now
    # if(input$checkbox==TRUE){
    #   qry<-"https://api.census.gov/data/timeseries/healthins/sahie?get=NAME,NIC_PT,NIC_UB90,NIC_LB90,NIC_MOE,SEXCAT,NUI_PT,NUI_UB90,NUI_LB90,PCTIC_LB90,PCTIC_MOE,PCTIC_PT,PCTIC_UB90,PCTUI_PT,PCTUI_UB90,PCTUI_LB90,PCTUI_MOE,RACE_DESC,SEX_DESC,GEOCAT,GEOID,AGE_DESC,IPR_DESC&for=county&in=state:19&"
    # }else{
    qry<-"https://api.census.gov/data/timeseries/healthins/sahie?get=NAME,NIC_PT,NIC_UB90,NIC_LB90,NIC_MOE,SEXCAT,NUI_PT,NUI_UB90,NUI_LB90,PCTIC_LB90,PCTIC_MOE,PCTIC_PT,PCTIC_UB90,PCTUI_PT,PCTUI_UB90,PCTUI_LB90,PCTUI_MOE,RACE_DESC,SEX_DESC,GEOCAT,GEOID,AGE_DESC,IPR_DESC&for=state:19&"
    # }
    qry<- paste(qry,"YEAR=",newValue,"&NIPR_PT&RACECAT&AGECAT&IPRCAT", sep="")
    print(qry)
    output$table <- DT::renderDataTable({
      GET.async.df.header.first(qry)
    })
  })
  #downloads data
  observeEvent(input$button,{
    newValue <- paste(input$yearrange, collapse = ":")
    if(input$checkbox==TRUE){
      qry<-"https://api.census.gov/data/timeseries/healthins/sahie?get=NAME,NIC_PT,NIC_UB90,NIC_LB90,NIC_MOE,SEXCAT,NUI_PT,NUI_UB90,NUI_LB90,PCTIC_LB90,PCTIC_MOE,PCTIC_PT,PCTIC_UB90,PCTUI_PT,PCTUI_UB90,PCTUI_LB90,PCTUI_MOE,RACE_DESC,SEX_DESC,GEOCAT,GEOID,AGE_DESC,IPR_DESC&for=county&in=state:19&"
    }else{
      qry<-"https://api.census.gov/data/timeseries/healthins/sahie?get=NAME,NIC_PT,NIC_UB90,NIC_LB90,NIC_MOE,SEXCAT,NUI_PT,NUI_UB90,NUI_LB90,PCTIC_LB90,PCTIC_MOE,PCTIC_PT,PCTIC_UB90,PCTUI_PT,PCTUI_UB90,PCTUI_LB90,PCTUI_MOE,RACE_DESC,SEX_DESC,GEOCAT,GEOID,AGE_DESC,IPR_DESC&for=state:19&"
    }
    qry<- paste(qry,"YEAR=",newValue,"&NIPR_PT&RACECAT&AGECAT&IPRCAT", sep="")
    print(qry)
    Download.File.Blocking(qry)
  })
  #This is an Async 
  #don't worry about it
  # output$table <- DT::renderDataTable({
  #   GET.async.df.header.first("https://api.census.gov/data/timeseries/healthins/sahie?get=NAME,NIC_PT,NIC_UB90,NIC_LB90,NIC_MOE,SEXCAT,NUI_PT,NUI_UB90,NUI_LB90,PCTIC_LB90,PCTIC_MOE,PCTIC_PT,PCTIC_UB90,PCTUI_PT,PCTUI_UB90,PCTUI_LB90,PCTUI_MOE,RACE_DESC,SEX_DESC,GEOCAT,GEOID&for=state:19&YEAR&NIPR_PT&RACECAT")
  # })
  
  
  
})


