# create redirect URL
# appnames: vector of shiny apps user are distributed to
# baseurl: Full URL of the directory with shiny apps, trailing slash must be added

makeRedirect <- function(appnames, baseurl) {
  CPU <- read.table("/var/shiny-server/Data/CPU.txt") # 
  App <- data.frame(app = appnames)
  App <- merge(App, CPU, all.x = TRUE)
  App$usr[which(is.na(App$usr))] <- 0
  return(paste(baseurl, App$app[which.min(App$usr)],"/", sep = ""))
}


shinyServer(function(input, output, session) {
 
  output$link <- renderUI({
  list(
       # Input that holds the redirect URL
       textInput(inputId = "url", label = "", value = makeRedirect(
                                                                   c("app_1","app_2"),
                                                                   "http://servername.com/")),
       # JavaScript for redirecting
       tags$script(type="text/javascript", src = "/shiny-redirect.js")
  )
  })
})
 
