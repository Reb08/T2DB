# -------- Home Panel -------

tabPanel(title=list(icon("home"), "Home"),
         
         # insert picture for home page
         tags$figure(
           align="center",
           tags$img(
             src="Home_page.png",
             width="950",
             alt="Picture for the home page"
           )
         )
)