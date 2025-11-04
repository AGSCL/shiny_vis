ui <- fluidPage(
  sliderInput("n", "N:", 10, 100, 50), #input: control deslizante, llamado "n"
  plotOutput("p") #para visualizar el gráfico
)

server <- \(input, output, session){
  datos <- reactive({ rnorm(input$n) }) # función reactiva, depende de input$n para definir número de obs.
  output$p <- renderPlot({ hist(datos(), main= "Histograma", xlab="Datos", ylab="Frecuencia") }) # genera el gráfico "p"
}

shinyApp(ui, server)