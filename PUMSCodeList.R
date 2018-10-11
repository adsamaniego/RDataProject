#url to 2012-2016 PUMS Code List
#url <- "https://www2.census.gov/programs-surveys/acs/tech_docs/pums/code_lists/ACSPUMS2012_2016CodeLists.xlsx"
#Download excel file
#download.file(url, destfile = "ACSPUMS2012_2016CodeLists.xlsx")
#rm(url)
###Downloaded .xlsx file is corrupted?
###Manually downloading/reading "ACSPUMS2012_2016CodeLists.xlsx" temporarily

#Ancestry
#Read excel file, ancestry codes stored on 1st sheet, store in data frame
#Clean read by specifying relevant data range, A3:B584, col_names in first row, na="."
library(readxl)
dfAncestry <- read_xlsx("ACSPUMS2012_2016CodeLists.xlsx", sheet = 1, range = "A3:B584", col_names = T, na = ".")
dfAncestry <- dfAncestry[complete.cases(dfAncestry),]

#DegreeField
#Field of Degree codes stored on 2nd sheet, A4:B195, col_names in first row, na="."
dfDegreeField <- read_xlsx("ACSPUMS2012_2016CodeLists.xlsx", sheet = 2, range = "A4:B195", col_names = T, na = ".")
dfDegreeField <- dfDegreeField[complete.cases(dfDegreeField),]

#GroupQuarters
#Group Quarters codes stored on 4th sheet, A4:B29, col_names in first row
#Possible to skip 5th (Institutional description) and 21st (non-Institution description) row?
#No, delete afterwards.
dfGroupQuarters <- read_xlsx("ACSPUMS2012_2016CodeLists.xlsx", sheet = 4, range = "A4:B29", col_names = T)
dfGroupQuarters <- dfGroupQuarters[c(2:16,18:25),]

#Hispanic
#Hispanic Origin codes stored on 5th sheet, A4:B90, col_names in first row, na="."
dfHispanic <- read_xlsx("ACSPUMS2012_2016CodeLists.xlsx", sheet = 5, range = "A4:B90", col_names = T, na = ".")
dfHispanic <- dfHispanic[complete.cases(dfHispanic),]

#Industry
#Goes with variable INDP
#Industry codes stored on 6th sheet, B2:D20, col_names = False, na="."
#dfIndustry <- read_xlsx("ACSPUMS2012_2016CodeLists.xlsx", sheet = 6, range = "B2:D20", col_names = F, na = ".")
#Cannot be read in and understood, will do manually
CodesLowerLimit <- c("0010", "0570", "0770", "1070", "4070", "4670", "6070", "6470", "6870", "7270", "7860", "8560", "8770", "9370", "9670")
CodesUpperLimit <- c("0560", "0760", "1060", "4060", "4660", "6060", "6460", "6860", "7260", "7790", "8490", "8690", "9290", "9590", "9890")
Description <- c("Agriculture, Forestry, Fishing and Hunting, and Mining",
                         "Transportation, Warehousing, and Utilities",
                         "Construction",
                         "Manufacturing",
                         "Wholesale Trade",
                         "Retail Trade",
                         "Transportation, Warehousing, and Utilities",
                         "Information",
                         "Finance, Insurance, Real Estate, and Rental & Leasing",
                         "Professional, Scientific, Management, Administrative, and Waste Management Services",
                         "Educational Services, Health Care, and Social Assistance",
                         "Arts, Entertainment, & Recreation, and Accomodation & Food Services",
                         "Other Services (except Public Administration)",
                         "Public Administration",
                         "Active Duty Military")
dfIndustry <- data.frame(CodesLowerLimit)
dfIndustry[,2] <- CodesUpperLimit
dfIndustry[,3] <- Description
rm("CodesLowerLimit", "CodesUpperLimit", "Description")
colnames(dfIndustry) <- c("Code Lower Limit", "Code Upper Limit", "PUMS Industry Description")

#Language
#Language codes are stored on 7th sheet, A3:B1336, col_names=T, na="."
dfLanguage <- suppressWarnings(read_xlsx("ACSPUMS2012_2016CodeLists.xlsx", sheet = 7, range = "A3:B1336", col_names = T, na = "."))
#Error message in loading "9500 (HHLANP)", supposed to be found in dfLanguage[1252,1], just manually enter number before complete.cases
dfLanguage[1252,1] <- 9500
dfLanguage <- dfLanguage[complete.cases(dfLanguage),]

