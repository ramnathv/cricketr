##########################################################################################
# Designed and developed by Tinniam V Ganesh
# Date : 26 Jun 2015
# Function : getPlayerData
# This function gets the data of batsman/bowler and returns the data frame. This data frame can
# stored for use in other functions
##########################################################################################
getPlayerData <- function(profile,dir="./data",file="player001.csv",type="batting",
                          homeOrAway=c(1,2),result=c(1,2,4)) {
    
    # Initial url to ""
    url <-""
    suburl1 <- "http://stats.espncricinfo.com/ci/engine/player/"
    suburl2 <-"?class=1;"
    suburl3 <- "template=results;"
    suburl4 <- "view=innings"
    
    # Create a profile.html with the profile number
    player <- paste(profile,".html",sep="")
    
    # Set the home or away
    str1=str2=""
    if(sum(homeOrAway == 1)==1){
        str1 ="home_or_away=1;"
    }
    if (sum(homeOrAway == 2)==1) {
        str2="home_or_away=2;"
    }
    HA<-paste(str1,str2,sep="")
    
    # Set the type batting or bowling
    t <- paste("type=",type,";",sep="");
    
    # Set the result based on input
    str1=str2=str3=""
    if(sum(result==1)==1){
        str1 ="result=1;"
    }
    if(sum(result==2)==1){
        str2 ="result=2;"
    }
    if(sum(result==4)==1){
        str3 ="result=4;"
    }
    result<- paste(str1,str2,str3,sep="")
    
    # Create composite URL
    url <- paste(suburl1,player,suburl2,HA,result,suburl3,t,suburl4,sep="")
    
    
    # Read the data from ESPN Cricinfo
    tables=readHTMLTable(url,stringsAsFactors = F)
    
    # Choose appropriate columns
    t <- tables$"Innings by innings list"
    
    if(type=="batting") {
        cols <- c(1:9,11,12,13)
    } else if (type=="bowling") {
        # Check if there are the older version of 8 balls per over (BPO) column
        n <- names(t)
        
        # Select BPO column for older bowlers
        if(n[2] =="BPO") {
            cols <- c(1:8,10,11,12)
        }
        else {
            cols <- c(1:7,9,10,11)
        }
    }
    
    s <- t[,cols]
    
    
    dir.create(dir,mode="0777",showWarnings=FALSE)
    file <-paste(dir,file,sep="/")
    
    file.create(file)
    
    # Write to file 
    write.csv(s,file=file)
    
    # Return the data frame
    s
    
}