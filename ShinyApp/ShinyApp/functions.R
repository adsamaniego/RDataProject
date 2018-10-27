library(httr)
library(future)
library(promises)

plan(multiprocess)
key<-"&key=56d9195eb65d18606d923b5dbb6df98c5644f4be"

read.csv.async <- function(file, header = TRUE, stringsAsFactors = FALSE) {
  future({
    read.csv(file, header = header, stringsAsFactors = stringsAsFactors)
  })
}





GET.async.df.header.first<-function(qry,removeCols=FALSE,colKeep=""){
  qr<-future({GET(qry)})%...>%{
    x<-.
    x<-content(x)
    x<-data.frame(matrix(unlist(x), nrow=length(x), byrow=T),  stringsAsFactors=FALSE)
    colnames(x) <-unlist(x[1,])
    x<-x[-1, ]
    rownames(x) <- NULL
    
    if(removeCols==TRUE){
      x<-subset(x, select= colKeep)
    }
    
    return(x)
    
  }
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
  qry<-"https://api.census.gov/data/timeseries/healthins/sahie?get=NAME,NIC_PT,NUI_PT&"
  if(county==FALSE){
    st<-paste("for=state:",st,sep = "")
  }else{
    st<-paste("for=county:*&in=state:",st,sep = "")
  }
  qry<-paste(qry,"&",st,"&YEAR=",yr,key,sep = "")
  print(qry)
  df<-GET(qry)
  df<-content(df)
  df <- data.frame(matrix(unlist(df), nrow=length(df), byrow=T),  stringsAsFactors=FALSE)
  colnames(df) <- as.character(unlist(df[1,]))
  df = df[-1, ]
  return(df)
}


#Creates a dynamic State List, Not really needed since we are only doing Iowa
api_dynamic_state_list <- function(){
  qry<-"https://api.census.gov/data/timeseries/healthins/sahie?get=NAME&for=state:19&YEAR=2016"
  qry<-paste(qry,key,sep="")
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
  qry<-paste(qry,key,sep="")
  print(qry)
  df<-GET(qry)
  df<-content(df)
  df <- data.frame(matrix(unlist(df), nrow=length(df), byrow=T),  stringsAsFactors=FALSE)
  colnames(df) <- as.character(unlist(df[1,]))
  df = df[-1, ]
  yrs <- unique(df$YEAR)
  print("Called api_dynamic_year_list")
  
  return(yrs)
  

}



GET.async.map.percent.insured<-function(qry,removeCols=FALSE,colKeep=""){
  qr<-future({GET(qry)})%...>%{
    x<-.
    x<-content(x)
    x<-data.frame(matrix(unlist(x), nrow=length(x), byrow=T),  stringsAsFactors=FALSE)
    colnames(x) <-unlist(x[1,])
    x<-x[-1, ]
    rownames(x) <- NULL
    x$StateAbv<-substring(tolower(x$NAME),nchar(x$NAME)-2)
    x$county<-substr(tolower(x$NAME),1,nchar(x$NAME)-11)
    x$NIC_PT<- as.numeric(x$NIC_PT)
    x$NUI_PT<- as.numeric(x$NUI_PT)
    x$PERCENTINSURED<- x$NIC_PT/(x$NUI_PT + x$NIC_PT)
    
    sc_map <- map_data("county",region="iowa")
    
    x<-as.data.frame(x) %>%
      select(county,PERCENTINSURED) %>%
      right_join(sc_map,by=c("county"="subregion"))
    
    return(ggplot() + geom_polygon(aes(x=long,y=lat,group=group,fill=PERCENTINSURED),data=x) + theme_test()+ scale_fill_gradientn(colours = rev(rainbow(3))
                                                                                                                          ))
  }
  return(qr)
  
}

GET.async.map.percent.uninsured<-function(qry,removeCols=FALSE,colKeep=""){
  qr<-future({GET(qry)})%...>%{
    x<-.
    x<-content(x)
    x<-data.frame(matrix(unlist(x), nrow=length(x), byrow=T),  stringsAsFactors=FALSE)
    colnames(x) <-unlist(x[1,])
    x<-x[-1, ]
    rownames(x) <- NULL
    x$StateAbv<-substring(tolower(x$NAME),nchar(x$NAME)-2)
    x$county<-substr(tolower(x$NAME),1,nchar(x$NAME)-11)
    x$NIC_PT<- as.numeric(x$NIC_PT)
    x$NUI_PT<- as.numeric(x$NUI_PT)
    x$PERCENTUNINSURED<- x$NUI_PT/(x$NUI_PT + x$NIC_PT)
    
    sc_map <- map_data("county",region="iowa")
    
    x<-as.data.frame(x) %>%
      select(county,PERCENTUNINSURED) %>%
      right_join(sc_map,by=c("county"="subregion"))
    
    return(ggplot() + geom_polygon(aes(x=long,y=lat,group=group,fill=PERCENTUNINSURED),data=x) + theme_test()+ scale_fill_gradientn(colours = rev(rainbow(3))
    ))
  }
  return(qr)
  
}



