# server.r

library(shiny)
library(rCharts)
library(ggplot2)
library(RCurl)
library(jsonlite)
library(dplyr)


server = function(input, output, session){
      
      # Reactive filter drop down selector for State
      output$state <- renderUI({
            selectInput("state", "State:", choices = food_df$state, selected = food_df$state["MI"])
      })
      
      # Create text confirmation output of selected filter on UI
      output$state_conf_text <- renderText({ 
                        paste("You have selected", input$state, "State")
      })


#       output$state_rec_num <- reactive({
#                               food_df %>%
#                                     select(state, city) %>%
#                                     filter(state == local(input$state)) %>%
#                                     group_by(state) %>%
#                                     tally()
#       })
      
      # Number of recall by State
      state_rec_num <- reactive(food_df %>%
                                            select(state, city) %>%
                                            filter(state %in% local(input$state)) %>%
                                            group_by(state) %>%
                                            tally())
      isolate(state_rec_num())
      
      # Text for total number of recalls by State and city with most recalls
      output$state_rec_text <- renderText({ 
            paste("There are a total of", state_rec_num()[[2]], "recalls in", input$state, 
                  "and the city with the highest number of recalls is", highest_city_rec_num()[[2]])
      })
      
      # City with most recalls
      highest_city_rec_num <- reactive(food_df %>%
                                             select(state, city) %>%
                                             filter(state %in% local(input$state)) %>%
                                             group_by(state,city) %>%
                                             tally() %>%
                                             slice(which.max(n))                                       
                                       )
      isolate(highest_city_rec_num())
      
      
      # Reactive data source for 'plot_reac' chart
      data_reac <- reactive({
                        filter(food_df, state %in% input$state) 
      })

      
      # Static total recalls plot
      output$plot_tot <- renderPlot({      

            plot_tot <- ggplot(food_df, aes(x = classification, fill = status)) +
                                                      geom_bar(position = "dodge", width = .7) +
                                                      ggtitle("Total Number of Food recalls \n") +
                                                      ylab("") +
                                                      xlab("\n Type of Recall")
            print(plot_tot)
      })
      
      # Reactive plot working when filters State and City have values
      output$plot_reac <- renderPlot({      
            
             plot_reac <- ggplot(data_reac(), aes(x = state, fill = status)) +
                                          geom_bar(position = "dodge", width = .5) +
                                          ylab("") +
                                          xlab("") +
                                          facet_wrap("city")
      
            print(plot_reac)
      
            })
      
      # Plot percent recalls by state and Class
      output$nplot <- renderChart2({

                  # output$value <- renderPrint({ input$select })
                  
                  summary_tbl1 <- food_df %>%
                        select(state, classification, status, city) %>%
                        group_by(state, classification) %>%
                        tally() %>%
                        group_by(state) %>%
                        mutate(Percent = (100 * n) / sum(n)) %>%
                        select(-n) %>%
                        arrange(state, desc(Percent))
                  
                  nplot <- nPlot(Percent ~ state, group = 'classification', data = summary_tbl1, type = 'multiBarChart')
                  
                  return(nplot)
      })       
            
      # DataTabe output                           
      output$table <- renderDataTable({food_df
            
                        }, options = list(pageLength = 10))
      
      # Summary table with percentage of recalls by Class and State
      output$summary <- renderDataTable({
            
                              summary_tbl <- food_df %>%
                                          select(state, classification, status, city) %>%
                                          group_by(state, classification) %>%
                                          tally() %>%
                                          group_by(state) %>%
                                          mutate(Percent = (100 * n) / sum(n)) %>%
                                          select(-n) %>%
                                          arrange(state, desc(Percent))}, , options = list(pageLength = 10))
      
}
