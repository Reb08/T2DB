# ----------------------------------------------Go Analysis-------------------------------------------------------

# subset data based on whether the user has chosen to look at up- or down-regulated genes
Go_analysis_data <- reactive({
  if(input$expression == "up-regulated genes"){
    studyInput_mutated()[studyInput_mutated()$Significance=="Up-reg protein-coding gene" | studyInput_mutated()$Significance== "Up-reg lncRNA",] %>% dplyr::pull(Ensembl.Gene.ID)
  } else {
    studyInput_mutated()[studyInput_mutated()$Significance=="Down-reg protein-coding gene" | studyInput_mutated()$Significance== "Down-reg lncRNA",] %>% dplyr::pull(Ensembl.Gene.ID)
  }
})

# perform gene ontology analysis using ClusterProfiler based on the selected GO terms (BP, MF or CC)
GO_results <- reactive({
  if(input$terms =="Biological Processes"){
    enrichGO(gene = Go_analysis_data(), OrgDb = "org.Hs.eg.db", keyType = "ENSEMBL", ont = "BP")
  } else if (input$terms =="Molecular Functions"){
    enrichGO(gene = Go_analysis_data(), OrgDb = "org.Hs.eg.db", keyType = "ENSEMBL", ont = "MF")
  } else{
    enrichGO(gene = Go_analysis_data(), OrgDb = "org.Hs.eg.db", keyType = "ENSEMBL", ont = "CC")
  }
})

# creates plot based on GO analysis results
output$GO <- renderPlot({
  tryCatch(
    {
      plot(barplot(GO_results(), showCategory=15), cex.lab=1.1)
    },
    error = function(e) {
      if (grepl("replacement has length zero", e$message)) {
        message <- "Sorry, no significantly enriched gene ontology terms for this category have been found"
      } else if (grepl("error in evaluating the argument 'x'", e$message)) {
        message <- "Sorry, no enough DEGs identified"
      }
      
      plot.new()
      text(0.5, 0.5, message, cex = 1.)
    })
  
})

#, height=514, width=800
