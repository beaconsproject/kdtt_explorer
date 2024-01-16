library(sf)
library(leaflet)
library(tidyverse)
library(shinydashboard)
library(shinycssloaders)
library(shinyjs)

options(shiny.maxRequestSize=100*1024^2) 

ui = dashboardPage(skin="blue",
    dashboardHeader(title = "BEACONs Disturbance Explorer", titleWidth=320),
    dashboardSidebar(
        sidebarMenu(id="tabs",
            menuItem("Mapview", tabName = "mapview", icon = icon("th")),
            selectInput("gpkg", label="Select geopackage:", choices=c('kdtt','kdtt_subset'), selected='kdtt_subset')
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
                      checkboxInput('x3', label='Burned areas', value=F),
                      checkboxInput('x4', label='Fire polygons', value=F),
                      disabled(checkboxInput('x5', label='Footprint (500m)', value=F)),
                      disabled(checkboxInput('x6', label='Intactness (500m)', value=F)),
                      strong("Potential disturbances"),
                      checkboxInput('x9', label='Quartz Claims', value=F),
                      checkboxInput('x10', label='Placer Claims', value=F),
                      strong("Miscellaneous"),
                      checkboxInput('x11', label='Caribou herds (YT)', value=F),
                      checkboxInput('x12', label='Caribou herds (BC)', value=F),
                      checkboxInput('x13', label='Elk Takhini Valley', value=F),
                      checkboxInput('x14', label='Moose Key Areas', value=F),
                      checkboxInput('x15', label='Thinhorn Sheep', value=F),
                      checkboxInput('x16', label='Chinook Spawning - Major', value=F),
                      checkboxInput('x17', label='Chinook Spawning - Minor', value=F),
                      checkboxInput('x18', label='Key Wetlands 2011', value=F))
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
      addMeasure(position="bottomleft", primaryLengthUnit="meters", primaryAreaUnit="sqmeters", activeColor="#3D535D", completedColor = "#7D4479")
      grps <- NULL
      for(i in st_layers(paste0('www/',input$gpkg,'.gpkg'))$name) {
        x <- st_read(paste0('www/',input$gpkg,'.gpkg'), i, quiet=T) %>% st_transform(4326)
        if (i %in% c('KDTT','FLPR')) {m <- m %>% addPolygons(data=x, color='black', fill=F, weight=2, group=i)}
        else if (i=='Linear disturbances') {
          pop = ~paste("Industry type:", TYPE_INDUSTRY, "<br>Disturbance type:", TYPE_DISTURBANCE)
          m <- m %>% addPolylines(data=x, color='orange', weight=2, group=i, popup=pop)
        }
        else if (i=='Areal disturbances') {
          pop = ~paste("Industry type:", TYPE_INDUSTRY, "<br>Disturbance type:", TYPE_DISTURBANCE)
          m <- m %>% addPolygons(data=x, fill=T, stroke=F, fillColor='darkorange', fillOpacity=0.5, group=i, popup=pop)
        }
        else if (i=='Burned areas') {
          pop = ~paste("Year of fire:", Year, "<br>Area of fire (ha):", round(Area_ha,1), "<br>Area in KDTT (ha):", round(Area_in_kdtt,1))
          m <- m %>% addPolygons(data=x, fill=T, stroke=F, fillColor='red', fillOpacity=0.5, group=i, label=~Year, popup=pop)
        }
        else if (i=='Caribou (YT)') {
          pop = ~paste("Herd:", HERD, "<br>Type:", Type)
          m <- m %>% addPolygons(data=x, fill=T, stroke=F, fillColor='red', fillOpacity=0.5, group=i, label=~HERD, popup=pop)
        }
         else if (i=='Caribou (BC)') {
          pop = ~paste("Herd:", HERD_NAME, "<br>Type:", ECOTYPE)
          m <- m %>% addPolygons(data=x, fill=T, stroke=F, fillColor='red', fillOpacity=0.5, group=i, label=~HERD_NAME, popup=pop)
        }
       else if (i=='CPCAD 2021') {
          pop = ~paste("Name:", NAME_E, "<br>Aichi target:", AICHI_T11, "<br>IUCN category:", IUCN_CAT, "<br>OECM:", OECM, "<br>Protected date:", PROTDATE)
          m <- m %>% addPolygons(data=x, fill=T, stroke=F, fillColor='darkgreen', fillOpacity=0.5, group=i, popup=pop)
        }
        else {m <- m %>% addPolygons(data=x, color='red', fill=T, weight=1, group=i)}
        grps <- c(grps,i)
      }
      m <- m %>% 
      addLayersControl(position = "topright",
        baseGroups=c("Esri.WorldTopoMap", "Esri.WorldImagery"),
        overlayGroups = grps[1],
        options = layersControlOptions(collapsed = FALSE)) %>%
      hideGroup(c(grps[-1]))
    m
  })

}
shinyApp(ui, server)
