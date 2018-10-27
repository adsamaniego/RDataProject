source("./functions.R")




tab3<- tabPanel("MapTest",
                #Title
                
                titlePanel("Line Graph "),
                mainPanel(
                  h3("Insured Data"), plotOutput("linePlot") ,
                  #this will be done later
                  plotOutput("uninsuredPlot")
                )
                
                
                

                
                
                
                
                
)