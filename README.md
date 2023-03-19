# T2DB
Shiny app for exploring RNA-seq data from type II diabetes (T2D) patients analysed by *Distefano et al. 2023*.

To generate the data for this app, please see the steps in https://github.com/heartlncrna/Analysis_of_T2D_Studies.

## Run the app locally

 1. Start R
 
 2. Load the "Shiny" library package (install if not already available)
 ```
 library(shiny)
 
 install.packages("shiny") # ----- if not already installed
 ```
 
 3. Run App
 
 ```
 runGitHub(repo = "T2DB", username = "Reb08", ref = "main")
 ```
