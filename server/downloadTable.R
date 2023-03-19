#-------------------------------------------------table download------------------------------------------------------
datasetInput <- reactive({
  # Fetch the appropriate data object, depending on the value of input$dataset.
  
  switch(input$dataset,
         "GSE154416" = GSE164414_All,
         "GSE115601" = GSE115601_All,
         "GSE175988" = GSE175988_All)
})

output$table2 <- DT::renderDataTable(
  DT::datatable({
    datasetInput()
    
  }, options=list(scrollX=TRUE)))

output$downloadData <- downloadHandler(
  
  # This function returns a string which tells the client browser what name to use when saving the file.
  filename = function() {
    paste(input$dataset, input$filetype, sep = ".")
  },
  
  # This function should write data to a file given to it by the argument 'file'.
  content = function(file) {
    sep <- switch(input$filetype, "csv" = ",", "tsv" = "\t")
    
    # Write to a file specified by the 'file' argument
    write.table(datasetInput(), file, sep = sep,
                row.names = FALSE)
  }
)