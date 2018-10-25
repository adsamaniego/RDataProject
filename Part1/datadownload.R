###Download zipped files, unzip, extract csv files
#URL to each .zip
#urlh <- "https://www2.census.gov/programs-surveys/acs/data/pums/2016/5-Year/csv_hia.zip"
#urlp <- "https://www2.census.gov/programs-surveys/acs/data/pums/2016/5-Year/csv_pia.zip"
#Create temporary files to store .zip in
#temph <- tempfile()
#tempp <- tempfile()
#Download .zip files, store in temporary files
#download.file(urlh, destfile = temph)
#download.file(urlp, destfile = tempp)
#unzip temporary file, extracting desired csv, csv saved in working directory
#Get dataframes from csv
#dfh <- read.csv(unzip(temph, "ss16hia.csv", exdir = "./Part1"))
#dfp <- read.csv(unzip(tempp, "ss16pia.csv", exdir = "./Part1"))
#Remove unnecessary objects
#rm(urlh, urlp, temph, tempp)
###Just Read in already downloaded files
dfh <- read.csv("./Part1/ss16hia.csv")
dfp <- read.csv("./Part1/ss16pia.csv")


###Download excel containing PUMS Code List, read in dataframes (some manually)
#url to 2012-2016 PUMS Code List
#url <- "https://www2.census.gov/programs-surveys/acs/tech_docs/pums/code_lists/ACSPUMS2012_2016CodeLists.xlsx"
#Download excel file, read in as binary?
#download.file(url, destfile = "ACSPUMS2012_2016CodeLists.xlsx", mode="wb")
#rm(url)

#Ancestry
#Read excel file, ancestry codes stored on 1st sheet, store in data frame
#Clean read by specifying relevant data range, A3:B584, col_names in first row, na="."
library(readxl)
#dfAncestry <- read_xlsx("ACSPUMS2012_2016CodeLists.xlsx", sheet = 1, range = "A3:B584", col_names = T, na = ".")
#dfAncestry <- dfAncestry[complete.cases(dfAncestry),]

#DegreeField
#Field of Degree codes stored on 2nd sheet, A4:B195, col_names in first row, na="."
#dfDegreeField <- read_xlsx("ACSPUMS2012_2016CodeLists.xlsx", sheet = 2, range = "A4:B195", col_names = T, na = ".")
#dfDegreeField <- dfDegreeField[complete.cases(dfDegreeField),]

#GroupQuarters
#Group Quarters codes stored on 4th sheet, A4:B29, col_names in first row
#Possible to skip 5th (Institutional description) and 21st (non-Institution description) row?
#No, delete afterwards.
#dfGroupQuarters <- read_xlsx("ACSPUMS2012_2016CodeLists.xlsx", sheet = 4, range = "A4:B29", col_names = T)
#dfGroupQuarters <- dfGroupQuarters[c(2:16,18:25),]

#Hispanic
#Hispanic Origin codes stored on 5th sheet, A4:B90, col_names in first row, na="."
#dfHispanic <- read_xlsx("ACSPUMS2012_2016CodeLists.xlsx", sheet = 5, range = "A4:B90", col_names = T, na = ".")
#dfHispanic <- dfHispanic[complete.cases(dfHispanic),]

