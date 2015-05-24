# ui.R

library(shiny)


shinyUI(fluidPage(
      titlePanel("FDA Food Recalls Analysis"),
      tags$div(

      HTML("This App briefly analyzes FDA food Recalls aggregated using the", 
           "<a href='http://open.fda.gov/food/enforcement/'> API </a>.",
           "The API call is currently set up to retrieve only 100 records to avoid overloading the service and getting", 
           "stopped.<br/> According to the FDA 'Recalls are classified into three categories:<br/>")),
               
           tags$div(tags$ol(
                     tags$li("Class I, a dangerous or defective product that predictably could cause serious health", 
                             "problems or death,"), 
                     tags$li("Class II, meaning that the product might cause a temporary health problem, or pose only", 
                             "a slight threat of a serious nature, and"), 
                     tags$li("Class III, a product that is unlikely to cause any adverse health reaction, but that", 
                             "violates FDA labeling or manufacturing laws.'"))),
      tags$div( 
            HTML("In the <b><i>All Recalls Charts</b></i> tab, the <i>top chart</i> shows the total number of", 
                 "recalls by classification and status of the recall.",
               "The <i>bottom chart</i> is linked to the filter by State on the left hand side panel and shows the", 
               "breakdown by city for the selected state and status of the recall. </br>",
               "Changing the State selection will show the number of recalls by city and the recall status. </br>",
               "Below the filter a confirmation text shows the selected State, and a text summary with the total",
               "number of recalls in the State as well as the name of the City with the most recalls",
               "(when Cities have the same numbers of recalls, it shows the first one in alphabetic order shows). </br>",
               "The <b><i>Recalls by State</b></i> tab shows the percentage of recalls for each class of recall", 
               "grouped by State with the table of values underneath. </br>",
               "The <b><i>Table</b></i> tab has all data retrieved from the API stored in a searcheable DataTable.")),
      
      sidebarLayout(
            sidebarPanel(
                  uiOutput("state"),
                  uiOutput("city"),
                  textOutput("state_conf_text"),
                  textOutput("city_rec_text")
),
mainPanel(
      tabsetPanel(
            tabPanel('All Recalls Charts',
                     plotOutput("plot_tot", width = "70%"),
            
            tabPanel('Reactive Chart',
                     plotOutput("plot_reac", width = "70%"))),
            
            tabPanel('Recalls by State',
                     showOutput("nplot", "nvd3"),
            
            tabPanel('Summary Table',
                     dataTableOutput("summary"))),
                     
            tabPanel('Table',
                     dataTableOutput("table"))
      )))
))
