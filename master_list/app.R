#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(shinythemes)

library(googlesheets)
library(tidyverse)
library(leaflet)

## Global

ptm <- read_csv("ptm_clean.csv")

genetic <- ptm[1:13]
meta <- cbind(ptm[1:2],ptm[15:27])

# meta_gps <- meta %>% 
#   filter(!is.na(Latitude)) %>% 
#   mutate(Latitude = as.numeric(Latitude),
#          Longitude = as.numeric(Longitude))

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Martone Lab - Master List"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
        #date range selector
        radioButtons("phylum", 
                  label = h3("Red/Green/Brown"),
                  choices = list("red" = "Red",
                                 "coralline" = "Coralline",
                                 "green" = "Green",
                                 "brown" = "Brown"),
                  selected = 1),
        
        hr(),
        fluidRow(column(3, verbatimTextOutput("value"))),
        
        
        #Final Determination
        textInput("sp", label = h3("Final Determination")),
        
        # PTM
        sliderInput("num", h3("PTM"),
                    min = 0, max = length(ptm$`PTM#`), value = c(25, 75)),
        
        #Download Button
        downloadButton("downloadData", "Download"),
        
        #Date range
        dateInput("date", 
                  h3("Date range"), 
                  value = "2014-01-01")
        
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
        # Table view of master list
        h3("Genetics"),
         DT::dataTableOutput("gen_view"),
         h3("Metadata"),
         tableOutput("meta_view"),
         leafletOutput("distribution")
         
      )
   )
)


server <- function(input, output) {

      # # generate tables of genetics and meta data
      # output$gen_view <- DT::renderDataTable(DT::datatable({
      #   if(!is.null(input$sp) && input$sp != ""){
      #     genetic <- filter(genetic, 
      #                       input$sp == genetic$`Final determination`)
      #   }
      #   genetic <- filter(genetic,
      #                 genetic$`PTM#` <= input$num[2],
      #                 genetic$`PTM#` >= input$num[1])
      #   genetic
      #   
      # }))
  query <-  function(df){
    if(!is.null(input$sp) && input$sp != ""){
    df <- filter(df, 
                  input$sp == df$`Final determination`)
  }
  
  df <- filter(df,
                df$`PTM#` <= input$num[2],
                df$`PTM#` >= input$num[1])
  return(df)}
  
  output$gen_view <- DT::renderDataTable(DT::datatable({
       
      query(ptm)
        
      }))
      
      # output$meta_view <-  DT::renderDataTable(DT::datatable({
      #   if(!is.null(input$sp) && input$sp != ""){
      #     meta <- filter(meta, 
      #                       input$sp == meta$`Final determination`)
      #   }
      #   meta <- filter(meta,
      #                     meta$`PTM#` <= input$num[2],
      #                     meta$`PTM#` >= input$num[1])
      #   meta
      #   
      # }))
      
      #render map
      output$distribution <- renderLeaflet({
        gps <- query(ptm)
        meta_gps <- gps %>% 
          filter(!is.na(Latitude)) %>% 
          mutate(Latitude = as.numeric(Latitude),
                 Longitude = as.numeric(Longitude))
        
        map <- leaflet( data = meta_gps) %>%
          addProviderTiles("CartoDB") %>%
          addCircleMarkers(lng = meta_gps$Longitude, lat = meta_gps$Latitude,
                           popup = paste(meta_gps$Locality, meta_gps$`PTM#`, "Lat", meta_gps$Latitude,
                                         "Long", meta_gps$Longitude),
                           clusterOptions = markerClusterOptions()) %>% 
          addEasyButton(easyButton( icon = htmltools::span(class = "star", 
                                                           htmltools::HTML("&starf;")),
                                    onClick = JS("function(btn, map){ map.setZoom(1);}")))
        
        map
      })
      
      # Downloadable csv of selected dataset ----
      output$downloadData <- downloadHandler(
        filename = function() {
          paste(input$dataset, ".csv", sep = "")
        },
        content = function(file) {
          write.csv(datasetInput(), file, row.names = FALSE)
        }
      )
      
}

# Run the application 
shinyApp(ui = ui, server = server)

