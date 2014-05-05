shinyUI(bootstrapPage(
                      tags$style("#link {visibility: hidden;}"), #This app doesn't need user interface;
                      uiOutput("link") # Redirecting link;
                      )) 