#Industry
#Goes with variable INDP
#Industry codes stored on 6th sheet, B2:D20, col_names = False, na="."
#dfIndustry <- read_xlsx("ACSPUMS2012_2016CodeLists.xlsx", sheet = 6, range = "B2:D20", col_names = F, na = ".")
#Cannot be read in and understood, will do manually
#CodesLowerLimit <- c("0010", "0570", "0770", "1070", "4070", "4670", "6070", "6470", "6870", "7270", "7860", "8560", "8770", "9370", "9670")
#CodesUpperLimit <- c("0560", "0760", "1060", "4060", "4660", "6060", "6460", "6860", "7260", "7790", "8490", "8690", "9290", "9590", "9890")
#Description <- c("Agriculture, Forestry, Fishing and Hunting, and Mining",
#                 "Transportation, Warehousing, and Utilities",
#                 "Construction",
#                 "Manufacturing",
#                 "Wholesale Trade",
#                 "Retail Trade",
#                 "Transportation, Warehousing, and Utilities",
#                 "Information",
#                 "Finance, Insurance, Real Estate, and Rental & Leasing",
#                 "Professional, Scientific, Management, Administrative, and Waste Management Services",
#                 "Educational Services, Health Care, and Social Assistance",
#                 "Arts, Entertainment, & Recreation, and Accomodation & Food Services",
#                 "Other Services (except Public Administration)",
#                 "Public Administration",
#                 "Active Duty Military")
#dfIndustry <- data.frame(CodesLowerLimit)
#dfIndustry[,2] <- CodesUpperLimit
#dfIndustry[,3] <- Description
#rm("CodesLowerLimit", "CodesUpperLimit", "Description")
#colnames(dfIndustry) <- c("Code Lower Limit", "Code Upper Limit", "PUMS Industry Description")

#Language
#Language codes are stored on 7th sheet, A3:B1336, col_names=T, na="."
#dfLanguage <- suppressWarnings(read_xlsx("ACSPUMS2012_2016CodeLists.xlsx", sheet = 7, range = "A3:B1336", col_names = T, na = "."))
#Error message in loading "9500 (HHLANP)", supposed to be found in dfLanguage[1252,1], just manually enter number before complete.cases
#dfLanguage[1252,1] <- 9500
#dfLanguage <- dfLanguage[complete.cases(dfLanguage),]

#MigrationPUMA
##Not completely sure how this data is different than PUMA data downloaded separately
#Migration PUMA coding data is stored in 8th sheet, D4:F4764, col_names=T
#dfMigrationPUMA <- read_xlsx("ACSPUMS2012_2016CodeLists.xlsx", sheet = 8, range = "D4:F4764", col_names = T)
#dfMigrationPUMA <- dfMigrationPUMA[complete.cases(dfMigrationPUMA),]

#MigrationStCntry
#Migration State/Country coding data is stored in 9th sheet, A2:B332, col_names=T, na="."
#dfMigrationStCntry <- read_xlsx("ACSPUMS2012_2016CodeLists.xlsx", sheet = 9, range = "A2:B332", col_names = T, na = ".")
#dfMigrationStCntry <- dfMigrationStCntry[complete.cases(dfMigrationStCntry),]

#Occupation
#Goes with variable OCCP
#Occupation data is not stored in a table format, will do manually
<<<<<<< HEAD
#CodesLowerLimit <- c("0010", "3600", "4700", "6000", "7700")
#CodesUpperLimit <- c("3540", "4650", "5940", "7630", "9750")
#Description <- c("Management, Business, Science, and Arts",
#                 "Service",
#                 "Sales and Office",
#                 "Natural Resources, Construction, and Maintenance",
#                 "Production, Transportation, and Material Moving")
#dfOCCP <- data.frame(CodesLowerLimit)
#dfOCCP[,2] <- CodesUpperLimit
#dfOCCP[,3] <- Description
#rm("CodesLowerLimit", "CodesUpperLimit", "Description")
#colnames(dfOCCP) <- c("Code Lower Limit", "Code Upper Limit", "PUMS Occupation Description")
=======
CodesLowerLimit <- c("0010", "3600", "4700", "6000", "7700")
CodesUpperLimit <- c("3540", "4650", "5940", "7630", "9750")
Description <- c("Management, Business, Science, and Arts Occupations",
                 "Service Occupations",
                 "Sales and Office Occupations",
                 "Natural Resources, Construction, and Maintenance Occupations",
                 "Production, Transportation, and Material Moving Occupations")
dfOCCP <- data.frame(CodesLowerLimit)
dfOCCP[,2] <- CodesUpperLimit
dfOCCP[,3] <- Description
rm("CodesLowerLimit", "CodesUpperLimit", "Description")
colnames(dfOCCP) <- c("Code Lower Limit", "Code Upper Limit", "PUMS Occupation Description")
>>>>>>> b5c3c66b1500f006cf09f6e094a1ebeb7a1e7aa0
#dfOCCP <- dfOCCP[complete.cases(dfOCCP),]

