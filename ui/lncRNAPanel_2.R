tabPanel(title=HTML("<img src='rna.icon.png' style='height:15px; filter: invert(100%);'> lncRNAs"),
         
         titlePanel("Explore the lncRNAs"),
         
         sidebarLayout(
           
           position="left",
           fluid=T,
         
         mainPanel( width=7,
         #fluidRow(
           #column(8, 
                  
                  fluidRow(
                    column(6,
                           selectInput("study_lncRNA", h5("Select Study"),  # allow user to select study
                                       choices = list("GSE175988", "GSE115601", "GSE164416"),
                                       selected="GSE175988")),
                    column(6,
                           helpText("Select conditions to analyse within the selected study"),
                           selectInput("comparison_lncRNA", h5("Select Comparison"),  # allow user to select the comparisons to look at within a study. The options will be updated from NULL to teh right ones when the study is selected (see app.R)
                                       choices = NULL))
                  ),
                  
                  
                  br(),
                  fluidRow(
                    column(5,
                           titlePanel(h3("lncRNA Table")),
                           helpText("Annotated table of the differentially expressed lncRNAs (logFC > abs(1) & FDR < 0.05)")),
                    column(5,
                           div(tags$label(), style = "margin-bottom: 5px"),
                           div(downloadButton('downloadlncRNATable', 'Download', class = "btn-primary")),
                           helpText("Download lncRNA Table and lncRNA annotations in .tsv format"),
                           
                           tags$script(
                             "var downloadTimeout;
           $(document).on('click', '#downloadlncRNATable', function(){
             $('#downloadlncRNATable').removeClass('btn-primary').addClass('btn-success');
             var timeoutSeconds = input$study == 'GSE154416' ? 38 : 10;
             downloadTimeout = setTimeout(function(){
               $('#downloadlncRNATable').removeClass('btn-success').addClass('btn-primary');
             }, timeoutSeconds * 1000); // Change the button back to blue after the specified seconds
           });
           $(document).ajaxComplete(function(event, xhr, settings) {
             clearTimeout(downloadTimeout); // Clear the timeout when the download is complete
             $('#downloadlncRNATable').removeClass('btn-success').addClass('btn-primary');
           });
           ")
                           
                           ) # end column
                  ),
         
         
                  br(), 
                  fluidRow(
                    column(10,
                           DT::dataTableOutput("table_lncRNA") %>% withSpinner(color="#0dc5c1"))  # main table on the left hand side of Explore Tab
                  ),
                  
                  
           ), # end column
           
           sidebarPanel(h4("lncRNA Annotations"),
           #column(4,
                             
                             fluidRow(
                               column(10,
                                      h5("miRNA"),
                                      verbatimTextOutput("selected_row_miRNA"),
                                      tags$head(tags$style(HTML("#selected_row_miRNA{overflow-y:scroll; 
                                                                  height: 100px;
                                                                  width: 600px; 
                                                                  max-width: 100%;
                                                                  white-space: pre-wrap;
                                                                  padding: 6ps 12 px;}")))
                               ),
                               
                             ),
                             
                             fluidRow(
                               column(10,
                                      h5("GWAS"),
                                      verbatimTextOutput("selected_row_GWAS"),
                                      tags$head(tags$style(HTML("#selected_row_GWAS{overflow-y:scroll;
                                                                  height: 100px;
                                                                  width: 600px; 
                                                                  max-width: 100%;
                                                                  white-space: pre-wrap;
                                                                  padding: 6ps 12 px;}")))
                               ),
                               
                             ),
                             
           
         ) # end sidebarPanel
         
         )# end fluidRow
)# end sidebarLayout 
     