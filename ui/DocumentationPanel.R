# -------- Documentation Panel -------

tabPanel(title=list(icon("circle-info"),"Documentation"),
         
         fluidRow(
           
           column(7, offset=2, 
                  navlistPanel(
                    tabPanel("Home",
                             h3(em("T2DB"), "Documentation"),
                             h6("v1.0.0"),
                             p("2023-03-22"),
                             p(strong("T2DB"), "is a web database for", strong("accessing and exploring expression data of protein-coding and lncRNA genes in T2D patients."),
                               "The data for this database was derived from three studies profiled by", em("Distefano et al., 2023."),
                               strong("T2DB"), "is the work of the ", tags$a(href="https://heartlncrna.github.io/", "Unchida laboratory,"), "Center for RNA Medicine, Aalborg University, and the ", tags$a(href="https://www.bioresnet.org/", "Bioinformatic Reaserch Network.")),
                             br(),
                             p("Key features:"),
                             tags$ul(
                               tags$li("View transcriptomic data across three different studies and across different conditions"),
                               tags$li("Explore differential gene expression results"),
                               tags$li("Download processed datasets")
                             )
                    ), # end tabPanel("Home")
                    
                    tabPanel("Datasets",
                             h4("Datasets"),
                             p("The current version of", strong("T2DB"), "contains the following datasets:"),
                             tags$ul(
                               tags$li(tags$a(href="https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE164416", "GSE164416:"), "RNA-seq data of pancreatic islets of 133 human donors divided based on their diabetes status: non-diabetic (Control), impaired glucose tolerance (IGT), type 3c diabetes (T3cD) and type 2 diabetes (T2D)"),
                               tags$li(tags$a(href="https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE115601", "GSE115601:"), "RNA-seq data of smooth muscle gastric body samples from diabetic gastroparetics, diabetic non-gastroparetic  controls, idiopathic gastroparetics and non-diabetic non-gastroparetic patients"),
                               tags$li(tags$a(href="https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE175988", "GSE175988:"), "RNA-seq data of human peripheral blood mononuclear cells from type 2 diabetes and control subjects. Cells were either unstimulated or induced into inflammatory (M1) macrophages using the Toll-like receptor ligand 187 lipopolysaccharide (LPS) and interferon-γ (IFN-γ)")
                             )
                             ),# end tabPanel("Datasets")
                    
                    tabPanel("T2DB Interfaces",
                             h4("T2DB Interfaces"),
                             tags$figure(
                               align="center",
                               tags$img(
                                 src="VolcanoPage_2.png",
                                 width="950",
                                 alt="Picture for the result page"
                               )
                             ),
                            p(strong("'Explore Results' page"), strong("(A)"), "Controls the study which is displayed.", 
                              strong("(B)"), "Controls the type of conditions to focus on within the selected study.", 
                              strong("(C)"), "Controls threshold for log2 Fold Change and FDR.",
                              strong("(D)"), "Result table which displays the results of the differential expression analysis for each gene in the selected comparison and study.",
                              strong("(E)"), "Summary table which displays the number of differentially expressed genes (differentiating between protein-coding and lncRNA genes) in the selected comparison and study.",
                              strong("(F)"), "Volcano plot which displays the results of the DGE analysis. Selecting a row in the 'Results table' (D) will cause the corresponding gene to be highlighted in the volcano plot."),
                             
                             
                             tags$figure(
                               align="center",
                               tags$img(
                                 src="HeatmapPage_2.png",
                                 width="950",
                                 alt="Picture for the heatmap page"
                               )
                               ),
                              
                             p(strong("DGE Heatmap."), strong("(A)"), "Controls the expression pattern of the displayed DEGs on (B).",
                               strong("(B)"), "Heatmap of the differentially expressed genes in the selected comparison and study."),
                            
                            
                            tags$figure(
                              align="center",
                              tags$img(
                                src="GOpage_2.png",
                                width="950",
                                alt="Picture for the GO page"
                              )
                            ),
                            
                            p(strong("Gene Ontology analysis."), strong("(A)"), "Controls the expression pattern of the DEGs used for the analysis on (C)", 
                              strong("(B)"), "Controls category of gene ontology terms to use in the analysis.",
                              strong("(C)"), "Gene Ontology analysis results displayed as barplot, showing the significantly enriched GO terms among the selected category associated with the list of up- or down-regulated genes in the selected comparison and study."),
                             
                            tags$figure(
                              align="center",
                              tags$img(
                                src="KEGGPage_2.png",
                                width="950",
                                alt="Picture for the Kegg analysis page"
                              )
                            ),
                            
                            p(strong("Pathway Analysis"), strong("(A)"), "Controls the expression pattern of the displayed DEGs on (B).",
                              strong("(B)"), "KEGG Pathway overepresentation analysis results displayed as dotplot, showing the significantly enriched KEGG pathways associated with the list of up- or down-regulated genes in the selected comparison and study."),
                           
                            
                            tags$figure(
                              align="center",
                              tags$img(
                                src="ComparisonPage_2.png",
                                width="950",
                                alt="Picture for the comparison page"
                              )
                            ),
                            
                            p(strong("Comparsisons Intersection."), strong("(A)"), "Control the expression pattern of the DEGs used on (B).", 
                              strong("(B)"), "This interface displays the DEGs shared among the different comparisons of the selected study as an UpSet plot. For more information, see the", tags$a(href="https://upset.app", "Upset plot documentation.")),
                            
                              tags$figure(
                                align="center",
                                tags$img(
                                  src="DownloadPage_2.png",
                                  width="970",
                                  alt="Picture for the comparison page"
                                )
                              ),
                              
                              p(strong("Download Page."), strong("(A)"), "Controls the study which will be displayed and subsequently downloaded.", 
                                strong("(B)"), "Controls the type of file used to download the desired data set (either comma-separated-values (CSV) file or tab-separated-values (TSV) file)",
                                strong("(C)"), "Preview of the data of the selected study which will be downloaded.")
                             
                             ),# end tabPanel
                    
                    tabPanel("Terminology",
                             
                             h4("Terminology"),
                             tags$ul(
                               tags$li(em("DEG:"), "Differentally Expressed Gene"),
                               tags$ul(
                                 tags$li("Differentially expressed genes refer to genes that are expressed at significantly different levels between two or more conditions. In this study, we calculated DEGs using the", tags$a(href="https://bioconductor.org/packages/release/bioc/html/edgeR.html", "edgeR"), "R/Bioconductor package.")
                               ),
                               tags$li(em("FDR:"), "False Discovery Rate"),
                               tags$ul(
                                 tags$li("The false discovery rate is a metric used to correct for multiple testing, restricting the total number of false positives (type I errors).")
                               ),
                               tags$li(em("FC:"), "Fold Change"),
                               tags$ul(
                                 tags$li("The fold chage measures how much the expression of a gene has changed between one condition relative to the other. It is calculated by taking the ratio of the normalised gene counts values (counts per million (CPM) in this case)")
                               ),
                               tags$li(em("CPM:"), "Counts per Million"),
                               tags$ul(
                                 tags$li("Counts per million is a gene count normalzation metric where the count of reads mapped to a gene is divided by the total number of reads mapped and multiplied by a million")
                               ),
                               tags$li(em("IGT:"), "Impaired Glucose Tolerance"),
                               tags$li(em("T2D:"), "Type 2 Diabetes"),
                               tags$li(em("T3cD:"), "Type 3c diabetes"),
                               tags$li(em("LPS:"), "Toll-like receptor ligand 187 lipopolysaccharide"),
                             ),
                    ), # end tabPanel("Terminology")
                    
                    tabPanel("Bugs",
                             h4("Bugs"),
                             p(strong("T2DB"), "is a new database, and as such, bugs may occasionally occur. If you encounter any bugs or unexpected behavious please open an issue on the", tags$a(href="https://github.com/Reb08/T2DB/issues", "RLBase GitHub repo"), "and describe, in as much as possible, the following:"),
                             tags$ul(
                               tags$li("What you expected T2DB to do."),
                               tags$li("What T2DB did and why it was unexpected."),
                               tags$li("Any error messages you received (along with screenshots).")
                             )
                    ),
                    
                    tabPanel("License and attribution",
                             h4("License and Attribution"),
                             p("T2DB is licensed under an MIT license and we ask that you please cite", strong("T2DB"), "in any published work like so:"),
                             h5(em("'Distefano"), "et. al", em("Systematic Analysis of Long Non-Coding RNA Genes in Type II Dabetes, 2023...'"))
                    ) # end tabPanel
                    
                  )), # end navlistPanel and column, repsectively
           
         ) # end fluidRow
         
) # end tabPanel