#POBirth
#Place of Birth code data is stored on 11th sheet, "A2:B332", col_names=T, na="."
#dfPOBirth <- read_xlsx("ACSPUMS2012_2016CodeLists.xlsx", sheet = 11, range = "A2:B332", col_names = T, na = ".")
#dfPOBirth <- dfPOBirth[complete.cases(dfPOBirth),]

#POWork
#Place of Work State/Country code data is stored on 12th sheet, "A2:B334", col_names=T, na="."
#dfPOWork <- read_xlsx("ACSPUMS2012_2016CodeLists.xlsx", sheet = 12, range = "A2:B334", col_names = T, na = ".")
#dfPOWork <- dfPOWork[complete.cases(dfPOWork),]

#POWPUMA
#Place of Work PUMA code data is stored on 13th Sheet, "E5:G42551", col_names=T
#dfPOWPUMA <- read_xlsx("ACSPUMS2012_2016CodeLists.xlsx", sheet = 13, range = "E5:G42551", col_names = T)
#dfPOWPUMA <- dfPOWPUMA[complete.cases(dfPOWPUMA),]

#PUMA
#Going to scrape data of (PUMA) Public Use Microdata Area codes for the state of Iowa
#Can be found on "https://www.census.gov/geo/maps-data/maps/2010puma/st19_ia.html"
#library(xml2)
#library(rvest)
#url <- "https://www.census.gov/geo/maps-data/maps/2010puma/st19_ia.html"
#html <- read_html(url)
#htmltable <- html_table(html, fill=T)
#Will save as dfPUMA within R, and save .csv file to OneDrive
#dfPUMA <- htmltable[[1]]
#write.csv(dfPUMA, file = "dfPUMA.csv")
#rm("url", "html", "htmltable")
###Read in already downloaded PUMA
dfPUMA <- read.csv("dfPUMA.csv", row.names = 1)
dfPUMA$Name = factor(dfPUMA$Name, levels(dfPUMA$Name)[c(15,3,2,1,21,7,4,14,9,8,10,18,20,12,13,5,16,11,22,17,19,6)])

#Race1
#Race1 PUMS code data is stored on the 14th Sheet, "A4:B19", col_names=T, na="."
#dfRace1 <- read_xlsx("ACSPUMS2012_2016CodeLists.xlsx", sheet = 14, range = "A4:B19", col_names = T, na = ".")
#dfRace1 <- dfRace1[complete.cases(dfRace1),]

#Race2
#Race2 PUMS code data is stored on the 15th Sheet, "A4:B72", col_names=T, na="."
#dfRace2 <- read_xlsx("ACSPUMS2012_2016CodeLists.xlsx", sheet = 15, range = "A4:B72", col_names = T, na = ".")
#dfRace2 <- dfRace2[complete.cases(dfRace2),]

#Race3
#Race3 PUMS code data is stored on the 16th Sheet, "A3:B103", col_names=T
#dfRace3 <- read_xlsx("ACSPUMS2012_2016CodeLists.xlsx", sheet = 16, range = "A3:B103", col_names = T)
#dfRace3 <- dfRace3[complete.cases(dfRace3),]


###Clean up dfh
#Remove unnecessary columns
<<<<<<< HEAD
dfh <- dfh[,c("SERIALNO", "PUMA", "ADJHSG", "ADJINC", "WGTP", "NP", "TYPE", "AGS", "BLD",
              "TEN", "VACS", "VALP", "FES", "FINCP", "HINCP", "HUPAC", "OCPIP", "WIF")]
=======
dfh <- dfh[,c("SERIALNO", "PUMA", "ADJHSG", "ADJINC", "WGTP", "NP", "TYPE", "AGS",
              "BLD", "BUS", "TEN", "VACS", "VALP", "FES", "FINCP", "HINCP", "HUPAC",
              "MV", "OCPIP", "WIF", "WKEXREL", "WORKSTAT")]
