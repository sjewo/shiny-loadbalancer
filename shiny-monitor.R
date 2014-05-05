# Shiny App for for Load Balancing
# Source: http://withr.me/blog/2014/04/30/a-shiny-app-serves-as-shiny-server-load-balancer/
# by Huidong Tian
# some changes by Sebastian Jeworutzki (github.com/sjewo)

PATH <- "var/shiny-server/www"
setwd("/var/shiny-server/Data")

while (TRUE) {
    dat <- tryCatch(readLines(pipe("top -n 1 -b -u shiny","r")),
                    error=function(e) NA)
    id <- grep("R *$", dat)
    Names <- strsplit(gsub("^ +|%|\\+", "", dat[7]), " +")[[1]]
    if (length(id) > 0) {
        # 'top' data frame;
        L <- strsplit(gsub("^ *", "", dat[id]), " +")
        dat <- data.frame(matrix(unlist(L), ncol = 12, byrow = T))
        names(dat) <- Names
        dat <- data.frame(Time = Sys.time(), dat[, -ncol(dat)], usr = NA, app = NA)
        dat$CPU <-as.numeric(as.character(dat$CPU))
        dat$MEM <-as.numeric(as.character(dat$MEM))
        # Check if connection number changed;
        for (i in 1:length(dat$PID)) {
            PID <- dat$PID[i]
            netstat <- readLines(pipe(paste("sudo netstat -p | grep", PID), "r"))
            lsof <- readLines(pipe(paste0("sudo lsof -p", PID, "| grep /",PATH),"r"))
            dat$usr[i] <- tryCatch(length(grep("VERBUNDEN", netstat) & grep("tcp", netstat)), 
                                   error=function(e) NA)
            dat$app[i] <- tryCatch(regmatches(lsof, regexec(paste0(PATH,"/(.*)"), lsof))[[1]][2],
                                   error=function(e) NA)
        }
        dat <- dat[, c("app", "usr")]
    } else {
        dat <- data.frame(app = "app", usr = 0)
    }
    write.table(dat, file = "CPU.txt")
}
