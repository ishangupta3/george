/*

rm(list=ls())

library(ggplot2)
library(changepoint)


setwd("/Users/ishgupta/desktop/currentDataScript/data")

#df <- read.csv("dataAugust17thData_Everything.csv")
#df <- read.csv("data/August17-18_Everything.csv")
df <- read.csv("9/11Data_Everything.csv")

df <- df[order(df$userID, df$timestamp),]






df$timestamp <- df$timestamp
#df$time <- anytime(df$timestamp)

df$time <- as.POSIXct(df$timestamp, origin="1970-01-01")
df$date <- as.character(as.Date(df$time))
df$hour <- as.numeric(format(df$time, "%H"))



U <- unique(df$userID)
for (u in U)
{
    
    df.u <- df[df$userID == u,]
    
    
    D <- unique(df.u$date)
    
    for (d in D)
    {
        
        #keep data between 11:00-2:00
        df.u.d <- df.u[df.u$date == d  & df.u$hour >= 11 & df.u$hour < 15,]
        
        #keep only the first 10 minutes
        df.u.d$duration <- df.u.d$timestamp - df.u.d$timestamp[1]
        df.u.d <- df.u.d[df.u.d$duration <= 20 *60,]
        
        
        
        if(dim(df.u.d)[1] > 0)
        {
            
            #compute minute
            #df.u.d$bin <- cut(df.u.d$time, breaks="60 sec", labels=FALSE)
            
            
            
            
            if (0)
            {
                # #shift the time stamps by 1
                N <- dim(df.u.d)[1]
                df.u.d[2:N, "timestamp"] <- df.u.d[1:(N-1), "timestamp"]
                # delete first row
                df.u.d <- df.u.d[2:N,]
                df.u.d[,"datetime"] <- NULL
                
                #recompute time
                df.u.d$time <- as.POSIXct(df.u.d$timestamp, origin="1970-01-01")
            }
            
            
            
            df.plot <- data.frame()
            
            #find the max station + filer out singe readings
            L <- unique(df.u.d$location)
            locations.score  <- rep(-200, length(L))
            
            msg <- sprintf("%s--%s", u,d)
            plot(df.u.d$time, df.u.d$RSSI, type="b", main=msg, col="black")
            
            colors <- c("red", "green", "blue", "yellow")
            
            i <- 1
            for(l in L)
            {
                df.u.d.l <- df.u.d[df.u.d$location==l,]
                
                #msg <- sprintf("%s--%s--%s", u,d, l)
                #plot(df.u.d.l$time, df.u.d.l$RSSI, type="b", main=msg, col="red")
                
                if (0)
                {
                    # #shift the time stamps by 1
                    N <- dim(df.u.d.l)[1]
                    df.u.d.l[2:N, "timestamp"] <- df.u.d.l[1:(N-1), "timestamp"]
                    # delete first row
                    df.u.d.l <- df.u.d.l[2:N,]
                    df.u.d.l[,"datetime"] <- NULL
                    
                    #recompute time
                    df.u.d.l$time <- as.POSIXct(df.u.d.l$timestamp, origin="1970-01-01")
                }
                
                if(0)
                {
                    # compute recency
                    x1 <- df.u.d.l$timestamp
                    x2 <- x1
                    N <- length(x1)
                    x3<- x1[2:N] - x2[1:(N-1)]
                    x3<-c(0, x3)
                    
                    df.u.d.l$recency <- x3
                    #df.u.d.l<-df.u.d.l[df.u.d.l$recency <=10,]
                }
                df.plot <- rbind(df.plot, df.u.d.l)
                
                #msg <- sprintf("%s--%s--%s", u,d, l)
                lines(df.u.d.l$time, df.u.d.l$RSSI, type="b", col=colors[i])
                
                i <- i+1
                
                locations.score[l] <- max(df.u.d[df.u.d$location==l,]$RSSI)
            }
            
            max.location <- names(which.max(locations.score))
            
            
            
            plt <- ggplot(df.plot, aes(time,RSSI)) + geom_point(aes(colour = location))
            #plt <- plt + geom_smooth(aes(colour = location))
            #plt <-  plt + stat_smooth(method = "lm", formula = y ~ x, size = 1, aes(colour = location))
            #plt <-  plt + geom_smooth(method = "lm", formula = y ~ x, size = 1, aes(colour = location))
            #plt <- plt + stat_smooth(method = "lm", formula = y ~ x + I(x^2), size = 1, aes(colour = location))
            #plt <- plt  + stat_smooth(method = "lm", formula = y ~ poly(x, 2), aes(colour = location))
            #plt <- plt  + stat_smooth(method = "gam", formula = y ~ s(x), size = 1, aes(colour = location))
            
            
            msg <- sprintf("%s--%s--best:%s", u,d, max.location)
            plt + labs(x = "Time", y = "RSSI", title=msg)
            
            fname <-sprintf("plots/%s--%s.pdf", u,d)
            ggsave(fname, device = "pdf")
            
            
        }
    }
}

 
 */