>>>>>>> b5c3c66b1500f006cf09f6e094a1ebeb7a1e7aa0
#Change column types
dfh$SERIALNO <- as.factor(dfh$SERIALNO)
dfh$PUMA <- as.factor(dfh$PUMA)
dfh$ADJHSG <- as.numeric(dfh$ADJHSG/1000000)
dfh$ADJINC <- as.numeric(dfh$ADJINC/1000000)
dfh$TYPE <- as.factor(dfh$TYPE)
dfh$AGS <- as.factor(dfh$AGS)
dfh$BLD <- as.factor(dfh$BLD)
dfh$TEN <- as.factor(dfh$TEN)
dfh$VACS <- as.factor(dfh$VACS)
dfh$FES <- as.factor(dfh$FES)
dfh$FINCP <- as.integer(dfh$FINCP*dfh$ADJINC)
dfh$HINCP <- as.integer(dfh$HINCP*dfh$ADJINC)
dfh$HUPAC <- as.factor(dfh$HUPAC)
dfh$OCPIP <- as.numeric(dfh$OCPIP/100)
dfh$WIF <- as.factor(dfh$WIF)
#Properly reading factors
#PUMA
levels(dfh$PUMA) <- levels(dfPUMA$Name)
#TYPE
levels(dfh$TYPE) <- c("Housing Unit", "Institutional Group Quarters", "Noninstitutional Group Quarters")
#AGS
dfh$AGS[is.na(dfh$AGS)] <- 1
levels(dfh$AGS) <- c("No", "Yes", "Yes", "Yes", "Yes", "Yes")
#BLD
levels(dfh$BLD) <- c("Mobile Home or Trailer", "One-Family House Detached", "One-Family House Attached", "2 Apartments",
                     "3-4 Apartments", "5-9 Apartments", "10-19 Apartments", "20-49 Apartments", "50+ Apartments", "Boat, RV, Van, etc.")
#TEN
levels(dfh$TEN) <- c("Owned with Mortgage or Loan", "Owned Free and Clear", "Rented", "Occupied without Payment of Rent")
#FES
levels(dfh$FES) <- c("Married - Both in LF", "Married - One in LF", "Married - One in LF",
                     "Married - None in LF", "Other - Male in LF", "Other - Male not in LF",
                     "Other - Female in LF", "Other - Female not in LF")
#HUPAC
levels(dfh$HUPAC) <- c("Children<6", "6<=Children<=17", "Both", "No Children")
#WIF
levels(dfh$WIF) <- c("0 Workers", "1 Worker", "2 Workers", "3+ Workers")


###Clean up dfp
#Remove unnecessary columns
dfp <- dfp[,c("SERIALNO", "PUMA", "ADJINC", "PWGTP", "AGEP", "COW", "DDRS", "DEAR", "DEYE",
              "DOUT", "DPHY", "DRATX", "DREM", "FER", "HINS1", "HINS2", "HINS3", "HINS4",
              "HINS5", "HINS6", "HINS7", "INTP", "OIP", "PAP", "RETP", "SEMP", "SEX", "SSIP",
<<<<<<< HEAD
              "SSP", "WAGP", "DIS", "ESR", "HICOV", "PERNP", "PINCP", "PRIVCOV", "PUBCOV")]
=======
              "SSP", "WAGP", "DIS", "ESR", "HICOV", "OCCP", "PERNP", "PINCP", "PRIVCOV", "PUBCOV")]
