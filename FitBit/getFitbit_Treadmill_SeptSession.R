## Do the following before using code:
## 1. Register developer account with Fitbit: https://dev.fitbit.com
## 2. Read Fitbit API documentation https://dev.fitbit.com/build/reference/web-api/
## 3. Register an app via Fitbit developer account. Can use most functional website as the call back site.
## 4. Decide which authorization flow to use. Implicit Grant Flow allows up to 1 year.
## 5. Once app is set up, click on OAuth 2.0 tutorial page and follow each heart of the page.
## 6. If using 1 year authorization via Implicit Grant Flow, make sure change the time frame to 31536000, other numbers will defalt to 1 day.
## 7. Ask each user to click on the link and authorise, then obtain API token.
## 8. Store API tokens securely. Example below stores API token securely elsewhere and reads it in.


library(data.table)
library(curl)
library(httr)
library(rjson)
library(ggplot2)

## Read in API tokens. Currently I store this under 3 variables:
## ID, FitbitAPI, Expires

API <- fread("API_TA.csv")

## Code below checks status of token, look at "Status", can check error code on Fitbit API documentation
## check_state <- function(token = NULL) {
##   POST(url = 'https://api.fitbit.com/1.1/oauth2/introspect',
##        add_headers(Authorization = paste0('Bearer ', token)),
##        body = paste0('token=', token),
##        content_type('application/x-www-form-urlencoded'))
## }
## check_state(token = FitbitAPI)

## Below function gets just the sleep data between StartDate and EndDate.
## Check Fitbit API documentation if all available sleep data, or if other data
## (e.g., activity, diet etc) are to be retrieved. Modify url format accordingly.s


all_token<-API$FitbitAPI
all_subIDs<-API$ID
colname_data<-c("time","d01","d02","d03","d04","d05","d06","d07","d08","d09","d10",
                  "d11","d12","d13","d14","d15","d16","d17","d18","d19","d20",
                  "d21","d22","d23","d24","d25","d26","d27","d28","d29","d30","d31")
for (sub in c(3:length(all_subIDs))) {
  startDay<-as.Date("2020-09-01")
    
  token<-all_token[sub]
  subIDs<-all_subIDs[sub]
  print(paste0('... PROCESSING: ',subIDs))
  for (day in c(0:30)){
    ThisDate<-startDay+day
    x <- GET(url =
               paste0("https://api.fitbit.com/1.2/user/-/activities/steps/date/",
                      ThisDate, "/1d.json"),
             add_headers(Authorization = paste0("Bearer ", token)))
    tryCatch(Sys.sleep(3), error = function(e) e)
    mycontents<-content(x)
    stepraw<-mycontents$'activities-steps-intraday'
    if (length(stepraw$dataset)>0){
      steplist<-stepraw$dataset
      stepmatrix<-matrix(unlist(steplist),ncol=2,byrow=TRUE)
      tmptime<-as.numeric(as.POSIXct(strptime(stepmatrix[,1], "%H:%M:%S")))
      tmptime<-(tmptime-tmptime[1])/60
      tmpvalue<-as.numeric(stepmatrix[,2])
      stepmatrix<-matrix(nrow=1440,ncol=2)
      stepmatrix[,1]<-(0:1439)
      #as.numeric(as.POSIXct(strptime(stepmatrix[,1], "%H:%M:%S")))
      for (k in (1:length(tmptime))) {
        stepmatrix[stepmatrix[,1]==tmptime[k],2]<-as.numeric(tmpvalue[k])
      }
      if (day==0) {
        allstepmatrix<-stepmatrix
      }
      else {
        allstepmatrix<-cbind(allstepmatrix,stepmatrix[,2])
      }
    }
    else { allstepmatrix<-cbind(allstepmatrix,rep(NA,1440)) }
  }
  allstep<-as.data.frame(allstepmatrix)
  dims<-dim(allstep)
  avstep<-data.frame(matrix(ncol = 3, nrow = dims[1]))
  avstep[,1]<-as.numeric(allstep[,1])
  avstep[,1]<-(avstep[,1]-avstep[1,1])/60
  for (time in c(1:dims[1])){
    avstep[time,2]<-mean(as.numeric(allstep[time,2:dims[2]]))
    avstep[time,3]<-sd(as.numeric(allstep[time,2:dims[2]]))/sqrt(dims[2]-1)
  }
  colnames(avstep)<-c("time","mean","SE")
  colnames(allstep)<-colname_data
  
  ##Graph with Standard Error 
  #ggplot(avstep, aes(x = time, y = mean)) + geom_point() + geom_line() + ylab("Step Count") + xlab("Time (h)") + geom_ribbon(aes(ymin = mean-SE, ymax = mean+SE), alpha = .35, linetype = 0)
  
  
  ##
  for (day in c(0:30)){
    ThisDate<-startDay+day
    x <- GET(url =
               paste0("https://api.fitbit.com/1.2/user/-/activities/heart/date/",
                      ThisDate, "/1d.json"),
             add_headers(Authorization = paste0("Bearer ", token)))
    mycontents<-content(x)
    heartraw<-mycontents$'activities-heart-intraday'
    if (length(heartraw$dataset)>0){
      heartlist<-heartraw$dataset
      heartmatrix<-matrix(unlist(heartlist),ncol=2,byrow=TRUE)
      tmptime<-as.numeric(as.POSIXct(strptime(heartmatrix[,1], "%H:%M:%S")))
      tmptime<-(tmptime-tmptime[1])/60
      tmpvalue<-as.numeric(heartmatrix[,2])
      heartmatrix<-matrix(nrow=1440,ncol=2)
      heartmatrix[,1]<-(0:1439)
      #as.numeric(as.POSIXct(strptime(heartmatrix[,1], "%H:%M:%S")))
      for (k in (1:length(tmptime))) {
        heartmatrix[heartmatrix[,1]==tmptime[k],2]<-as.numeric(tmpvalue[k])
      }
      if (day==0) {
        allheartmatrix<-heartmatrix
      }
      else {
        allheartmatrix<-cbind(allheartmatrix,heartmatrix[,2])
      }
    }
    else { allheartmatrix<-cbind(allheartmatrix,rep(NA,1440)) }
  }
  allheart<-as.data.frame(allheartmatrix)
  dims<-dim(allheart)
  avheart<-data.frame(matrix(ncol = 3, nrow = dims[1]))
  avheart[,1]<-as.numeric(allheart[,1])
  avheart[,1]<-(avheart[,1]-avheart[1,1])/60
  for (time in c(1:dims[1])){
    avheart[time,2]<-mean(as.numeric(allheart[time,2:dims[2]]),na.rm=TRUE)
    avheart[time,3]<-sd(as.numeric(allheart[time,2:dims[2]]),na.rm=TRUE)/sqrt(dims[2]-1)
  }
  colnames(avheart)<-c("time","mean","SE")
  colnames(allheart)<-colname_data
  
  write.csv(allheart,paste0("treadmill_fitbit_september2020_heartbeat_",
                               subIDs, ".csv"))
  write.csv(allstep,paste0("treadmill_fitbit_september2020_step_",
                            subIDs, ".csv"))
  ##Graph with Standard Error 
  #ggplot(avheart, aes(x = time, y = mean)) + geom_point() + geom_line() + ylab("heart Count") + xlab("Time (h)") + geom_ribbon(aes(ymin = mean-SE, ymax = mean+SE), alpha = .35, linetype = 0)
}
