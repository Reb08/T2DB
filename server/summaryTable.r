# ----------------------------------------- Summary table -------------------------------------------------
library(tableHTML)

output$summary_table <- renderTable({
  
  studyInput_mutated() %>% count(Significance)
  
})  
