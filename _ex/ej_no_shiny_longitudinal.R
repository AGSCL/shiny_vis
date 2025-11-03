data15a64_rn_ratio_its <-
  haven::read_dta("https://drive.google.com/uc?export=download&id=1IJ-fkYu3JMKaN5hVcFhuKhOBwYkQVWWw")

# El estudio buscaba determinar si durante el período de mayor confrontación entre protestantes y carabineros
# en Santiago, hubo un incremento en las admisiones a servicios de urgencia debido a lesiones o eventos
# traumáticos relacionados con las manifestaciones. Se planteó que, además, las dificultades de acceso a la
# atención médica durante este período podrían haber llevado a un retraso en las consultas, resultando en una
# mayor gravedad de los casos presentados y, por ende, en una mayor necesidad de hospitalización.
# 
# Se usaron datos estadísticos semanales de enero de 2015 a diciembre de 2019, enfocándose en admisiones por
# causas traumáticas y del sistema respiratorio de personas entre 15 y 64 años. Se tomaron registros de tres
# servicios públicos de urgencia cercanos a Plaza Italia, centro de las protestas: Posta Central, Hospital del
# Salvador y Hospital San José. No se tuvieron en cuenta clínicas privadas ni el hospital de Carabineros por
# falta de acceso a sus datos.
# 
# Con esta información, se construyó una serie temporal que considera 10 semanas de exposición a las protestas,
# desde el 18 de octubre hasta finales de 2019.


# (opcional) instalar si faltan:
# install.packages(c("dplyr","plotly","zoo","scales"))

# 1) Preparar datos: tasa (%) y media móvil (4 semanas)
df_tr <- data15a64_rn_ratio_its |>
  dplyr::mutate(
    trauma_rate = 100 * (hosp_trauma / hosp_total)
  ) |>
  dplyr::arrange(date)

k <- 4  # periodo de la media móvil|

# media móvil centrada de 4 semanas (ajusta 'k' si quieres)
df_tr <- dplyr::mutate(
  df_tr,
  trauma_rate_ma4 = zoo::rollmean(trauma_rate, k = k, fill = NA, align = "right")
)

# 2) Gráfico plotly estilo "chalk"
p <- plotly::plot_ly() |>
  # línea principal
  plotly::add_lines(
    data = df_tr,
    x = ~date, y = ~trauma_rate,
    name = "Trauma (%)",
    hovertemplate = paste0(
      "%{x|%Y-%m-%d}<br>",
      "Trauma: %{y:.2f}%<extra></extra>"
    )
  ) |>
  # media móvil
  plotly::add_lines(
    data = df_tr,
    x = ~date, y = ~trauma_rate_ma4,
    name = paste0("Media móvil (MM) (",k," sem.)"),
    line = list(width = 3, dash = "solid"),
    hovertemplate = paste0(
      "%{x|%Y-%m-%d}<br>",
      "MM(4): %{y:.2f}%<extra></extra>"
    )
  ) |>
  # Layout “tipo chalk”
  plotly::layout(
    title = list(text = NULL),  # sin título para que no tape nada
    xaxis = list(
      title = list(text = "Semana"),
      rangeselector = list(
        buttons = list(
          list(count = 13, label = "13 sem", step = "week", stepmode = "backward"),
          list(count = 26, label = "26 sem", step = "week", stepmode = "backward"),
          list(step = "all", label = "Todo")
        )
      ),
      rangeslider = list(visible = TRUE),
      showgrid = TRUE
    ),
    yaxis = list(
      title = list(text = "Hospitalizaciones traumatológicas del total (%)"),
      ticksuffix = "%",
      zeroline = TRUE,
      showgrid = TRUE
    ),
    plot_bgcolor = "rgba(0,0,0,0)",   # fondo transparente
    paper_bgcolor = "rgba(0,0,0,0)",  # para integrarlo con tu tema de slides
    hoverlabel = list(
      bgcolor = "rgba(51,51,51,0.9)",
      font = list(color = "white")
    ),
    legend = list(orientation = "h", x = 0, y = -0.15)
  )

p
