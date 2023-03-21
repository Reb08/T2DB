# -------- Explore Panel -------

tabPanel(title=list(icon("binoculars"), "Explore"),
         
         titlePanel("Explore Results"),
         
         fluidRow(
           column(6,
                  
                  fluidRow(
                    column(6,
                           selectInput("study", h5("Select Study"),  # allow user to select study
                                       choices = list("GSE175988", "GSE115601", "GSE164416"),
                                       selected="GSE175988")),
                    column(6,
                           helpText("Select conditions to analyse within the selected study"),
                           selectInput("comparison", h5("Select Comparison"),  # allow user to select the comparisons to look at within a study. The options will be updated from NULL to teh right ones when the study is selected (see app.R)
                                       choices = NULL))
                  ),
                  
                  fluidRow(
                    column(3, align="center",
                           numericInput("FC",
                                        h5("Select logFC threshold"),  # allow user to log2FC threshold value
                                        value=1)),
                    
                    column(3, align="center",
                           numericInput("FDR",   
                                        h5("Select FDR threshold"),   # allow user to FDR threshold value
                                        value=0.05)),
                    
                  ),
                  
                  br(),
                  titlePanel(h3("Result Table")),
                  helpText("RNA-sequencing analysis results"),
                  fluidRow(
                    column(9,
                           DT::dataTableOutput("table") %>% withSpinner(color="#0dc5c1"))  # main table on the left hand side of Explore Tab
                  ),
                  
           ), # end column
           
           column(6,
                  tabsetPanel(
                    tabPanel("Volcano Plot", h3("Volcano Plot"),
                             helpText("Volcano plot showing differentially expressed genes from the selected study and comparison" 
                             ),
                             br(),
                             br(),
                             
                             fluidRow(
                               column(1,
                                      hidden(selectInput("gene", "Select a gene from the table:", choices = NULL))),  # this will allow user to select a specific row form the table (choices updated in app.R)
                               
                               column(10, align = "right",
                                      tableOutput("summary_table"))  # count matrix on the right had side of volcanoPlot tab which shows number of up-and down-regulated genes in selected study and comparison
                             ),
                             
                             br(),
                             br(),
                             fluidRow(
                               column(11, offset=1,
                                      plotOutput("volcano") %>% withSpinner(color="#0dc5c1"))
                             ),
                             
                             br(),
                             br(),
                             
                    ),
                    
                    # heatmap (can choose between displaying lncRNAs or protein-coding genes) 
                    
                    tabPanel("Heatmap", h3("Heatmap"),
                             helpText("Heatmap of differentially expressed genes from the selected study and comparison. CPM were used to generate the plot"),
                             br(),
                             br(),
                             radioButtons("gene_type2", 
                                          h5("Select gene type"),
                                          choices = list("lncRNA genes", "Protein-coding genes"),
                                          selected="lncRNA genes"),
                             br(),
                             fluidRow(
                               column(11, offset = 1, 
                                      plotOutput("heatmap"))
                             )
                    ),
                    
                    # Gene ontology plot (can choose between up-regulated or down-regulated genes and what GO terms should be analysed)
                    
                    tabPanel("GO Analysis", h3("Gene Ontology Analysis"),
                             helpText("Perform Gene Ontology overepresentation test using gprofiler2. FDR was used for multiple tesing correction."),
                             
                             fluidRow(
                               column(6,
                                      radioButtons("expression", 
                                                   h5("Select expression pattern"),
                                                   choices = list("up-regulated genes", "down-regulated genes"),
                                                   selected="up-regulated genes")),
                               
                             ),
                             
                             fluidRow(
                               column(12,
                                      plotOutput("GO")  %>% withSpinner(color="#0dc5c1")),
                             ),
                             
                             br(),
                             br(),
                             
                             fluidRow(
                               column(10, offset=1,
                                      DT::dataTableOutput("GO_table") %>% withSpinner(color="#0dc5c1"))
                                      )
                             ),
                    
                    
                    # Pathway analysis (can choose between up-regulated or down-regulated genes)
                    
                    tabPanel("Pathway Analysis", h3("KEGG Pathway Analysis"),
                             helpText("Perform Over-representation KEGG Pathway analysis using clusterProfiler. Shows 20 top results"),
                             
                             fluidRow(
                               column(6,
                                      radioButtons("expression2", 
                                                   h5("Select expression pattern"),
                                                   choices = list("up-regulated genes", "down-regulated genes"),
                                                   selected="up-regulated genes")),
                               
                             ),
                             
                             plotOutput("KEGG") %>% withSpinner(color="#0dc5c1")
                    ),
                    
                    # UpSet plot
                    
                    tabPanel("Comparisons Intersection", h3("Shared DEGs among comparisons"),
                        helpText("Shows the DEGs shared among the different comparisons of one study"),
                             
                             fluidRow(
                               column(6,
                                      radioButtons("expression3", 
                                                   h5("Select expression pattern"),
                                                   choices = list("up-regulated genes", "down-regulated genes"),
                                                   selected="up-regulated genes")),
                               
                             ),
                             
                             plotOutput("UPSET") %>% withSpinner(color="#0dc5c1")
                             
                    )
                    
                  ) # end tabsetPanel
                  
           ) # end column
           
         ), # end fluid row
         
)   # end tabPanel 