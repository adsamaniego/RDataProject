#Download zipped files, unzip, extract csv files
#URL to each .zip
urlh <- "https://www2.census.gov/programs-surveys/acs/data/pums/2016/5-Year/csv_hia.zip"
urlp <- "https://www2.census.gov/programs-surveys/acs/data/pums/2016/5-Year/csv_pia.zip"
#Create temporary files to store .zip in
temph <- tempfile()
tempp <- tempfile()
#Download .zip files, store in temporary files
download.file(urlh, destfile = temph)
download.file(urlp, destfile = tempp)
#unzip temporary file, extracting desired csv, csv saved in working directory
#Get dataframes from csv
dfh <- read.csv(unzip(temph, "ss16hia.csv", exdir = "./Part1"))
dfp <- read.csv(unzip(tempp, "ss16pia.csv", exdir = "./Part1"))
#Remove unnecessary objects
rm(urlh, urlp, temph, tempp)
##Next to work on: Cleaning data when reading csv