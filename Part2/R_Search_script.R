rm(list=ls())

df<-read.csv('Salary_Information_for_State_Authorities_NY.csv', stringsAsFactors = FALSE)

#I'm using this library
library(sqldf)



#'Converting column to a double because I kept gettig 999 as the highest value
#'I'm normalizing it because it would add more value if I wanted to work with the column
#'in any other way
df['normalized_base_pay'] <- gsub("\\,", "",df$Base.Annualized.Salary)
df['normalized_base_pay'] <- gsub("\\$", "",df$normalized_base_pay)
df['normalized_base_pay'] <- as.double(df$normalized_base_pay)





#'removing NAs in the normized column'
#'I'm converting the NAs to -
df$normalized_base_pay[is.na(df$normalized_base_pay)] <- 0
#this is my normalizing function
normalizeFunction <- function(x) {
  return ((x - min(x)) / (max(x) - min(x)))
}

#normalized
df["normalized_base_pay"] <- as.data.frame(lapply(df["normalized_base_pay"], normalizeFunction))


#converting to the columns with a better name
#when using the sqldf library spaces cause problems
colnames(df) <- gsub("\\.","_",colnames(df))



#grabbing the end of the year for ease of use inthe query
df['year_conversion'] <- df$Fiscal_Year_End_Date
df['year_conversion'] <- format(as.Date(df$year_conversion, "%m/%d/%Y"),"%Y")

#Making this a character so I could add this to the query and use a specific date
df['Fiscal_Year_End_Date'] <- as.character(df$Fiscal_Year_End_Date)

#This is the query.
#I'm using a basic select query with another nested query.
#if you want to change the year go ahead and change the year in year_conversion
FirstLastName <- sqldf("Select First_Name, Last_Name FROM df WHERE normalized_base_pay = 
                       (SELECT MAX(normalized_base_pay) FROM df WHERE year_conversion = '2015')  ")

print(FirstLastName)
