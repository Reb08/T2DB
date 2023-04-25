studyInput_lncRNA <- reactive({
  if(input$study_lncRNA == "GSE175988"){
    data <- data.frame(fread("data/GSE176988-All_lncRNAs.txt"))
  } else if (input$study_lncRNA == "GSE115601"){
    data <- data.frame(fread("data/GSE115601-All_lncRNAs.txt"))
  } else {
    data <- data.frame(fread("data/GSE164416-All_lncRNAs.txt"))
  }
  
  on.exit(rm(data))
  
  return(data)
})



# change the options for the "comparison" drop down menu (in ExplorePanel.R) based on the study selected in the "study" drop down menu (in ExplorePanel.R)
comparisons_lncRNA <- reactive({
  if(input$study_lncRNA == "GSE175988"){
    c("LPS_vs_Control-Unstimulated",
      "Diabetic_LPS_vs_Control_LPS",
      "Diabetic_LPS_vs_Control_Unstimulated" ,
      "Diabetic_LPS_vs_Diabetic_Unstimulated",
      "Diabetic_Unstimulated_vs_Control_LPS",
      "Diabetic_Unstimulated_vs_Control_Unstimulated")
  } else if (input$study_lncRNA == "GSE115601"){
    c("diabetic_gastroparetics_vs_Control", 
      "diabetic_gastroparetics_vs_diabetic_non-gastroparetics",
      "idiopathic_gastroparetics_vs_Control",
      "idiopathic_gastroparetics_vs_diabetic_gastroparetics",
      "idiopathic_gastroparetics_vs_diabetic_non-gastroparetics")
  } else {
    c("IGT_vs_Control", "IGT_vs_T2D", "T2D_vs_Control", "T3cD_vs_Control", "T3cD_vs_T2D")
  }
})

observeEvent(input$study_lncRNA, {
  updateSelectInput(
    session,
    inputId = "comparison_lncRNA",
    label = "Select Comparison",
    choices = comparisons_lncRNA(),
    selected = comparisons_lncRNA()[1]
  )
})

my_table <- reactive({
  
  data <- studyInput_lncRNA()[studyInput_lncRNA()$Comparison == input$comparison_lncRNA, ] # only displays genes that belong to the right comparisons
  
  on.exit(rm(data))
  
  return(data)
  
})


output$downloadlncRNATable <- downloadHandler(
  
  
  # This function returns a string which tells the client browser what name to use when saving the file.
  filename = function() {
    paste(input$study_lncRNA, "-", input$comparison_lncRNA,"-lncRNA_table.tsv", sep = "")
  },
  
  # This function should write data to a file given to it by the argument 'file'.
  content = function(file) {
    
    # Write to a file specified by the 'file' argument
    write.table(my_table(), file,
                row.names = FALSE, quote=F, sep="\t")
  }
)


output$table_lncRNA <- DT::renderDataTable({
  
  DT::datatable(
    my_table()[, c("Ensembl.Gene.ID", "Gene.Symbol", "logFC", "FDR", "LncBook.ID", "Type", "Conservation", "nearest.PC", "Top.correlated.gene")],
    selection = list(mode="single", selected=1),  # allows user to select only one row at a time
    options = list(lengthMenu = c(5, 10, 50), pageLength = 5, scrollX=T, rowHeight=10),
    rownames=FALSE
  )
})


selected_row2<- reactive({
  req(input$table_lncRNA_rows_selected)
  my_table()[input$table_lncRNA_rows_selected, ]
})

# render the right-hand output
output$selected_row_miRNA <- renderPrint({
  t <- selected_row2()$miRNA
  formatted_t <- gsub(",", "\n", t)
  cat(formatted_t)
  
  #cat(selected_row()$miRNA)
})

output$selected_row_GWAS <- renderPrint({
  t <- selected_row2()$GWAS
  formatted_t <- gsub(",", "\n", t)
  formatted_t2 <- gsub(";", "\n", formatted_t)
  cat(formatted_t2) 
})



