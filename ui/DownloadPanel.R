# -------- Download Panel -------

tabPanel(title=list(icon("download"),"Download"),
         
         titlePanel(div(HTML("Download <em>T2DB</em> Data"))),
         
         p("All data in T2DB were processed from a snakemake pipeline available in the Analysis_of_T2D_Studies ", tags$a(href="https://github.com/heartlncrna/Analysis_of_T2D_Studies", "GitHub Repository")),
         
         fluidRow(
           column(3,
                  selectInput("dataset", h5("Select a dataset"),
                              choices = c("GSE175988", "GSE115601", "GSE154416")),  # allow user to select dataset to download
                  radioButtons("filetype", "File type:",
                               choices = c("csv", "tsv")),  # allow user to select type of file
                  
                  downloadButton('downloadData', 'Download', class = "btn-primary"), 
                  br(),
                  helpText("It takes between 10-30 seconds for the download window to appear"),
                  
                  tags$script(
                    "var downloadTimeout;
           $(document).on('click', '#downloadData', function(){
             $('#downloadData').removeClass('btn-primary').addClass('btn-success');
             var timeoutSeconds = input$dataset == 'GSE154416' ? 38 : 10;
             downloadTimeout = setTimeout(function(){
               $('#downloadData').removeClass('btn-success').addClass('btn-primary');
             }, timeoutSeconds * 1000); // Change the button back to blue after the specified seconds
           });
           $(document).ajaxComplete(function(event, xhr, settings) {
             clearTimeout(downloadTimeout); // Clear the timeout when the download is complete
             $('#downloadData').removeClass('btn-success').addClass('btn-primary');
           });
           ")
                  ), # end column
           
           column(9,
                  div(DT::dataTableOutput("table2"), style = "font-size: 85%; width: 90%"))
         ) # end fluidRow
) 