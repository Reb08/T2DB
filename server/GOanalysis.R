# ----------------------------------------------Go Analysis-------------------------------------------------------

# subset data based on whether the user has chosen to look at up- or down-regulated genes
Go_analysis_data <- reactive({
  studyInput_dt <- data.table(studyInput_mutated())
  
  if(input$expression == "up-regulated genes"){
    data <- studyInput_dt[Significance %in% c("Up-reg protein-coding gene", "Up-reg lncRNA"),Ensembl.Gene.ID]
  } else {
    data <- studyInput_dt[Significance %in% c("Down-reg protein-coding gene", "Down-reg lncRNA"),Ensembl.Gene.ID]
  }
  
  data <- as.data.table(data)
  
  on.exit(rm(data))
  on.exit(rm(studyInput_dt))
  return(data)

})


# perform gene ontolofy analysis using gprofiler and select only teh results related to gene ontology

GO_results <- reactive({
  
  if(nrow(Go_analysis_data()) != 0){
  gostres <- gost(query = Go_analysis_data()$data, organism = "hsapiens", correction="fdr")
  
  if(!is.null(gostres)) {
    sources <- c("GO:BP", "GO:MF", "GO:CC")
    result <- gostres$result[gostres$result$source %in% sources, ]
    meta <- gostres$meta
    meta$query_metadata$sources <- c("GO:MF", "GO:CC", "GO:BP")
    res <- list(result, meta)
    names(res) <- c("result", "meta")
    
    on.exit(rm(res))
    
    return(res)
  } else {
    return(NULL)
  }
  }
})


# ------------------------------------------ Plot ------------------------------------------------- 

output$GO <- renderPlot({
  
  tryCatch({
    
    if(is.null(GO_results())) {
      message <- "Sorry, no enough DEGs identified"
      plot.new()
      text(0.3, 0.9, message, cex = 1.1)
    } else {
      gostplot(GO_results(), capped = F, interactive = F) +
        theme(axis.title.x = element_text(size=2),
              axis.title.y = element_text(size=18),
              axis.text = element_text(size=15),
              axis.text.x = element_text(size=17),
              plot.title=element_text(size=18))
    }
  },
  error = function(e){
    if(grepl("Error in gost: Missing query", e$message)) {
      message <- "Sorry, no enough DEGs identified"
    } else if (grepl("cannot coerce type 'closure' to vector of type 'character'", e$message)){
      message <- "Sorry, no enough DEGs identified"
    }
    
    plot.new()
    text(0.5, 0.5, message, cex = 1.)
  })
  
})


# ------------------------------------------ Table ------------------------------------------------- 

output$GO_table <- DT::renderDataTable({
  
  if(!is.null(GO_results())) {
    my_table <- GO_results()$result[, c("source", "term_name", "term_size", "query_size", "intersection_size", "p_value")]
    my_table$p_value <- format(round(my_table$p_value, digits = 5), nsmall=5)
    my_table$id <- 1:nrow(my_table)
      
    DT::datatable(
      my_table[, c("id", "source", "term_name", "term_size", "query_size", "intersection_size", "p_value")],
      options = list(lengthMenu = c(3, 10, 20), pageLength = 3, scrollX=T),
      rownames=FALSE)
    }
})
