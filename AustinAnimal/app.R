#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(ggplot2)
library(shinythemes)



combined <- read.csv("newData.csv")

# Define UI for application that draws a histogram
ui <- fluidPage(
    theme = shinytheme("cosmo"),
    # Application title
    titlePanel("Old Faithful Geyser Data"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            dateRangeInput("date", strong("Date range"), start = "2013-10-1", end = "2020-5-13",
                           min = "2013-10-1", max = "2020-5-13"),
        ),
            # Show a plot of the generated distribution
        mainPanel(
            helpText("Select the date range you would like to view")
        )
    ),
    sidebarLayout(
      sidebarPanel(
            textInput("nameText",
                    h3("Enter a name: "),
                    value = "Enter Name..."
            )
      ),
      mainPanel(
          plotOutput(outputId = "namePlot", height = "400px")
      )
    ),
    sidebarLayout(
        sidebarPanel(
            checkboxGroupInput("checkGroup", 
                               h3("Exit Status"), 
                               choices = list("Stray" = "Stray", 
                                              "Owner Surrender" = "Owner Surrender", 
                                              "Public Assist" = "Public Assist",
                                              "Wildlife" = "Wildlife",
                                              "Euthanasia Request" = "Euthanasia Request",
                                              "Abandoned" = "Abandoned"),
                               selected = "Stray"),
            selectInput("timeSelect",
                        h3("Time Selector"),
                        choices = list("Month" = "Month",
                                       "Year" = "Year"),
                        selected = "Year"
                        )
        ),
        mainPanel(
            helpText("Select an option"),
            plotOutput(outputId = "timePlot", height = "400px")
        )
    ),
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    createTimeGraph <- reactive({
            validate(need(!is.na(input$checkGroup), "Please provide an exit status."))
            byTime <- combined %>%
                filter(mdy_hms(DateTime.in) > as.POSIXct(input$date[1]))
            
            
            if(input$timeSelect == "Year"){
                byTime <- byTime %>%
                    filter((Intake.Type %in% input$checkGroup) & (Outcome.Type == "Adoption")) %>%
                    mutate(mon = year(mdy_hms(DateTime.out))) %>%
                    group_by(mon, Sex.upon.Intake) %>%
                    count()
            }else{
            
               byTime <- byTime %>%
                    filter((Intake.Type %in% input$checkGroup) & (Outcome.Type == "Adoption")) %>%
                    mutate(mon = month.abb[month(mdy_hms(DateTime.out))]) %>%
                    group_by(mon, Sex.upon.Intake) %>%
                    count()
                
            }
                
        }
    )
    output$timePlot <- reactivePlot(
        function(){
            byTime <- createTimeGraph()
            
            byTimep <- ggplot(byTime, aes(x = mon, y=n, fill=Sex.upon.Intake))+
                geom_bar(stat = "identity", position = position_dodge()) 
            if(input$timeSelect == "Month"){
               byTimep <- byTimep + scale_x_discrete(limits = month.abb)
            }
            
            print(byTimep)
        }
    )
    
    createNameGraph <- reactive({
            validate(need(!is.na(input$nameText), "Please provide a Name."))
            byName <- combined %>%
                filter(mdy_hms(DateTime.in) > as.POSIXct(input$date[1]))
        
            byName <- byName %>%
                filter((input$nameText == Name.in) & (Outcome.Type == "Adoption")) %>%
                mutate(mon = year(mdy_hms(DateTime.out))) %>%
                group_by(mon, Animal.Type.in) %>%
                count()
        }
    )
    output$namePlot <- reactivePlot(
        function(){
            byName <- createNameGraph()
            
            byNamep <- ggplot(byName, aes(x = mon, y = n, fill = Animal.Type.in)) +
                geom_bar(stat = "identity", position = position_dodge())
            
            print(byNamep)
        }
    )
    
    
    output$choice <- renderText({
        text <- paste(input$checkGroup, collapse = ", ")
        paste("chose: ", text)
    })
    output$select <- renderText({
        text <- paste(input$timeSelect, collapse = ", ")
        paste("chose: ", text)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
