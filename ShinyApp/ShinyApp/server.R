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
library(ggplot2)
# library(reshape2)
# library(scales)
plan(multiprocess)

#Starts the server which serves the data
#Everything appears to render first on the server then sent to the UI.
myServer<-shinyServer(function(input, output) {
  source("./functions.R")
  
  key<-"&key=56d9195eb65d18606d923b5dbb6df98c5644f4be"
  
  
  #############
  #PlotMap
  url<-"https://api.census.gov/data/timeseries/healthins/sahie?get=NAME,NIC_PT&&for=county:*&in=state:19&YEAR=2016"
  
  qry<-"https://api.census.gov/data/timeseries/healthins/sahie?get=NIC_PT,NUI_PT&for=state:19&YEAR=2006:2016&key=56d9195eb65d18606d923b5dbb6df98c5644f4be"
  
  
  
  output$linePlot <- renderPlot({
    GET.async.line(qry)
  })
  
  map1<-reactive({list(input$map1Year)})
  
observeEvent(map1(),{
  qry<-"https://api.census.gov/data/timeseries/healthins/sahie?get=NAME,NIC_PT,NUI_PT,NIC_MOE,NUI_MOE&for=county:*&in=state:19&YEAR="
  qry<-paste(qry,input$map1Year,key,sep="")

  output$map1 <- renderPlot({
    GET.async.map.percent.insured(qry)
    })
  
  output$map2<-renderPlot({
    GET.async.map.percent.uninsured(qry)
  })
  
   
    d<-DT::renderDataTable({GET.async.df.header.map(qry, removeCols=TRUE, colKeep=c("NAME","NIC_PT","NUI_PT"), summary=TRUE)})

    output$dfMap<-d
    val1<-GET.async.value(qry, removeCols=TRUE, colKeep=c("TotalInsured"))
    val2<-GET.async.value(qry, removeCols=TRUE, colKeep=c("TotalUninsured"))
    
    val3<-GET.async.value(qry, removeCols=TRUE, colKeep=c("percentIn"))
    val4<-GET.async.value(qry, removeCols=TRUE, colKeep=c("percentUn"))
    
    val5<-GET.async.value(qry, removeCols=TRUE, colKeep=c("meanInsured"))
    val6<-GET.async.value(qry, removeCols=TRUE, colKeep=c("meanUninsured"))
    
    val7<-GET.async.value(qry, removeCols=TRUE, colKeep=c("minInsured"))
    val8<-GET.async.value(qry, removeCols=TRUE, colKeep=c("minUninsured"))
    
    val9<-GET.async.value(qry, removeCols=TRUE, colKeep=c("maxInsured"))
    val10<-GET.async.value(qry, removeCols=TRUE, colKeep=c("maxUninsured"))
  
   
    
    # Show the values in an HTML table ----
    output$insured <- renderText({
     val1
    })
    output$uninsured <- renderText({
      val2
    })
    
    output$percentIn <- renderText({
      val3
    })
    
    output$percentUn <- renderText({
      val4
    })
    
    output$meanInsured <- renderText({
      val5
    })
    output$meanUninsured <- renderText({
      val6
    })
    
    output$minInsured <- renderText({
      val7
    })
    
    output$minUninsured <- renderText({
      val8
    })
    
    output$maxInsured <- renderText({
      val9
    })
    
    output$maxUninsured <- renderText({
      val10
    })
    
}
  

)


  
  

  
  #creating a reactive element for an api output

toListen <- reactive({
  list(input$changeyear,input$checkbox)
})

  observeEvent(toListen(), {
  
    qry<-"https://api.census.gov/data/timeseries/healthins/sahie?get=NAME,NIC_PT,NUI_PT&for="
    
    if(input$checkbox==TRUE){
      qry<-paste(qry,"county:*&in=","state:19","&YEAR=",input$changeyear,key,sep = "")
    }else{
      qry<-paste(qry,"state:19","&YEAR=",input$changeyear,key, sep = "")
    }
    print("new")
    print(qry)
    # input$element_id,input$changeyear,input$checkbox
    output$df<-DT::renderDataTable({GET.async.df.header.first(qry, removeCols=TRUE, c("NAME","NIC_PT","NUI_PT"))
      })
    print("new")
    
  })
  
  #example of handling checboxk
   output$value <- renderPrint({ input$checkbox })
  
  #changes year range on the 2nd tab
   
  
  observeEvent(input$yearrange ,{
    newValue <- paste(input$yearrange, collapse = ":")
    qry<-"https://api.census.gov/data/timeseries/healthins/sahie?get=NAME,NIC_PT,NIC_UB90,NIC_LB90,NIC_MOE,SEXCAT,NUI_PT,NUI_UB90,NUI_LB90,PCTIC_LB90,PCTIC_MOE,PCTIC_PT,PCTIC_UB90,PCTUI_PT,PCTUI_UB90,PCTUI_LB90,PCTUI_MOE,RACE_DESC,SEX_DESC,GEOCAT,GEOID,AGE_DESC,IPR_DESC&for=state:19&"
    qry<- paste(qry,"YEAR=",newValue,"&NIPR_PT&RACECAT&AGECAT&IPRCAT",key, sep="")
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
    qry<- paste(qry,"YEAR=",newValue,"&NIPR_PT&RACECAT&AGECAT&IPRCAT",key, sep="")
    print(qry)
    Download.File.Blocking(qry)
  })
  
  
  
})




# mapListen <- reactive({
#   list(input$changeyear,input$checkbox)
# })
# map2<-reactive({input$map1Year})
# observeEvent(map2(), {
#   
#   qry<-"https://api.census.gov/data/timeseries/healthins/sahie?get=NAME,NIC_PT,NUI_PT&for="
#   
#   if(input$checkbox==TRUE){
#     qry<-paste(qry,"county:*&in=","state:19","&YEAR=",input$map1Year,key,sep = "")
#   }else{
#     qry<-paste(qry,"state:19","&YEAR=",input$map1Year,key, sep = "")
#   }
# 
#   print("qry")
#   # input$element_id,input$changeyear,input$checkbox
#   output$dfMap<-DT::renderDataTable({GET.async.df.header.map(qry, removeCols=TRUE, c("NAME","NIC_PT","NUI_PT"))
#   })
# 
#   
# })




