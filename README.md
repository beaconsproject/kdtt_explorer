# KDTT Data Explorer

Updated: July 23, 2024

Shiny app for exploring various datasets in the KDTT region.

The app is located at: https://beaconsproject.shinyapps.io/disturbance_explorer 

The app can also be run from a local machine using the following steps (note, the first 2 steps only need to be run once):

  1. Install R (download from [r-project.org](https://www.r-project.org/) and follow instructions)
  2. Install the following additional packages:

    install.packages(c("sf","leaflet","tidyverse","shinydashboard","shinycssloaders","shinyjs"))

  3. Start the Shiny app:

    shiny::runGitHub("beaconsproject/kdtt_explorer")


Available layers:
                                      layer_name     geometry_type features fields crs_name
1                                           KDTT     Multi Polygon        1      6   WGS 84
2                                     CPCAD 2021     Multi Polygon       43      5   WGS 84
3                             Caribou herds (YT)     Multi Polygon       14      8   WGS 84
4                             Caribou herds (BC)     Multi Polygon       13      4   WGS 84
5                                 Thinhorn sheep           Polygon        3     10   WGS 84
6                          LAFN718 planning area           Polygon        1      2   WGS 84
7                                    Draft IPCAs     Multi Polygon        3      2   WGS 84
8                          BC IPCA (DKK_May2023)     Multi Polygon        1      6   WGS 84
9                                  Fire polygons     Multi Polygon     1020      4   WGS 84
10                                  Burned areas     Multi Polygon      669      4   WGS 84
11                           Linear disturbances Multi Line String    24896      2   WGS 84
12                            Areal disturbances     Multi Polygon     5380      2   WGS 84
13                              Footprint (500m)     Multi Polygon        1      2   WGS 84
14                             Intactness (500m)     Multi Polygon        1      8   WGS 84
15                       Canada access 2010 (NT)     Multi Polygon        1      1   WGS 84
16                 KFRP Area Specific Management     Multi Polygon        8      1   WGS 84
17            KFRP Garden Creek Subregional Plan     Multi Polygon        1      1   WGS 84
18                KFRP General Forest Management     Multi Polygon        8      1   WGS 84
19 KFRP Gu Cha Duga-Kaska Cultural and Wildlands     Multi Polygon       12      1   WGS 84
20                           KFRP Local Planning     Multi Polygon        1      1   WGS 84
21                               KFRP Withdrawal     Multi Polygon       25      1   WGS 84
22                            KFRP Kaska FRP2008 Multi Line String        1      1   WGS 84
23                            Ross River LUP2014     Multi Polygon        1      2   WGS 84
