# RDataProject
R Data Project - Group 3 - Data Programming in R, Cedar Rapids, Fall 2018
# Group Members
Matthew Bare, Francisco Olalde, Clarke Pietruszka, Alejandro Samaniego, Marc Santucci, Michelle Wichman, Mark Wilson



# Roadmap of working directory files
#./RDataProject.Rproj
#./Part1A/datadownload.R
ACS 5-Yr PUMS data download and cleaning is found in Part1A folder, entirely contained within the datadownload.R file. This was our original attempt at getting and cleaning data. Part1B folder contains rest related files.
*datadownload.R uses the folder containing RDataProject.Rproj as the working directory.
#./Part2/Part2_Search_Script.R
This contains our R script to complete the second part of the project. Part2_Search_Script.R requires the file Salary_Information_for_State_Authorities_NY.csv
*Part2_Search_Script.R uses the folder containing RDataProject.Rproj as the working directory.

#The following is a separate Rproject, submitted separately. 
#./index.Rproj
This contains R Project file used to download data from API's and display data/results within a Shiny App. To run shiny application, click "Run App" when inside the app.R, server.R, or ui.R files.
index.RProj uses the folder it is contained in, Part1B, as it's working directory.
*Application is using packrat for control version
*If not used correctly the application won't run.
*If the library has incorrect versions the application won't run.
**These roadmap instructions are also included in Part1B/README.txt



# Introduction to PUMS of ACS
https://www.census.gov/programs-surveys/acs/guidance/training-presentations/acs-intro-pums.html
# PUMS Technical Documentation: 5yr, 2012-2016
https://www.census.gov/programs-surveys/acs/technical-documentation/pums/documentation.2016.html
# Health Insurance Statistics: Available APIs
https://www.census.gov/data/developers/data-sets/Health-Insurance-Statistics.html
# SAHIE Program
https://www.census.gov/programs-surveys/sahie.html
# SAHIE File Layouts
https://www.census.gov/programs-surveys/sahie/technical-documentation/file-layouts.html