# install.packages(c("shiny", "plotly", "dplyr", "gapminder"))
library(shiny)
library(plotly)
library(dplyr)
library(gapminder)

ui <- fluidPage(
  titlePanel("Explorador dinámico con Shiny + plotly"),
  sidebarLayout(
    sidebarPanel(
      # selectInput("continent", "Continente:", 
      #             choices = c("Todos", sort(unique(gapminder$continent)))),
      sliderInput("year", "Año:", min = 1952, max = 2007, step = 5, value = 2007)
    ),
    mainPanel(
      plotlyOutput("scatter"),
      br(),
      p(em("Tip: Prueba zoom y hover; cambia el año y el continente."))
    )
  )
)

server <- function(input, output, session){
  data_react <- reactive({
    df <- gapminder |> filter(year == input$year)
    #if (input$continent != "Todos") df <- df |> filter(continent == input$continent)
    df
  })
  
  output$scatter <- renderPlotly({
    plot_ly(
      data = data_react(),
      x = ~gdpPercap, y = ~lifeExp, color = ~continent, size = ~pop,
      type = "scatter", mode = "markers", text = ~country, hoverinfo = "text"
    ) |>
      layout(xaxis = list(title = "PIB per cápita", type = "log"),
             yaxis = list(title = "Esperanza de vida"))
  })
}

shinyApp(ui, server)

