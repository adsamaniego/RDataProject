source("./functions.R")

yrs<- api_dynamic_year_list()
sts<-api_dynamic_state_list()


tab2<- tabPanel("MapTest",
                #Title
                
                titlePanel("Map"),
                #Sidebar
                #sidebarLayout(
                  sidebarPanel(
                    selectInput('map1Year', label='Select Year:', choice=yrs),
                    
                    p("Insured:", textOutput("insured", inline = TRUE)),
                    p("Uninsured:",textOutput("uninsured", inline = TRUE)),
                    
                    p("% Insured:",textOutput("percentIn", inline = TRUE)),
                    p("% Uninsured:",textOutput("percentUn", inline = TRUE)),
                    
                    p("Mean Insured:",textOutput("meanInsured", inline = TRUE)),
                    p("Mean Uninsured:",textOutput("meanUninsured", inline = TRUE)),
                    
                    p("Min Insured:",textOutput("minInsured", inline = TRUE)),
                    p("Min Uninsured:",textOutput("minUninsured", inline = TRUE)),
                    
                    p("Max Insured:",textOutput("maxInsured", inline = TRUE)),
                    p("Max Uninsured:",textOutput("maxUninsured", inline = TRUE))
                    
                  ),
                  #Main Panel
                  mainPanel("main panel", 
                            h1('Report'), 
                            
                            h3("Insured"),plotOutput("map1",width = "600px", height = "400px") ,
                            h3("Uninsured"),plotOutput("map2",width = "600px", height = "400px"),
                            h3("Data"),DT::dataTableOutput("dfMap")
                            
                            
                  )
                  
                  
                  
                #)
)
