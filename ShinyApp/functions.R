library(httr)
library(future)
library(promises)

plan(multiprocess)

read.csv.async <- function(file, header = TRUE, stringsAsFactors = FALSE) {
  future({
    read.csv(file, header = header, stringsAsFactors = stringsAsFactors)
  })
}



# GET.async<-function(qry){
#   qr<-future({GET(qry)})%...>%
#     (function(result){content(result)})%...>%
#     # (function(result){unlist(result) })%...>%
#     (function(result){data.frame(matrix(unlist(result), nrow=length(result), byrow=T),  stringsAsFactors=FALSE)})%...>%
#     # (function(result){as.character(colnames(result) <-unlist(result[1,]))})%...>%
#     (function(result){return(result)})
#   return(qr)
#   
# }

#Async api get
GET.async.df.header.first<-function(qry){
  qr<-future({GET(qry)})%...>%
    (function(result){content(result)})%...>%
    # (function(result){unlist(result) })%...>%
    (function(result){data.frame(matrix(unlist(result), nrow=length(result), byrow=T),  stringsAsFactors=FALSE)})%...>%
    # (function(result){as.character(colnames(result) <-unlist(result[1,]))})%...>%
    (function(result){
      colnames(result) <- as.character(unlist(result[1,]))
      result = result[-1, ]})%...>%
    (function(result){
     
    
      return(result)
    })
      
  return(qr)
  
}





#downloads data from the second tab. This is blocking
Download.File.Blocking<-function(qry){
  df<-GET(qry)
  df<-content(df)
  df <- data.frame(matrix(unlist(df), nrow=length(df), byrow=T),  stringsAsFactors=FALSE)
  colnames(df) <- as.character(unlist(df[1,]))
  df = df[-1, ]
  write.csv(df, file = "MyData.csv")
  
}



#General API Get
api<- function(st="*", yr, county=FALSE){
  qry<-"https://api.census.gov/data/timeseries/healthins/sahie?get=NAME,NIC_PT,RACE_DESC,SEXCAT,SEX_DESC&"
  if(county==FALSE){
    st<-paste("for=state:",st,sep = "")
  }else{
    st<-paste("for=county:*&in=state:",st,sep = "")
  }
  qry<-paste(qry,"&",st,"&YEAR=",yr,sep = "")
  print(qry)
  df<-GET(qry)
  df<-content(df)
  df <- data.frame(matrix(unlist(df), nrow=length(df), byrow=T),  stringsAsFactors=FALSE)
  colnames(df) <- as.character(unlist(df[1,]))
  df = df[-1, ]
  return(df)
}

# apiYear<- function(year="2010", st= "*"){
#     require(httr)
#     
#     qry<-"https://api.census.gov/data/timeseries/healthins/sahie?get=NAME,NIC_PT,RACE_DESC,SEXCAT,SEX_DESC&"
#     qry_state_yr<-paste("for=state:",st,"&time=",year,sep = "")
#     qry<-paste(qry,"&",qry_state_yr,sep = "")
#     print(qry)
#     df<-GET(qry)
#     df<-content(df)
#     df <- data.frame(matrix(unlist(df), nrow=length(df), byrow=T),  stringsAsFactors=FALSE)
#     colnames(df) <- as.character(unlist(df[1,]))
#     df = df[-1, ]
#     print("Called apiYear")
#     return(df)
#   }

#Creates a dynamic State List, Not really needed since we are only doing Iowa
api_dynamic_state_list <- function(){
  qry<-"https://api.census.gov/data/timeseries/healthins/sahie?get=NAME&for=state:19&YEAR"
  df<-GET(qry)
  df<-content(df)
  df <- data.frame(matrix(unlist(df), nrow=length(df), byrow=T),  stringsAsFactors=FALSE)
  colnames(df) <- as.character(unlist(df[1,]))
  df = df[-1, ]
  stateAPI<- unique(paste(df$state))
  names(stateAPI) <- unique(paste(df$NAME))
  list(stateAPI)
  print("Called api_dynamic_state_list")
  return(stateAPI)
  
}


#Creates a dynamic year
api_dynamic_year_list <- function(){
  
  qry<-"https://api.census.gov/data/timeseries/healthins/sahie?get=NAME&for=state:19&YEAR"
  # 
  df<-GET(qry)
  df<-content(df)
  df <- data.frame(matrix(unlist(df), nrow=length(df), byrow=T),  stringsAsFactors=FALSE)
  colnames(df) <- as.character(unlist(df[1,]))
  df = df[-1, ]
  yrs <- unique(df$YEAR)
  print("Called api_dynamic_year_list")
  return(yrs)
  

}











# 
# dfState<- api_state_df()
# 
# df<-dfState
# 
# 
# 
# df_dfstate<- function(){
#   df<-dfState
#   
#   return(df)
# }

# df<-api_state_df()
# 
# 
# 
# api_state_df<-function(){
# 
#   qry<-"https://api.census.gov/data/timeseries/healthins/sahie?"
# 
#   getclause<-"get=NAME,NIC_PT,NIC_UB90,NIC_LB90,NIC_MOE,SEXCAT,NUI_PT,NUI_UB90,NUI_LB90,PCTIC_LB90,PCTIC_MOE,PCTIC_PT,PCTIC_UB90,PCTUI_PT,PCTUI_UB90,PCTUI_LB90,PCTUI_MOE,RACE_DESC,SEX_DESC,GEOCAT,GEOID"
#   foryear<-"&for=state:*&YEAR&NIPR_PT&RACECAT"
#   qry<- paste(qry, getclause, foryear,sep = "")
# 
#   df<-GET(qry)
#   df<-content(df)
#   df <- data.frame(matrix(unlist(df), nrow=length(df), byrow=T),  stringsAsFactors=FALSE)
#   colnames(df) <- as.character(unlist(df[1,]))
#   df = df[-1, ]
#   
#   names(df)[names(df)=="NAME"] = "State"
#   names(df)[names(df)=="NIC_PT"] = "Insured"
#   names(df)[names(df)=="NIC_UB90"] = "Insured Upper90%"
#   names(df)[names(df)=="NIC_LB90"] = "Insured Lower90%"
#   names(df)[names(df)=="NIC_MOE"] = "Insured MOE"
#   
#   print("Called api_state_df")
#   return(df)
# 
# }


