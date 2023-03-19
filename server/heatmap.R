#----------------------------------- heatmap ------------------------------------------------------

# creates list with all the dataframe (which contain read counts) I will be using for the plot (depending on selected study and comparison)
data_list <- list(GSE164414_IGT_CTRL, GSE164414_IGT_T2D, GSE164414_IGT_T3cD, GSE164414_T2D_CTRL, GSE164414_T3cD_CTRL, GSE164414_T3cD_T2D,
                  GSE115601_DG_CTRL, GSE115601_DC_CTRL, GSE115601_DG_DC, GSE115601_IG_CTRL, GSE115601_IG_DG, GSE115601_IG_DC, 
                 GSE175988_CTRL_LPS_CTRL_U, GSE175988_D_LPS_CTRL_LPS, GSE175988_D_LPS_CTRL_U, GSE175988_D_LPS_D_U, GSE175988_D_U_CTRL_LPS, GSE175988_D_U_CTRL_U)


# select correct dataframe to use for plot based on selected study and comparison 
df_index <- reactive({
  
  req(input$study, input$comparison)
  
  default_study <- "GSE164416"
  default_comparison <- "IGT vs Control"
  
  switch(paste(input$study, input$comparison, sep = "_"),
         "GSE164416_IGT vs Control" = 1,
         "GSE164416_IGT vs T2D" = 2,
         "GSE164416_IGT vs T3cD" = 3,
         "GSE164416_T2D vs Control" = 4,
         "GSE164416_T3cD vs Control" = 5,
         "GSE164416_T3cD vs T2D" = 6,
         "GSE115601_Diabetic_Gastroparetics vs Control" = 7,
         "GSE115601_Diabetic_Non-Gastroparetics vs Control" = 8,
         "GSE115601_Diabetic_Gastroparetics vs Diabetic_Non-Gastroparetics" = 9,
         "GSE115601_Idiopathic_Gastroparetics vs Control" = 10,
         "GSE115601_Idiopathic_Gastroparetics vs Diabetic_Gastroparetics" = 11,
         "GSE115601_Idiopathic_Gastroparetics vs Diabetic_Non-Gastroparetics" = 12,
         "GSE175988_Control_LPS vs Control_Unstimulated" = 13,
         "GSE175988_Diabetic_LPS vs Control_LPS" = 14,
         "GSE175988_Diabetic_LPS vs Control_Unstimulated" = 15,
         "GSE175988_Diabetic_LPS vs Diabetic_Unstimulated" = 16,
         "GSE175988_Diabetic_Unstimulated vs Control_LPS" = 17,
         "GSE175988_Diabetic_Unstimulated vs Control_Unstimulated" = 18)
})


selected_df <- reactive({
  data_list[[df_index()]]
})


# add column indicating wether the gene is an up- or down- regulated protein-coding gene or lncRNA
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
  return(filtered_data)
})  


# further subset data based on whether user chooses to display protein-coding genes or lncRNAs genes
heatmap_data_subset <- reactive({
  if(input$gene_type2 == "lncRNA genes"){
    heatmap_data()[heatmap_data()$Biotype=="lncRNA",]
  } else {
    heatmap_data()[heatmap_data()$Biotype=="protein_coding",]
  }
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
