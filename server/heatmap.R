#----------------------------------- heatmap ------------------------------------------------------

file_lookup <- list(
  "Diabetic_Gastroparetics vs Control" = "GSE115601-diab_gastro_vs_ctrl.txt",
  "Diabetic_Gastroparetics vs Diabetic_Non-Gastroparetics" = "GSE115601-diab_gastro_vs_diab_non-gastro.txt",
  "Diabetic_Non-Gastroparetics vs Control" = "GSE115601-diab_non-gastro_vs_ctrl.txt",
  "Idiopathic_Gastroparetics vs Control" = "GSE115601-idiopathic_gastro_vs_ctrl.txt",
  "Idiopathic_Gastroparetics vs Diabetic_Gastroparetics" = "GSE115601-idiopathic_gastro_vs_diab_gastro.txt",
  "Idiopathic_Gastroparetics vs Diabetic_Non-Gastroparetics" = "GSE115601-idiopathic_gastro_vs_diab_non-gastro.txt",
  "Control_LPS vs Control_Unstimulated" = "GSE175988-ctrl-LPS_vs_ctrl-Unstim.txt",
  "Diabetic_LPS vs Control_LPS" = "GSE175988-Diab_LPS_vs_ctrl_LPS.txt",
  "Diabetic_LPS vs Control_Unstimulated" = "GSE175988-Diab_LPS_vs_ctrl_Unstim.txt",
  "Diabetic_LPS vs Diabetic_Unstimulated" = "GSE175988-Diab_LPS_vs_Diab_Unstim.txt",
  "Diabetic_Unstimulated vs Control_LPS" = "GSE175988-Diab_Unstim_vs_ctrl_LPS.txt",
  "Diabetic_Unstimulated vs Control_Unstimulated" = "GSE175988-Diab_Unstim_vs_ctrl_Unstim.txt",
  "IGT vs Control" = "GSE164416-IGT_vs_ctrl.txt",
  "IGT vs T2D" = "GSE164416-IGT_vs_T2D.txt",
  "IGT vs T3cD" = "GSE164416-IGT_vs_T3cD.txt",
  "T2D vs Control" = "GSE164416-T2D_vs_ctrl.txt",
  "T3cD vs Control" = "GSE164416-T3cD_vs_ctrl.txt",
  "T3cD vs T2D" = "GSE164416-T3cD_vs_T2D.txt"
)


# Get the file name based on the comparison choice
file_name <- reactive({
  file_lookup[[input$comparison]]
})  

selected_df <- reactive({
  # Get the file path based on the user input
  file_path <- file.path("data", file_name())
  
  # Load the data and cache it
  data <- data.frame(fread(file_path), row.names = 1)

  on.exit(rm(data))
  
  return(data)
})



# add column indicating whether the gene is an up- or down- regulated protein-coding gene or lncRNA
selected_df_mutated <- reactive({
  Sign <- case_when(
    selected_df()$logFC >= input$FC & selected_df()$FDR < input$FDR & selected_df()$Biotype == "protein_coding" ~ "Up-reg_Prot",
    selected_df()$logFC >= input$FC & selected_df()$FDR < input$FDR & selected_df()$Biotype == "lncRNA" ~ "Up-reg_lncRNA",
    selected_df()$logFC <= -input$FC & selected_df()$FDR < input$FDR & selected_df()$Biotype == "protein_coding" ~ "Down-reg_Prot",
    selected_df()$logFC <= -input$FC & selected_df()$FDR < input$FDR & selected_df()$Biotype == "lncRNA" ~ "Down-reg_lncRNA",
    TRUE ~ "Unchanged")
  
  cbind(Significance = Sign, selected_df())
})


# filter data to have only DEGs
heatmap_data <- reactive({
  filtered_data <- filter(selected_df_mutated(), Significance!="Unchanged")
  on.exit(rm(filtered_data))
  return(filtered_data)
})  


# further subset data based on whether user chooses to display protein-coding genes or lncRNAs genes
heatmap_data_subset <- reactive({
  if(input$gene_type2 == "lncRNA genes"){
    data <- heatmap_data()[heatmap_data()$Biotype=="lncRNA",]
  } else {
    data <- heatmap_data()[heatmap_data()$Biotype=="protein_coding",]
  }
  
  on.exit(rm(data))
  
  return(data)
})

# plot heatmap while catching errors that appear when there are no enough DEGs 
output$heatmap <- renderPlot({
  tryCatch(
    {
      pheatmap(heatmap_data_subset()[,11:(ncol(heatmap_data_subset()))],
               cluster_rows = T,
               cluster_cols = F,
               show_rownames = F,
               angle_col = "45",
               scale = "row",
               color = rev(morecols(100)),
               cex=1, 
               legend=T,
               main = input$comparison)
    }, 
    error = function(e) {
      if (grepl("must have n >= 2 objects to cluster", e$message)) {
        message <- "Sorry, no enough DEGs identified"
      } else if (grepl("'from' must be a finite number", e$message)) {
        message <- "Sorry, no enough DEGs identified"
      } 
      
      plot.new()
      text(0.5, 0.5, message, cex = 1.2)
      
    })
})
