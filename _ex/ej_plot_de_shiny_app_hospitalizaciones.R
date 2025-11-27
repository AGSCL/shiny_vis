library(dplyr)
library(plotly)
library(haven)
d <-   haven::read_dta("https://drive.google.com/uc?export=download&id=1IJ-fkYu3JMKaN5hVcFhuKhOBwYkQVWWw")
# Calculamos el porcentaje de hospitalizaciones traumáticas sobre el total
d <- d %>% dplyr::arrange(date) %>%
  dplyr::mutate(trauma_rate = 100 * (hosp_trauma / hosp_total))
# Generamos el gráfico interactivo con plotly
plot_ly()%>%
  add_lines( #Añadimos la serie de tiempo, por fecha y oporcentaje de hospitalizaciones traumáticas
    data = d,
    x = ~date, y = ~trauma_rate,
    name = "Trauma (%)",
    hovertemplate = "%{x|%Y-%m-%d}<br>Trauma: %{y:.2f}%<extra></extra>" #Generamos la ventanita que sobresale del gráfico con valores como fecha y % trauma
  )%>%
  layout(
    xaxis = list(
      title = list(text = "Semana"),
      # Definimos rangoselector y slider, para poder visualizar diferentes ventanas temporales
      rangeselector = list(
        buttons = list(
          list(count = 4, label = "4 sem", step = "week", stepmode = "backward"),
          list(count = 13, label = "13 sem", step = "week", stepmode = "backward"),
          list(count = 26, label = "26 sem", step = "week", stepmode = "backward"),
          list(step = "all", label = "Todo")
        )
      ),
      rangeslider = list(visible = TRUE),
      showgrid = TRUE
    ),
    yaxis = list(
      title = list(text = "Hosp. traumatológicas del total (%)"),
      ticksuffix = "%", zeroline = TRUE, showgrid = TRUE
    ),
    plot_bgcolor = "rgba(0,0,0,0)",
    paper_bgcolor = "rgba(0,0,0,0)",
    hoverlabel = list(bgcolor = "rgba(51,51,51,0.9)", font = list(color = "white")),
    legend = list(orientation = "h", x = 0, y = -0.15)
  )