#returns table on the map
GET.async.df.header.map<-function(qry,removeCols=FALSE,colKeep="",summary=FALSE){
  qr<-future({GET(qry)})%...>%{
    x<-.
    x<-content(x)
    x<-data.frame(matrix(unlist(x), nrow=length(x), byrow=T),  stringsAsFactors=FALSE)
    colnames(x) <-unlist(x[1,])
    x<-x[-1, ]
    rownames(x) <- NULL
    
    
    # if(removeCols==TRUE){
    #   x<-subset(x, select= colKeep)
    # }

    x$NIC_PT<- as.numeric(x$NIC_PT)
    x$NUI_PT<- as.numeric(x$NUI_PT)
    
    if(summary==FALSE){
      x$TotalInsured<-sum(x$NIC_PT, na.rm=TRUE)
      x$TotalUninsured<-sum(x$NUI_PT, na.rm=TRUE)
      
      x$total<-x$TotalInsured+x$TotalUninsured
      x$percentIn<-round((x$TotalInsured/x$total)*100,2)
      x$percentUn<-round((x$TotalUninsured/x$total)*100,2)
      
      x$meanInsured<-round(mean(x$NIC_PT),2)
      x$meanUninsured<-round(mean(x$NUI_PT),2)
      
      x$minInsured<-min(x$NIC_PT)
      x$minUninsured<-min(x$NUI_PT)
      
      x$maxInsured<-max(x$NIC_PT)
      x$maxUninsured<-max(x$NUI_PT)
      
       colKeep=c("YEAR","total","TotalInsured","TotalUninsured","percentIn","percentUn","meanInsured","meanUninsured",
                 "minInsured","minUninsured","maxInsured","maxUninsured")
      x<-subset(x, select= colKeep)
      x<-unique(x)
      
    }else{
      if(removeCols==TRUE){
        x<-subset(x, select= colKeep)
      }
      x$total<-x$NIC_PT+x$NUI_PT
      x$percentIn<-round((x$NIC_PT/x$total)*100,2)
      x$percentUn<-round((x$NUI_PT/x$total)*100,2)
     
    }
    return(x)
  }
  return(qr)
  
}


#returns table on the map
#this is where you want to manipulate your data sample prob. MOE
GET.async.value<-function(qry,removeCols=FALSE,colKeep="",summary=FALSE){
  qr<-future({GET(qry)})%...>%{
    x<-.
    x<-content(x)
    x<-data.frame(matrix(unlist(x), nrow=length(x), byrow=T),  stringsAsFactors=FALSE)
    colnames(x) <-unlist(x[1,])
    x<-x[-1, ]
    rownames(x) <- NULL
    #Start here
    x$NIC_PT<- as.numeric(x$NIC_PT)
    x$NUI_PT<- as.numeric(x$NUI_PT)
    
   
      x$TotalInsured<-sum(x$NIC_PT, na.rm=TRUE)
      x$TotalUninsured<-sum(x$NUI_PT, na.rm=TRUE)
      
      x$total<-x$TotalInsured+x$TotalUninsured
      x$percentIn<-round((x$TotalInsured/x$total)*100,2)
      x$percentUn<-round((x$TotalUninsured/x$total)*100,2)
      
      x$meanInsured<-round(mean(x$NIC_PT),2)
      x$meanUninsured<-round(mean(x$NUI_PT),2)
      
      x$minInsured<-min(x$NIC_PT)
      x$minUninsured<-min(x$NUI_PT)
      
      x$maxInsured<-max(x$NIC_PT)
      x$maxUninsured<-max(x$NUI_PT)
      
      colKeep=colKeep
      print(names(x))
      #End here
      x<-subset(x, select= colKeep)
      x<-unique(x)
      x<-x[1,]

    return(x)
  }
  return(qr)
  
}

GET.async.line<-function(qry){
  qr<-future({GET(qry)})%...>%{
    x<-.
    x<-content(x)
    x<-data.frame(matrix(unlist(x), nrow=length(x), byrow=T),  stringsAsFactors=FALSE)
    colnames(x) <-unlist(x[1,])
    x<-x[-1, ]
    rownames(x) <- NULL
    
    
    x$NIC_PT<- as.numeric(x$NIC_PT)
    x$NUI_PT<- as.numeric(x$NUI_PT)
    
    
    # x$PERCENTUNINSURED<- x$NUI_PT/(x$NUI_PT + x$NIC_PT)
    x<-subset(x, select=c(NIC_PT,YEAR))
    x <- melt(x, id="YEAR")  # convert to long format
    
    
    return(ggplot(data=x,aes(x=YEAR, y=value, colour=variable,group=variable))+ geom_line()+ theme_test())
    
  }
  return(qr)
  
}









