library(shiny)
library(ggplot2)
library(dplyr)
library(pheatmap)
library(RColorBrewer)
library(clusterProfiler)
library(org.Hs.eg.db)
library(AnnotationDbi)
library(shinycssloaders)
library(shinyWidgets)
library(shinyjs)
library(DT)
library(tibble)
library(shinydashboard)
library(UpSetR)
library(tableHTML)
library(data.table)


################### Helper function #############################################

footerHTML <- function() {  # defines style of the footer
  "
    <footer class='footer' style='background-color: #2C3E50; color: white; height: 1cm; display: flex; justify-content: center; align-items: center;'>
      <div>
        <span style='margin: 0;'>T2DB © 2023 Copyright:</span>
        <a href='http://heartlncrna.github.io' target='_blank'>heartlncrna</a>
        <span>&nbsp</span>
        <a href='https://github.com/Bishop-Laboratory/FibroDB/' target='_blank'> 
          <img src='GitHub-Mark-Light-64px.png' height='20'>
      </div>
    </footer>
  "
}


# colors used in heatmap
mypalette <- brewer.pal(11,"RdYlBu")
morecols <- colorRampPalette(mypalette)


################### Load data #############################################

GSE115601 <- data.frame(fread("data/GSE115601-All.txt"))  # used for main table in Explore Tab
GSE115601_All <- data.frame(fread("data/GSE115601-All_Samples.txt"))  # used for Download tab

# data for heatmap
GSE115601_DG_CTRL <- data.frame(fread("data/GSE115601-gastroparesis-Unstranded-diabetic_gastroparetics_vs_Control-CPM.txt"), row.names = 1)
GSE115601_DG_DC <- data.frame(fread("data/GSE115601-gastroparesis-Unstranded-diabetic_gastroparetics_vs_diabetic_non-gastroparetics-CPM.txt"), row.names = 1)
GSE115601_DC_CTRL <- data.frame(fread("data/GSE115601-gastroparesis-Unstranded-diabetic_non-gastroparetics_vs_Control-CPM.txt"), row.names= 1)
GSE115601_IG_CTRL <- data.frame(fread("data/GSE115601-gastroparesis-Unstranded-idiopathic_gastroparetics_vs_Control-CPM.txt"), row.names = 1)
GSE115601_IG_DG <- data.frame(fread("data/GSE115601-gastroparesis-Unstranded-idiopathic_gastroparetics_vs_diabetic_gastroparetics-CPM.txt"), row.names = 1)
GSE115601_IG_DC <- data.frame(fread("data/GSE115601-gastroparesis-Unstranded-idiopathic_gastroparetics_vs_diabetic_non-gastroparetics-CPM.txt"), row.names = 1)



GSE175988 <- data.frame(fread("data/GSE175988-All.txt"))
GSE175988_All <- data.frame(fread("data/GSE175988-All_Samples.txt"))

# data for heatmap
GSE175988_CTRL_LPS_CTRL_U <- data.frame(fread("data/GSE175988-PBMC-Stranded-Control-LPS_vs_Control-Unstimulated-CPM.txt"), row.names = 1)
GSE175988_D_LPS_CTRL_LPS <- data.frame(fread("data/GSE175988-PBMC-Stranded-Diabetic_LPS_vs_Control_LPS-CPM.txt"), row.names = 1)
GSE175988_D_LPS_CTRL_U <- data.frame(fread("data/GSE175988-PBMC-Stranded-Diabetic_LPS_vs_Control_Unstimulated-CPM.txt"), row.names = 1)
GSE175988_D_LPS_D_U <- data.frame(fread("data/GSE175988-PBMC-Stranded-Diabetic_LPS_vs_Diabetic_Unstimulated-CPM.txt"), row.names = 1)
GSE175988_D_U_CTRL_LPS <- data.frame(fread("data/GSE175988-PBMC-Stranded-Diabetic_Unstimulated_vs_Control_LPS-CPM.txt"), row.names = 1)
GSE175988_D_U_CTRL_U <- data.frame(fread("data/GSE175988-PBMC-Stranded-Diabetic_Unstimulated_vs_Control_Unstimulated-CPM.txt"), row.names = 1)




GSE164414 <- data.frame(fread("data/GSE164414-All.txt")) # used for main table in Explore Tab
GSE164414_All <- data.frame(fread("data/GSE164416-All_Samples.txt"))  # used for Download tab

# data for heatmap
GSE164414_IGT_CTRL <- data.frame(fread("data/GSE164416-pancreatic_islets-Unstranded-IGT_vs_Control-CPM.txt"), row.names = 1)
GSE164414_IGT_T2D <- data.frame(fread("data/GSE164416-pancreatic_islets-Unstranded-IGT_vs_T2D-CPM.txt"), row.names = 1)
GSE164414_IGT_T3cD <- data.frame(fread("data/GSE164416-pancreatic_islets-Unstranded-IGT_vs_T3cD-CPM.txt"), row.names = 1)
GSE164414_T2D_CTRL <- data.frame(fread("data/GSE164416-pancreatic_islets-Unstranded-T2D_vs_Control-CPM.txt"), row.names = 1)
GSE164414_T3cD_CTRL <- data.frame(fread("data/GSE164416-pancreatic_islets-Unstranded-T3cD_vs_Control-CPM.txt"), row.names = 1)
GSE164414_T3cD_T2D <- data.frame(fread("data/GSE164416-pancreatic_islets-Unstranded-T3cD_vs_T2D-CPM.txt"), row.names = 1)

