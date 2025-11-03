library(shiny)
library(bslib)
library(ggplot2)
library(showtext)
library(sysfonts)
library(dplyr)
library(haven)
library(plotly)
library(htmltools)
library(scales)
library(ggiraph)
library(tibble)
library(rmapshaper)

#add _style folder!!!!!

# 1. Define the custom font face.
storia_sans_font <- font_face(
  family = "Storia Sans",
  src = "_style/storia-sans/StoriaSans-Regular.ttf" # Ensure this path is in your www/ folder
)

# 2. Define the main theme
my_theme <- bs_theme(
  version = 5, 
  
  # Map SASS variables to theme arguments
  bg = "#F7F7F7",        # from $body-bg
  fg = "#595959",        # from $body-color
  primary = "#9682fc",    # from $link-color
  
  # Apply the custom font
  base_font = font_collection(storia_sans_font, "sans-serif"),
  heading_font = font_collection(storia_sans_font, "monospace"),
  code_font = font_collection(storia_sans_font, "monospace"),
  
  # Apply specific element colors
  "headings-color" = "#333333",
  "card-bg" = "#FFFFFF"
)

# 3. Add the custom ::selection rule as a plain CSS string
my_theme <- bs_add_rules(my_theme, 
                         "::selection { background-color: #F7F7F7; }"
)
# Now, add the "force" rules
my_theme <- bs_add_rules(my_theme, 
                         "
  /* This is a 'brute force' override. */
  body, p, div, span, .shiny-input-container {
    font-family: 'Storia Sans', sans-serif !important;
  }
  
  h1, h2, h3, h4, h5, h6, .h1, .h2, .h3, .h4, .h5, .h6 {
    font-family: 'Storia Sans', monospace !important;
  }
  
  @font-face {
  font-family: 'storia-sans'; /* El nombre que usas en grViz */
  src: url('_style/storia-sans/StoriaSans-Regular.ttf') format('truetype');
  }
  
  pre, code {
    font-family: 'Storia Sans', monospace !important;
  }
  
  ::selection { 
    background-color: #01c9ad; 
  }
  "
)