#MigrationPUMA
##Not completely sure how this data is different than PUMA data downloaded separately
#Migration PUMA coding data is stored in 8th sheet, D4:F4764, col_names=T
dfMigrationPUMA <- read_xlsx("ACSPUMS2012_2016CodeLists.xlsx", sheet = 8, range = "D4:F4764", col_names = T)
dfMigrationPUMA <- dfMigrationPUMA[complete.cases(dfMigrationPUMA),]

#MigrationStCntry
#Migration State/Country coding data is stored in 9th sheet, A2:B332, col_names=T, na="."
dfMigrationStCntry <- read_xlsx("ACSPUMS2012_2016CodeLists.xlsx", sheet = 9, range = "A2:B332", col_names = T, na = ".")
dfMigrationStCntry <- dfMigrationStCntry[complete.cases(dfMigrationStCntry),]

#Occupation
#Goes with variable OCCP
#Occupation data is not stored in a table format, will do manually
CodesLowerLimit <- c("0010", "3600", "4700", "6000", "7700")
CodesUpperLimit <- c("3540", "4650", "5940", "7630", "9750")
Description <- c("Management, Business, Science, and Arts Occupations",
                 "Service Occupations",
                 "Sales and Office Occupations",
                 "Natural Resources, Construction, and Maintenance Occupations",
                 "Production, Transportation, and Material Moving Occupations")
dfOccupation <- data.frame(CodesLowerLimit)
dfOccupation[,2] <- CodesUpperLimit
dfOccupation[,3] <- Description
rm("CodesLowerLimit", "CodesUpperLimit", "Description")
colnames(dfOccupation) <- c("Code Lower Limit", "Code Upper Limit", "PUMS Occupation Description")
#dfOccupation <- dfOccupation[complete.cases(dfOccupation),]

#POBirth
#Place of Birth code data is stored on 11th sheet, "A2:B332", col_names=T, na="."
dfPOBirth <- read_xlsx("ACSPUMS2012_2016CodeLists.xlsx", sheet = 11, range = "A2:B332", col_names = T, na = ".")
dfPOBirth <- dfPOBirth[complete.cases(dfPOBirth),]

#POWork
#Place of Work State/Country code data is stored on 12th sheet, "A2:B334", col_names=T, na="."
dfPOWork <- read_xlsx("ACSPUMS2012_2016CodeLists.xlsx", sheet = 12, range = "A2:B334", col_names = T, na = ".")
dfPOWork <- dfPOWork[complete.cases(dfPOWork),]

#POWPUMA
#Place of Work PUMA code data is stored on 13th Sheet, "E5:G42551", col_names=T
dfPOWPUMA <- read_xlsx("ACSPUMS2012_2016CodeLists.xlsx", sheet = 13, range = "E5:G42551", col_names = T)
dfPOWPUMA <- dfPOWPUMA[complete.cases(dfPOWPUMA),]

#PUMA
#Going to scrape data of (PUMA) Public Use Microdata Area codes for the state of Iowa
#Can be found on "https://www.census.gov/geo/maps-data/maps/2010puma/st19_ia.html"
library(xml2)
library(rvest)
url <- "https://www.census.gov/geo/maps-data/maps/2010puma/st19_ia.html"
html <- read_html(url)
htmltable <- html_table(html, fill=T)
#Will save as dfPUMA within R, and save .csv file to OneDrive
dfPUMA <- htmltable[[1]]
write.csv(dfPUMA, file = "dfPUMA.csv")
rm("url", "html", "htmltable")

#Race1
#Race1 PUMS code data is stored on the 14th Sheet, "A4:B19", col_names=T, na="."
dfRace1 <- read_xlsx("ACSPUMS2012_2016CodeLists.xlsx", sheet = 14, range = "A4:B19", col_names = T, na = ".")
dfRace1 <- dfRace1[complete.cases(dfRace1),]

#Race2
#Race2 PUMS code data is stored on the 15th Sheet, "A4:B72", col_names=T, na="."
dfRace2 <- read_xlsx("ACSPUMS2012_2016CodeLists.xlsx", sheet = 15, range = "A4:B72", col_names = T, na = ".")
dfRace2 <- dfRace2[complete.cases(dfRace2),]

#Race3
#Race3 PUMS code data is stored on the 16th Sheet, "A3:B103", col_names=T
dfRace3 <- read_xlsx("ACSPUMS2012_2016CodeLists.xlsx", sheet = 16, range = "A3:B103", col_names = T)
dfRace3 <- dfRace3[complete.cases(dfRace3),]