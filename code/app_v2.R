library(sf)
library(leaflet)
library(tidyverse)
library(shinydashboard)
library(shinycssloaders)
library(shinyjs)
source('global.R')
options(shiny.maxRequestSize=100*1024^2) 

ui = dashboardPage(skin="blue",
    dashboardHeader(title = "BEACONs Disturbance Explorer", titleWidth=320),
    dashboardSidebar(
        sidebarMenu(id="tabs",
            menuItem("Mapview", tabName = "mapview", icon = icon("th")),
            selectInput("gpkg", label="Select geopackage:", choices=c('kdtt','kdtt_subset'), selected='kdtt')
      )
    ),
  dashboardBody(
    useShinyjs(),
    tags$head(tags$style(".skin-blue .sidebar a { color: #8a8a8a; }")),
    tabItems(
      tabItem(tabName="mapview",
            fluidRow(
                tabBox(id = "one", width="9",
                    tabPanel("Mapview", leafletOutput("map1", height=750) %>% withSpinner())
                ),
                tabBox(
                    id = "two", width="3",
                    tabPanel("Select Layers", 
                      strong("Disturbances"),
                      #checkboxInput('x1', label='KDTT', value=T),
                      checkboxInput('x1', label='Linear disturbances', value=F),
                      checkboxInput('x2', label='Areal disturbances', value=F),
                      checkboxInput('x22', label='Canada access 2010', value=F),
                      checkboxInput('x3', label='Burned areas', value=F),
                      checkboxInput('x4', label='Fire polygons', value=F),
                      checkboxInput('x5', label='Footprint (500m)', value=F),
                      checkboxInput('x6', label='Intactness (500m)', value=F),
                      strong("Potential disturbances"),
                      checkboxInput('x9', label='Quartz Claims', value=F),
                      checkboxInput('x10', label='Placer Claims', value=F),
                      strong("Miscellaneous"),
                      checkboxInput('x11', label='Caribou herds (YT)', value=F),
                      checkboxInput('x12', label='Caribou herds (BC)', value=F),
                      disabled(checkboxInput('x13', label='Elk Takhini Valley', value=F)),
                      disabled(checkboxInput('x14', label='Moose Key Areas', value=F)),
                      disabled(checkboxInput('x15', label='Thinhorn Sheep', value=F)),
                      disabled(checkboxInput('x16', label='Chinook Spawning - Major', value=F)),
                      disabled(checkboxInput('x17', label='Chinook Spawning - Minor', value=F)),
                      disabled(checkboxInput('x18', label='Key Wetlands 2011', value=F)),
                      checkboxInput('x19', label='CPCAD 2021', value=F))
                )
            )
        )
    )
  )
)

server = function(input, output, session) {

  output$map1 <- renderLeaflet({
  
    m <- leaflet() %>%
      addProviderTiles("Esri.WorldImagery", group="Esri.WorldImagery") %>%
      addProviderTiles("Esri.WorldTopoMap", group="Esri.WorldTopoMap") %>%
      #addMeasure(position="bottomleft", primaryLengthUnit="meters", primaryAreaUnit="sqmeters", activeColor="#3D535D", completedColor = "#7D4479") %>%
      addPolygons(data=x0, color='black', fill=F, weight=2, group='KDTT') %>%
      addLayersControl(position = "topright",
        baseGroups=c("Esri.WorldTopoMap", "Esri.WorldImagery"),
        overlayGroups = 'KDTT',
        options = layersControlOptions(collapsed = FALSE)) %>%
        hideGroup('')
    m
  })

  observe({
    proxy <- leafletProxy("map1")
    grps1 <- NULL
    if (input$x1) {
      pop = ~paste("Industry type:", TYPE_INDUSTRY, "<br>Disturbance type:", TYPE_DISTURBANCE)
      proxy <- proxy %>% addPolylines(data=x1, color='orange', weight=2, group='Linear disturbances', popup=pop)
      grps1 <- c(grps1,'Linear disturbances')
    }
    if (input$x2) {
      pop = ~paste("Industry type:", TYPE_INDUSTRY, "<br>Disturbance type:", TYPE_DISTURBANCE)
      proxy <- proxy %>% addPolygons(data=x2, fill=T, stroke=F, fillColor='darkorange', fillOpacity=0.5, group='Areal disturbances', popup=pop)
      grps1 <- c(grps1,'Areal disturbances')
    }
    if (input$x3) { 
      pop = ~paste("Year of fire:", Year, "<br>Area of fire (ha):", round(Area_ha,1), "<br>Area in KDTT (ha):", round(Area_in_kdtt,1))
      proxy <- proxy %>% addPolygons(data=x3, fill=T, stroke=F, fillColor='red', fillOpacity=0.5, group='Burned areas', label=~Year, popup=pop)
      grps1 <- c(grps1,'Burned areas')
    }
    if (input$x4) { 
      pop = ~paste("Year of fire:", Year, "<br>Area of fire (ha):", round(Area_ha,1), "<br>Area in KDTT (ha):", round(Area_in_kdtt,1))
      proxy <- proxy %>% addPolygons(data=x4, fill=T, stroke=F, fillColor='orange', fillOpacity=0.5, group='Fire polygons', label=~Year, popup=pop)
      grps1 <- c(grps1,'Fire polygons')
    }
    if (input$x11) { 
      pop = ~paste("Herd:", HERD, "<br>Type:", Type)
      proxy <- proxy %>% addPolygons(data=x11, fill=T, stroke=F, fillColor='blue', fillOpacity=0.5, group='Caribou herds (YT)', label=~HERD, popup=pop)
      grps1 <- c(grps1,'Caribou herds (YT)')
    }
    if (input$x12) { 
      pop = ~paste("Herd:", HERD_NAME, "<br>Type:", ECOTYPE)
      proxy <- proxy %>% addPolygons(data=x12, fill=T, stroke=F, fillColor='green', fillOpacity=0.5, group='Caribou herds (BC)', label=~HERD_NAME, popup=pop)
      grps1 <- c(grps1,'Caribou herds (BC)')
    }
    if (input$x19) { 
      pop = ~paste(NAME_E, "<br>Established:", PROTDATE)
      proxy <- proxy %>% addPolygons(data=x19, fill=T, stroke=F, fillColor='darkgreen', fillOpacity=0.5, group='CPCAD 2021', label=~NAME_E, popup=pop)
      grps1 <- c(grps1,'CPCAD 2021')
    }
    proxy <- proxy %>% #addLayersControl(position = "topright",
    addLayersControl(position = "topright",
      baseGroups=c("Esri.WorldTopoMap", "Esri.WorldImagery"),
      overlayGroups = c('KDTT', grps1),
      options = layersControlOptions(collapsed = FALSE)) %>%
    hideGroup('')
  })

}
shinyApp(ui, server)