ui <- page_navbar(
  title = "Tutorial de Shiny",
  theme = my_theme,

nav_panel(
  title = "Ejemplo Interactivo, ggplot en Shiny",
  layout_sidebar(
    sidebar = sidebar(
      title = "Controles",
      selectInput("tipo_grafico", "Tipo de Gráfico:",
                  choices = c("Dispersión" = "scatter",
                              "Caja" = "box",
                              "Violín" = "violin")),
      selectInput("especie", "Filtrar por Especie:",
                  choices = c("Todas", levels(iris$Species))), #cambiar el tipo
      sliderInput("punto_tamano", "Tamaño de Puntos:",
                  min = 1, max = 10, value = 3),
      checkboxInput("mostrar_suavizado", "Mostrar línea de tendencia", TRUE)
    ),
    card(
      card_header("Visualización Interactiva con datos de Iris, ggplot en Shiny"),
      card_body(
        plotOutput("plot_iris"),
        HTML("
            <br>
            <p style='color: rgba(0, 0, 0, 0.8);'><strong>Explicación:</strong></p>
            <p style='color: rgba(0, 0, 0, 0.8);'>Este ejemplo muestra cómo Shiny permite crear visualizaciones interactivas:</p>
            <ul style='color: rgba(0, 0, 0, 0.8);'>
              <li>Puedes cambiar el tipo de gráfico dinámicamente</li>
              <li>Filtrar datos por especie</li>
              <li>Ajustar el tamaño de los puntos</li>
              <li>Mostrar/ocultar la línea de tendencia</li>
            </ul>
          ")
      )
    )
  )
),

nav_panel(
  title = "Ejemplo Interactivo, plotly",
  layout_sidebar(
    card(
      card_header("Visualización Interactiva Longitudinal, Hospitalizaciones, Chile, plotly"),
      card_body(
        plotlyOutput("plot_plotly"),
        HTML("
            <br>
            <p style='color: rgba(0, 0, 0, 0.8);'><strong>Explicación:</strong></p>
            <p style='color: rgba(0, 0, 0, 0.8);'>Este ejemplo muestra cómo plotly permite crear visualizaciones interactivas:</p>
            <ul>
            <li><b>Objetivo:</b> Determinar el incremento en admisiones a urgencias por lesiones traumáticas durante las 10 semanas de protestas (a partir del 18 de octubre de 2019) en Santiago, y evaluar la hipótesis de mayor gravedad de casos por retraso en la consulta.</li>
            <li><b>Datos:</b> Estadísticas semanales (Ene 2015 – Dic 2019) de admisiones por causas traumáticas y otras (sis. circulatorio, respiratorio, etc.).</li>
            <li><b>Población:</b> Personas entre **15 y 64 años**.</li>
            <li><b>Centros de datos:</b> Tres servicios públicos de urgencia cercanos a Plaza Italia: Posta Central, Hospital del Salvador y Hospital San José.</li>
            <li><b>Cálculo clave:</b> Se construyó una serie temporal que aísla el período de exposición de **10 semanas** de confrontación.</li>
            </ul>
            <ul style='color: rgba(0, 0, 0, 0.8);'>
              <li>Si bien no puedes cambiar el tipo de gráfico dinámicamente</li>
              <li>Puedes mover la ventana y resolución de seguimiento</li>
              <li>No necesitas Shiny para utilizar este gráfico y sus modalidades</li>
            </ul>
          ")
      )
    )
  )
),

nav_panel(
  title = "Ejemplo Interactivo, ggigraph",
  layout_sidebar(
    card(
      card_header("Mortalidad relativa, población programa personas situación calle SENDA, 2010-2019, Chile, ggigraph"),
      card_body(
        girafeOutput("mapa", width = "60%", height = "60%"),
        HTML("
            <br>
            <p style='color: rgba(0, 0, 0, 0.8);'><strong>Explicación:</strong></p>
            <p style='color: rgba(0, 0, 0, 0.8);'>Este ejemplo muestra cómo ggigraph permite crear visualizaciones interactivas:</p>
            <ul>
              <li><b>Objetivo:</b> Estimar la mortalidad relativa posteriores al tratamiento, participantes del programa para personas en situación de calle de SENDA entre 2011 y 2020, Chile.</li>
              <li><b>Cohorte retrospectiva poblacional:</b> 1.312 adultos en tratamiento por trastornos por uso de sustancias en situación de calle (2011–2020), vinculados con registros de defunciones (2010–2020, DEIS).</li>
              <li><b>Análisis:</b> Razones de mortalidad estandarizadas (RME) calculadas usando tasas nacionales por sexo y edad.</li>
              <li><b>Enfoque espacial:</b> Estimaciones por región (al 2015) mediante suavizamiento por adyacencia regional y dispersión, modelo Poisson jerárquico BYM2 (Besag, York & Mollié).</li>
            </ul>
            <ul style='color: rgba(0, 0, 0, 0.8);'>
              <li>Si bien no puedes cambiar el tipo de gráfico dinámicamente</li>
              <li>Puedes obtener etiquetas, hacer zoom, descargar la imagen, entre otras</li>
              <li>No necesitas Shiny para utilizar este gráfico y sus modalidades</li>
            </ul>
          ")
      )
    )
  )
),

nav_panel(
  title = "Consejos",
  layout_columns(
    card(
      card_header("Consejos Importantes"),
      card_body(
        HTML("
            <ul style='color: rgba(0, 0, 0, 0.8);'>
              <li>Guarda tu app en un archivo llamado <code>app.R</code></li>
              <li>Asegúrate de cargar todos los paquetes necesarios al inicio del archivo</li>
              <li>Prueba tu app con el botón 'Run App' en RStudio</li>
              <li>Usa <code>runApp('ruta/a/tu/app')</code> para ejecutar desde la consola</li>
            </ul>
          ")
      )
    ),
    card(
      card_header("Crear una App Shiny"),
      card_body(
        HTML('
          <h4 style="color: #555555;">Pasos en RStudio</h4>
          <a href="https://github.com/AGSCL/repr/raw/master/_figs/paso1_shiny.png" target="_blank">
              <img src="https://github.com/AGSCL/repr/raw/master/_figs/paso1_shiny.png"
                   style="width: 20%; margin-bottom: 20px;"
                   alt="Crear nueva app Shiny">
          </a>
          <p style="color: rgba(0, 0, 0, 0.8);">Para crear una nueva app Shiny:</p>
          <ol style="color: rgba(0, 0, 0, 0.8);">
            <li>File → New Project → New Directory → Shiny Application</li>
            <li>O File → New File → Shiny Web App</li>
          </ol>
          <a href="https://github.com/AGSCL/repr/raw/master/_figs/paso2_shiny.png" target="_blank">
              <img src="https://github.com/AGSCL/repr/raw/master/_figs/paso2_shiny.png"
                   style="width: 20%; margin-bottom: 20px;"
                   alt="Ejecutar app Shiny">
          </a>
          <p style="color: rgba(0, 0, 0, 0.8);">Para ejecutar la app:</p>
          <ul style="color: rgba(0, 0, 0, 0.8);">
            <li>Clic en el botón "Run App" en la barra superior del editor</li>
            <li>O usa el comando <code>runApp()</code> en la consola</li>
          </ul>
          <a href="https://github.com/AGSCL/repr/raw/master/_figs/paso3_shiny.png" target="_blank">
              <img src="https://github.com/AGSCL/repr/raw/master/_figs/paso3_shiny.png"
                   style="width: 20%; margin-bottom: 20px;"
                   alt="Publicar app Shiny">
          </a>
          <p style="color: rgba(0, 0, 0, 0.8);">
              Para publicar una app Shiny en <code>shinyapps.io</code>:
          </p>
          <ol style="color: rgba(0, 0, 0, 0.8);">
              <li>Haz clic en el botón <b>"Publish"</b> en la parte superior del editor de RStudio.</li>
              <li>Selecciona la cuenta desde donde deseas publicar. Si no tienes una cuenta, usa la opción <b>"Add new account"</b> (resaltada en la imagen) para crear una o vincular una existente.</li>
              <li>Asigna un título a tu aplicación en el campo <b>Title</b>.</li>
              <li>Clic en el botón <b>Publish</b> para subir la aplicación al servidor.</li>
          </ol>
          <a href="https://github.com/AGSCL/repr/raw/master/_figs/paso4_shiny.png" target="_blank">
              <img src="https://github.com/AGSCL/repr/raw/master/_figs/paso4_shiny.png"
                   style="width: 20%; margin-bottom: 20px;"
                   alt="Gestionar tokens en shinyapps.io">
          </a>
          <p style="color: rgba(0, 0, 0, 0.8);">
              En <code>shinyapps.io</code>, puedes gestionar tus <b>tokens</b> para la autenticación y publicación de tus aplicaciones. Los tokens permiten que tu cuenta se conecte a las herramientas de RStudio de forma segura.
          </p>
          <ol style="color: rgba(0, 0, 0, 0.8);">
              <li>Accede a la sección <b>Account → Tokens</b> en el menú de navegación izquierdo.</li>
              <li>Aquí verás una lista de los tokens existentes. Cada token tiene un identificador único y un secreto (resaltado).</li>
              <li>Para crear un nuevo token, haz clic en el botón verde <b>"Add Token"</b>.</li>
              <li>Puedes visualizar el secreto de un token existente haciendo clic en <b>"Show"</b>, pero ten cuidado de no exponer esta información públicamente.</li>
              <li>Para eliminar un token, utiliza el botón rojo <b>"Delete"</b>.</li>
          </ol>
          <p style="color: rgba(105, 125, 3, 0.8);">
              Nota: Asegúrate de agregar los secretos en tu archivo <code>.gitignore</code> para evitar comprometer la seguridad de tu cuenta.
          </p>
          <a href="https://github.com/AGSCL/repr/raw/master/_figs/paso5_shiny.png" target="_blank">
              <img src="https://github.com/AGSCL/repr/raw/master/_figs/paso5_shiny.png"
                   style="width: 20%; margin-bottom: 20px;"
                   alt="Configurar rsconnect para shinyapps.io">
          </a>
          <p style="color: rgba(105, 125, 3, 0.8);">
              Para desplegar una aplicación Shiny en <code>shinyapps.io</code>, necesitas configurar tu cuenta utilizando el paquete <code>rsconnect</code> en R o <code>rsconnect-python</code> en Python. Este proceso requiere un <b>token</b> y un <b>secret</b> para autenticarte y vincular tu cuenta.
          </p>
          <ol style="color: rgba(0, 0, 0, 0.8);">
              <li>Haz clic en <b>"Show"</b> para revelar el <b>secret</b> asociado a tu token (resaltado en la imagen).</li>
              <li>Copia el comando que aparece en la pestaña <b>With R</b> o <b>With Python</b>.</li>
              <li>Pega el comando en tu consola de R o Python para autenticar tu cuenta. En R, el comando tiene el formato:
                  <pre style="background-color: #f8f8f8; padding: 2px; border: .5px solid #ddd;">
rsconnect::setAccountInfo(name = "nombre_cuenta",
                          token = "tu_token",
                          secret = "tu_secret")
                  </pre>
              </li>
              <li>Una vez ejecutado el comando, no necesitarás configurarlo nuevamente en ese entorno.</li>
          </ol>
          <a href="https://github.com/AGSCL/repr/raw/master/_figs/paso7_shiny.png" target="_blank">
              <img src="https://github.com/AGSCL/repr/raw/master/_figs/paso7_shiny.png"
                   style="width: 20%; margin-bottom: 20px;"
                   alt="Conectar cuenta de shinyapps.io en RStudio">
          </a>
              <ol style="color: rgba(0, 0, 0, 0.8);">
              <li>Copia el comando proporcionado (incluye el <b>token</b> y el <b>secret</b>) y pégalo en tu consola de RStudio. El comando tiene este formato:
              </li>
              <li>Una vez autenticado, podrás publicar tus aplicaciones Shiny directamente desde RStudio.</li>
              </ol>
          <p style="color: rgba(105, 125, 3, 0.8);">
              Nota: Nunca compartas tu <b>token</b> ni tu <b>secret</b> públicamente. Asegúrate de excluir esta información del control de versiones usando un archivo <code>.gitignore</code>.
          </p>
        ')
      )
    ),
    card(
      card_header("Recursos Adicionales"),
      card_body(
        HTML("
            <ul style='color: rgba(0, 0, 0, 0.8);'>
              <li><a href='https://shiny.posit.co/r/getstarted/' target='_blank' style='color: #F8766D;'>Tutorial oficial de Shiny</a></li>
              <li><a href='https://shiny.posit.co/r/gallery/' target='_blank' style='color: #F8766D;'>Galería de ejemplos</a></li>
              <li><a href='https://mastering-shiny.org/' target='_blank' style='color: #F8766D;'>Libro: Mastering Shiny</a></li>
              <li><a href='https://gallery.shinyapps.io/assistant/' target='_blank' style='color: #F8766D;'>Asistente Shiny (AI)</a></li>
              <li><a href='https://tilburgsciencehub.com/topics/visualization/data-visualization/dashboarding/shinydashboard/' target='_blank' style='color: #F8766D;'>shinydashboard</a></li>
            </ul>
          ")
      )
    ),
    card(
      card_header("Hágalo usted mismo"),
      card_body(
        HTML("
            <ul style='color: rgba(0, 0, 0, 0.8);'>
              <li> Usando el siguiente <a href='https://raw.githubusercontent.com/AGSCL/shiny_vis/main/shiny.R' target='_blank' style='color: #F8766D;'>script</a></li>
              <li> Genere una aplicación en Shiny</li>
            </ul>
          ")
      )
    )
  )
)
)

server <- function(input, output) {
  datos_filtrados <- reactive({
    if (input$especie == "Todas") {
      iris
    } else {
      iris[iris$Species == input$especie,]
    }
  })
  
  output$plot_iris <- renderPlot({
    # 1. Registrar la fuente (ajusta la ruta)
    # El nombre de la familia ('storia-sans') es lo que usarás en theme_minimal
    sysfonts::font_add(
      family = "storia-sans", 
      regular = "_style/storia-sans/StoriaSans-Regular.ttf" 
    )
    # 2. Habilitar showtext para que los dispositivos gráficos usen la fuente
    showtext::showtext_auto()
    # 3. Graficar la imagen 
    p <- ggplot(datos_filtrados(), aes(x = Sepal.Length, y = Petal.Length, color = Species)) +
      theme_minimal(base_family = "storia-sans") +
      labs(x = "Longitud del Sépalo", y = "Longitud del Pétalo") +
      scale_color_manual(values = c("#9682fc", "#619CFF", "#01c9ad"))
    
    if (input$tipo_grafico == "scatter") {
      p <- p + geom_point(size = input$punto_tamano)
      if (input$mostrar_suavizado) {
        p <- p + geom_smooth(method = "lm", se = FALSE)
      }
    } else if (input$tipo_grafico == "box") {
      p <- p + geom_boxplot()
    } else if (input$tipo_grafico == "violin") {
      p <- p + geom_violin(fill = "transparent") +
        geom_jitter(size = input$punto_tamano/2, width = 0.2)
    }
    
    p
  })
  
  output$plot_plotly <- renderPlotly({
    d <- haven::read_dta("https://drive.google.com/uc?export=download&id=1IJ-fkYu3JMKaN5hVcFhuKhOBwYkQVWWw") %>%
      arrange(date) %>%
      mutate(trauma_rate = 100 * (hosp_trauma / hosp_total))
    validate(need(nrow(d) > 0, "No hay datos."))
    
    plot_ly() %>%
      add_lines(
        data = d,
        x = ~date, y = ~trauma_rate,
        name = "Trauma (%)",
        hovertemplate = "%{x|%Y-%m-%d}<br>Trauma: %{y:.2f}%<extra></extra>"
      ) %>%
      layout(
        xaxis = list(
          title = list(text = "Semana"),
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
  })
  
  output$mapa <- renderGirafe({
    # CSS del tooltip
    tooltip_css <- "
      background-color: rgba(30,30,30,0.95);
      color: #fff;
      padding: 6px 8px;
      border-radius: 4px;
      font-size: 12px;
    "
    # Helper local: sanitizar atributos HTML
    sanitize_attr <- function(x) htmltools::htmlEscape(x, attribute = TRUE)
    # 1) Cargar/descargar shapes (GADM L1: regiones)= SIMPLIFICADO

    # g <- geodata::gadm("CHL", level = 1, path = ".")
    # sf1 <- sf::st_as_sf(g) |>
    #   dplyr::select(NAME_1, CC_1, geometry) |>   # sólo lo esencial
    #   sf::st_make_valid()
    # Simplificar geometría: baja fuertemente los vértices
    # usa rmapshaper (mejor en lat/long) o reproyecta y simplifica.
    # sf1_simpl <- rmapshaper::ms_simplify(sf1, keep = 0.05, keep_shapes = TRUE)
    # (alternativa base sf, tras proyectar; ajusta la tolerancia)
    # sf1_proj <- sf::st_transform(sf1, 32719) # UTM 19S aprox. Chile central
    # sf1_simpl <- sf::st_simplify(sf1_proj, dTolerance = 1000, preserveTopology = TRUE) |>
    #              sf::st_transform(sf::st_crs(sf1))
    #saveRDS(sf1_simpl, "gadm_chl_l1_simpl.rds")
    gadm_l1_sf <- readRDS("gadm_chl_l1_simpl.rds")
    # shp con geometría
    shp <- gadm_l1_sf  # ya es sf
    
    # 2) Datos RR (tu ejemplo)
    df_rr <- tibble::tribble(
      ~CC1,  ~RR_mean, ~RR_lcl, ~RR_ucl,
      "XV",   6.0,      3.4,     8.5,
      "I",    6.4,      3.7,     9.3,
      "II",   7.2,      4.9,     10.2,
      "III",  9.1,      5.8,     16.7,
      "IV",   7.7,      5.2,     11.8,
      "V",    6.4,      4.4,     8.5,
      "RM",   7.6,      5.8,     10.1,
      "VI",   6.3,      3.8,     8.7,
      "VII",  6.9,      4.4,     9.9,
      "XVI",  7.3,      4.2,     11.8,
      "VIII", 6.7,      4.6,     8.8,
      "IX",   7.9,      5.3,     12.2,
      "XIV",  7.9,      5.4,     11.5,
      "X",    9.0,      6.3,     13.5,
      "XI",   8.1,      4.6,     13.9,
      "XII",  8.1,      5.8,     11.6
    )
    # 3) Join + tooltips
    # 30a) primero trabajar datos sin geometría
    attrs  <- shp%>% 
      sf::st_drop_geometry()%>%
      dplyr::left_join(df_rr, by = c("CC_1" = "CC1"))%>%
      dplyr::mutate(
        tooltip_raw = paste0(
          NAME_1, "\n",
          "",
          scales::number(RR_mean, accuracy = 0.1, big.mark = ".", decimal.mark = ","),
          " (",
          scales::number(RR_lcl, accuracy = 0.1, big.mark = ".", decimal.mark = ","),
          "–",
          scales::number(RR_ucl, accuracy = 0.1, big.mark = ".", decimal.mark = ","),
          ")"
        ),
        tooltip = sanitize_attr(tooltip_raw),
        NAME_1_safe = sanitize_attr(NAME_1)
      )
    # 30b) Re-adjunta la geometría original
    map_dat <- sf::st_set_geometry(attrs, sf::st_geometry(shp))
    
    # Escalar los límites para el gradiente
    lims <- quantile(map_dat$RR_mean, c(.02, .98), na.rm=T)
    
    # 3a. Registrar la fuente (ajusta la ruta)
    # El nombre de la familia ('storia-sans') es lo que usarás en theme_minimal
    sysfonts::font_add(
      family = "storia-sans", 
      regular = "_style/storia-sans/StoriaSans-Regular.ttf" 
    )
    # 3b. Habilitar showtext para que los dispositivos gráficos usen la fuente
    showtext::showtext_auto()
    
    # 4) Plot
    p <- ggplot(map_dat) +
      geom_sf_interactive(
        aes(fill = RR_mean, tooltip = tooltip, data_id = NAME_1_safe),
        color = "white", size = 0.15
      ) +
      scale_fill_gradientn(
        colours = c("#F7F7F7", "#01C9AD", "#619CFF", "#9682FC", "#595959"),
        values  = scales::rescale(c(lims[1], 
                                    lims[1] + 0.25*diff(lims),
                                    mean(lims),
                                    lims[2] - 0.25*diff(lims),
                                    lims[2])),
        limits  = lims,
        oob     = scales::squish,
        na.value = "grey85",
        name = "RME"
      )+
      coord_sf(expand = FALSE) +
      theme_minimal(base_size = 12, base_family = "storia-sans") +
      theme(
        panel.grid = element_blank(),
        axis.text = element_blank(),
        axis.title = element_blank(),
        legend.position = "right",
        plot.title = element_text(face = "bold"),
        plot.margin = unit(c(0, 4, 2, 2), "mm")
      ) +
      guides(fill = guide_colorbar(barheight = unit(60, "pt")))
    # 5) Girafe
    g <- girafe(ggobj = p)
    girafe_options(
      g,
      opts_tooltip(css = tooltip_css, opacity = 0.9),
      opts_hover(css = "stroke-width:1.2;")
    )
  })
}

shinyApp(ui = ui, server = server)