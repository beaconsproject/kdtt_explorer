# KDTT Data Explorer

Updated: July 23, 2024

Shiny app for exploring various datasets in the KDTT region.

The app is located at: https://beaconsproject.shinyapps.io/disturbance_explorer

The app can also be run from a local machine using the following steps (note, the first 2 steps only need to be run once):

1.  Install R (download from [r-project.org](https://www.r-project.org/) and follow instructions)
2.  Install the following additional packages:

```         
install.packages(c("sf","leaflet","tidyverse","shinydashboard","shinycssloaders","shinyjs"))
```

3.  Start the Shiny app:

```         
shiny::runGitHub("beaconsproject/kdtt_explorer")
```