########################################### shiny app ########################################


ui <- fluidPage(
  
  useShinyjs(),
  
  tags$head(
    tags$link(rel = "stylesheet", href = "https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css"), # allows use of icons
    tags$style(  # details position of footer
      HTML("
           html {
           position: relative;
           min-height: 100%;
           }
           
           body {
           margin-bottom: 1cm;
           padding-bottom: 20px; /* add margin to the top */
           }
           
           .footer {
           position: absolute;
           bottom: 0;
           width: 100%;
           background-color: #2C3E50;
           color: white;
           height: 1cm;
           display: flex;
           justify-content: center;;
           align-items: center;
           }
        ")
    )
  ),
  
  theme = bslib::bs_theme(bootswatch = "flatly"),
  
  navbarPage("T2DB",  
             
             source(file.path("ui", "HomePanel.R"), local=TRUE)$value,
             source(file.path("ui", "ExplorePanel.R"), local=TRUE)$value,
             source(file.path("ui", "DownloadPanel.R"), local=TRUE)$value,
             source(file.path("ui", "DocumentationPanel.R"), local=TRUE)$value
             
  ),
  
  
  tags$footer(HTML(footerHTML()))
  
) # end Fluid Page



server <- function(input, output, session) {
  
  # change the options for the "comparison" drop down menu (in ExplorePanel.R) based on the study selected in the "study" drop down menu (in ExplorePanel.R)
  comparisons <- reactive({
    if(input$study == "GSE164416"){
      c("IGT vs Control", "IGT vs T2D", "IGT vs T3cD", "T2D vs Control", "T3cD vs Control", "T3cD vs T2D")
    } else if (input$study == "GSE115601"){
      c("Diabetic_Gastroparetics vs Control", 
        "Diabetic_Non-Gastroparetics vs Control", 
        "Diabetic_Gastroparetics vs Diabetic_Non-Gastroparetics",
        "Idiopathic_Gastroparetics vs Control",
        "Idiopathic_Gastroparetics vs Diabetic_Gastroparetics",
        "Idiopathic_Gastroparetics vs Diabetic_Non-Gastroparetics")
    } else {
      c("Control_LPS vs Control_Unstimulated",
        "Diabetic_LPS vs Control_LPS",
        "Diabetic_LPS vs Control_Unstimulated",
        "Diabetic_LPS vs Diabetic_Unstimulated",
        "Diabetic_Unstimulated vs Control_LPS",
        "Diabetic_Unstimulated vs Control_Unstimulated")
    }
  })
  
  observeEvent(input$study, {
    updateSelectInput(
      session,
      inputId = "comparison",
      label = "Select Comparison",
      choices = comparisons(),
      selected = comparisons()[1]
    )
  })
  
  
  # load data 
  studyInput <- reactive({
    if(input$study == "GSE164416"){
      GSE164414
    } else if (input$study == "GSE115601"){
      GSE115601
    } else {
      GSE175988
    }
  })
  
  
  # add new column to data that will indicate whether the gene is a up or down-regulated lncRNA or protein coding gene. This will be used to subset the data later on
  studyInput_mutated <- reactive({
    studyInput()[studyInput()$Comparison == input$comparison, ] %>%
      mutate(
        Significance = case_when(
          logFC >= input$FC & FDR < input$FDR & Biotype == "protein_coding" ~ "Up-reg protein-coding gene",
          logFC >= input$FC & FDR < input$FDR & Biotype == "lncRNA" ~ "Up-reg lncRNA",
          logFC <= -input$FC & FDR < input$FDR & Biotype == "protein_coding" ~ "Down-reg protein-coding gene",
          logFC <= -input$FC & FDR < input$FDR & Biotype == "lncRNA" ~ "Down-reg lncRNA",
          TRUE ~ "Unchanged"))
  })
  
  # allow user to select a row in table
  selected_row <- reactive({
    data.frame(Ensembl.Gene.ID = character(),
               Gene.Symbol = character(),
               logFC = numeric(),
               FDR = numeric(),
               Biotype = character(),
               Significance = character())
  })
  
  observeEvent(input$table_rows_selected, {
    row_index <- input$table_rows_selected
    row_name <- studyInput_mutated()[row_index, "Gene.Symbol"]
    updateSelectInput(session, "gene", choices = row_name, selected=row_name[1])  
  })
  
  selected_row <- reactive({
    row_name <- input$gene
    if (!is.null(row_name)) {
      studyInput_mutated()[studyInput_mutated()$Gene.Symbol == row_name, ]
    } else {
      data.frame(Ensembl.Gene.ID = character(),
                 Gene.Symbol = character(),
                 logFC = numeric(),
                 FDR = numeric(),
                 Biotype = character(),
                 Significance = character())
    }
  })
  
  source(file.path("server", "mainTable.R"), local=TRUE)$value
  source(file.path("server", "summaryTable.R"), local=TRUE)$value
  source(file.path("server", "volcanoPlot.R"), local=TRUE)$value
  source(file.path("server", "heatmap.R"), local=TRUE)$value
  source(file.path("server", "GOanalysis.R"), local=TRUE)$value
  source(file.path("server", "keggPlot.R"), local=TRUE)$value
  source(file.path("server", "upsetPlot.R"), local=TRUE)$value
  source(file.path("server", "downloadTable.R"), local=TRUE)$value
  
}


shinyApp(ui, server)