>>>>>>> b5c3c66b1500f006cf09f6e094a1ebeb7a1e7aa0
#Change column types
dfp$SERIALNO <- as.factor(dfp$SERIALNO)
dfp$PUMA <- as.factor(dfp$PUMA)
dfp$ADJINC <- as.numeric(dfp$ADJINC/1000000)
dfp$COW <- as.factor(dfp$COW)
dfp$DDRS <- as.factor(dfp$DDRS)
dfp$DEAR <- as.factor(dfp$DEAR)
dfp$DEYE <- as.factor(dfp$DEYE)
dfp$DOUT <- as.factor(dfp$DOUT)
dfp$DPHY <- as.factor(dfp$DPHY)
dfp$DRATX <- as.factor(dfp$DRATX)
dfp$DREM <- as.factor(dfp$DREM)
dfp$FER <- as.factor(dfp$FER)
dfp$HINS1 <- as.factor(dfp$HINS1)
dfp$HINS2 <- as.factor(dfp$HINS2)
dfp$HINS3 <- as.factor(dfp$HINS3)
dfp$HINS4 <- as.factor(dfp$HINS4)
dfp$HINS5 <- as.factor(dfp$HINS5)
dfp$HINS6 <- as.factor(dfp$HINS6)
dfp$HINS7 <- as.factor(dfp$HINS7)
dfp$INTP <- as.integer(dfp$INTP*dfp$ADJINC)
dfp$OIP <- as.integer(dfp$OIP*dfp$ADJINC)
dfp$PAP <- as.integer(dfp$PAP*dfp$ADJINC)
dfp$RETP <- as.integer(dfp$RETP*dfp$ADJINC)
dfp$SEMP <- as.integer(dfp$SEMP*dfp$ADJINC)
dfp$SEX <- as.factor(dfp$SEX)
dfp$SSIP <- as.integer(dfp$SSIP*dfp$ADJINC)
dfp$SSP <- as.integer(dfp$SSP*dfp$ADJINC)
dfp$WAGP <- as.integer(dfp$WAGP*dfp$ADJINC)
dfp$DIS <- as.factor(dfp$DIS)
dfp$ESR <- as.factor(dfp$ESR)
dfp$HICOV <- as.factor(dfp$HICOV)
dfp$PERNP <- as.integer(dfp$PERNP*dfp$ADJINC)
dfp$PINCP <- as.integer(dfp$PINCP*dfp$ADJINC)
dfp$PRIVCOV <- as.factor(dfp$PRIVCOV)
<<<<<<< HEAD
dfp$PUBCOV <- as.factor(dfp$PUBCOV)
#Properly reading factors
#PUMA
levels(dfp$PUMA) <- levels(dfPUMA$Name)
#COW
levels(dfp$COW) <- c("Employee, For-Profit", "Employee, Non-Profit", "Employee, Local Government",
                     "Employee, State Government", "Employee, Federal Government", "Self-Employed, Not Incorporated",
                     "Self-Employed, Incorporated", "Working W/O Pay, Family Business", "Unemployed")
#DDRS, DEAR, DEYE, DOUT, DPHY, DRATX, DREM, FER
levels(dfp$DDRS) <- c("Yes", "No")
levels(dfp$DEAR) <- c("Yes", "No")
levels(dfp$DEYE) <- c("Yes", "No")
levels(dfp$DOUT) <- c("Yes", "No")
levels(dfp$DPHY) <- c("Yes", "No")
levels(dfp$DRATX) <- c("Yes", "No")
levels(dfp$DREM) <- c("Yes", "No")
levels(dfp$FER) <- c("Yes", "No")
#HINS's
levels(dfp$HINS1) <- c("Yes", "No")
levels(dfp$HINS2) <- c("Yes", "No")
levels(dfp$HINS3) <- c("Yes", "No")
levels(dfp$HINS4) <- c("Yes", "No")
levels(dfp$HINS5) <- c("Yes", "No")
levels(dfp$HINS6) <- c("Yes", "No")
levels(dfp$HINS7) <- c("Yes", "No")
#SEX
levels(dfp$SEX) <- c("Male", "Female")
#DIS
levels(dfp$DIS) <- c("With a Disability", "Without a Disability")
#ESR
levels(dfp$ESR) <- c("Civilian Employed", "Civilian Employed", "Unemployed", "Armed Forces", 
                     "Armed Forces", "Not in Labor Force")
#HICOV, PRIVCOV, PUBCOV
levels(dfp$HICOV) <- c("With Health Insurance Coverage", "Without Health Insurance Coverage")
levels(dfp$PRIVCOV) <- c("With Private Coverage", "Without Private Coverage")
levels(dfp$PUBCOV) <- c("With Public Coverage", "Without Public Coverage")
=======
dfp$PUBCOV <- as.factor(dfp$PUBCOV)
>>>>>>> b5c3c66b1500f006cf09f6e094a1ebeb7a1e7aa0
