library(sf)
library(leaflet)
library(tidyverse)
library(shinydashboard)
library(shinycssloaders)
library(shinyjs)
options(shiny.maxRequestSize=100*1024^2) 

ui = dashboardPage(skin="blue",
  dashboardHeader(title = "KDTT Explorer", titleWidth=320),
  dashboardSidebar(
    sidebarMenu(id="tabs",
      menuItem("Explorer", tabName = "mapview", icon = icon("th"))#,
    )
  ),
  dashboardBody(
    useShinyjs(),
    tags$head(tags$style(".skin-blue .sidebar a { color: #8a8a8a; }")),
    tabItems(
      tabItem(tabName="mapview",
        fluidRow(
          tabBox(id = "one", width="12",
            tabPanel("Mapview", leafletOutput("map1", height=750) %>% withSpinner())
          ),
        )
      )
    )    
  )
)

server = function(input, output, session) {
  gpkg <- 'www/kdtt.gpkg'
  z <- readr::read_csv('www/layers.csv')

  output$map1 <- renderLeaflet({
    x0 <- st_read(gpkg, 'KDTT', quiet=T) %>% st_transform(4326)
    x00 <- st_read(gpkg, 'LAFN718 planning area', quiet=T) %>% st_transform(4326)
    grps <- NULL
    m <- leaflet() %>%
      addProviderTiles("Esri.WorldImagery", group="Esri.WorldImagery") %>%
      addProviderTiles("Esri.WorldTopoMap", group="Esri.WorldTopoMap") %>%
      addPolygons(data=x0, color='black', fill=F, weight=2, group='KDTT') %>%
      addPolygons(data=x00, color='blue', fill=F, weight=2, group='LAFN718 planning area')
      for (i in z$map[3:nrow(z)]) {
        x1 <- st_read(gpkg, i, quiet=T) %>% st_transform(4326)
        lbl <- pull(x1, z$label[z$map==i])
        if (z$type[z$map==i]=='poly') {
          m <- m %>% addPolygons(data=x1, fill=z$fill[z$map==i], stroke=z$stroke[z$map==i], fillColor=z$fillColor[z$map==i], fillOpacity=z$fillOpacity[z$map==i], group=i, popup=~lbl)
        } else {
          m <- m %>% addPolylines(data=x1, color=z$color[z$map==i], weight=z$weight[z$map==i], group=i, popup=~lbl)
        }
          grps <- c(grps, i)
      }
      m <- m %>% addLayersControl(position = "topright",
        baseGroups=c("Esri.WorldTopoMap", "Esri.WorldImagery"),
        overlayGroups = c('KDTT', 'LAFN718 planning area', grps),
        options = layersControlOptions(collapsed = FALSE)) %>%
        hideGroup(grps)
    m
  })
}
shinyApp(ui, server)
