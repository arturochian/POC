library(plyr)
library(rCharts)
library(dplyr)
library(stringr)
library(shiny)
library(googleVis)
library(RODBC)

options(shiny.maxRequestSize=25*1024^2)
options(stringsAsFactors=FALSE)
#options(shiny.reactlog=TRUE)

suppressPackageStartupMessages(library(googleVis))

load.csv <- function (filename,foldername = NULL) {
  #assumption csv always comes with header
  filetype <- '.csv'
  df <- data.frame()
  if(!is.null(foldername)){
    foldername <- paste0(foldername,'/')
  }
  str <- paste(foldername,filename,filetype,sep='')
  headset <- read.csv(str, nrows = 10)
  classes <- sapply(headset,class)
  df <- read.csv(str,stringsAsFactors=FALSE,colClasses=classes,strip.white=TRUE)
  return(df)
}



dat <<- load.csv('ps','data')
data2 <<- load.csv('demandchange','data')
data2$Date <- as.Date(data2$Date, format='%m/%d/%Y')
src <- data.frame()



#values <- reactiveValues()
#tags$head(tags$script(src = 'http://d3js.org/d3.v3.min.js')),