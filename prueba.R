# app.R — Cuestionario original + "Para reforzar" + 2 tareas prácticas
# Nota: shinysurveys (archivado en CRAN). Instala desde GitHub si hace falta:
if (!requireNamespace("shinysurveys", quietly = TRUE)) {
  if (!requireNamespace("remotes", quietly = TRUE)) install.packages("remotes")
  remotes::install_github("jdtrat/shinysurveys")
}
library(shiny)
library(shinysurveys)
library(dplyr)
library(stringr)
library(tibble)
library(googlesheets4)

# ---------------------------
# 1) Banco de preguntas (original + 2 prácticas)
# ---------------------------
preguntas <- tibble::tribble(
  ~question, ~option, ~input_type, ~input_id, ~dependence, ~dependence_value, ~required,
  
  # Identificación
  "Tu nombre y apellido", "Escribe tu respuesta", "text", "id_nombre", NA, NA, TRUE,
  "Tu correo (para enviarte el snippet, opcional)", "tucorreo@dominio.cl", "text", "id_mail", NA, NA, FALSE,
  
  # Preferencias para generar el snippet personalizado
  "¿Con qué librería quieres practicar?", "plotly",      "select", "lib_graf",  NA, NA, TRUE,
  "¿Con qué librería quieres practicar?", "highcharter", "select", "lib_graf",  NA, NA, TRUE,
  
  "¿Qué tipo de gráfico quieres generar?", "Torta (pie)", "mc", "tipo_plot", NA, NA, TRUE,
  "¿Qué tipo de gráfico quieres generar?", "Barras",      "mc", "tipo_plot", NA, NA, TRUE,
  "¿Qué tipo de gráfico quieres generar?", "Líneas",      "mc", "tipo_plot", NA, NA, TRUE,
  
  "Elige un set de datos de ejemplo", "Consumo de sustancias (categoría, n)", "select", "data_demo", NA, NA, TRUE,
  "Elige un set de datos de ejemplo", "Serie mensual ficticia (fecha, valor)", "select", "data_demo", NA, NA, TRUE,
  
  # Conceptuales (como en el cuestionario 1)
  "En Shiny, ¿dónde van los sliders, inputs, etc.?", "ui (interfaz de usuario)", "mc", "q_ui", NA, NA, TRUE,
  "En Shiny, ¿dónde van los sliders, inputs, etc.?", "server (lógica)",          "mc", "q_ui", NA, NA, TRUE,
  
  "¿Qué función enlaza un objeto reactivo con un gráfico base R?", "renderPlot()", "mc", "q_render", NA, NA, TRUE,
  "¿Qué función enlaza un objeto reactivo con un gráfico base R?", "plotOutput()", "mc", "q_render", NA, NA, TRUE,
  
  "Secuencia correcta del flujo reactivo", "input → reactivo → render → output", "mc", "q_flujo", NA, NA, TRUE,
  "Secuencia correcta del flujo reactivo", "output → render → input → reactivo", "mc", "q_flujo", NA, NA, TRUE,
  
  "¿Cómo defines un objeto reactivo que depende de un input?", "reactive({ ... })", "mc", "q_reactive", NA, NA, TRUE,
  "¿Cómo defines un objeto reactivo que depende de un input?", "observeEvent(...)",  "mc", "q_reactive", NA, NA, TRUE,
  
  "¿Qué función convierte un ggplot en interactivo con plotly?", "ggplotly()", "mc", "q_ggplotly", NA, NA, TRUE,
  "¿Qué función convierte un ggplot en interactivo con plotly?", "plot_ly()",  "mc", "q_ggplotly", NA, NA, TRUE,
  
  "Para barras interactivas en highcharter, ¿cuál usarías?", "hchart()",        "mc", "q_hchart", NA, NA, TRUE,
  "Para barras interactivas en highcharter, ¿cuál usarías?", "hc_add_theme()",  "mc", "q_hchart", NA, NA, TRUE,
  
  "¿Necesitas saber JavaScript para una app básica de Shiny?", "Sí", "y/n", "q_js", NA, NA, TRUE,
  "¿Necesitas saber JavaScript para una app básica de Shiny?", "No", "y/n", "q_js", NA, NA, TRUE,
  
  # ---------------------------
  # NUEVAS TAREAS PRÁCTICAS
  # ---------------------------
  
  # Práctica 1 (plotly o highcharter, torta): deben ejecutar un pie con el dataset clásico
  # Datos sugeridos (como en las diapositivas):
  # categoria = c("Antidepresivos","Marihuana","Ansiolíticos","Alcohol","Hipnóticos","Cocaína")
  # n = c(120, 90, 70, 25, 18, 10)
  "Práctica 1 — Haz un gráfico de torta con el dataset de categorías (plotly o highcharter). Responde: ¿cuál es la SUMA total de 'n'?",
  "Escribe un número (p.ej. 123)", "text", "q_prac1_sum", NA, NA, TRUE,
  
  # Práctica 2 (líneas): deben ejecutar una serie mensual (como la del slide 3)
  # Sugerencia de generación:
  # fechas <- seq(as.Date('2017-11-01'), as.Date('2023-02-01'), by='1 month')
  # length(fechas) == 64
  "Práctica 2 — Genera una serie mensual (líneas). Responde: ¿cuántos MESES se grafican si usas 2017-11-01 a 2023-02-01 por mes?",
  "Escribe un número (p.ej. 12)", "text", "q_prac2_nmeses", NA, NA, TRUE
)

# Clave correcta para scoring (incluye prácticas)
clave <- tibble::tribble(
  ~question_id,   ~respuesta_ok,
  "q_ui",         "ui (interfaz de usuario)",
  "q_render",     "renderPlot()",
  "q_flujo",      "input → reactivo → render → output",
  "q_reactive",   "reactive({ ... })",
  "q_ggplotly",   "ggplotly()",
  "q_hchart",     "hchart()",
  "q_js",         "No",
  "q_prac1_sum",  "333",   # 120+90+70+25+18+10
  "q_prac2_nmeses","64"    # meses entre 2017-11-01 y 2023-02-01
)

# ---------------------------
# 2) Generador de snippet (conservado del cuestionario 1)
# ---------------------------
generar_codigo <- function(lib, tipo, data_demo, suavizar_linea = FALSE) {
  if (data_demo == "Consumo de sustancias (categoría, n)") {
    data_def <- paste(
      'df <- tibble::tibble(',
      '  categoria = c("Antidepresivos","Marihuana","Ansiolíticos","Alcohol","Hipnóticos","Cocaína"),',
      '  n = c(120, 90, 70, 25, 18, 10)',
      ')',
      sep = "\n"
    )
    if (lib == "plotly" && tipo == "Torta (pie)") {
      graf <- paste(
        'plotly::plot_ly(',
        '  df, labels = ~categoria, values = ~n, type = "pie",',
        '  textinfo = "label+percent", hovertemplate = "<b>%{label}</b><br>N: %{value}<extra></extra>"',
        ') |> plotly::layout(title = "Distribución de consumo (ficticio)")',
        sep = "\n"
      )
    } else if (lib == "plotly" && tipo == "Barras") {
      graf <- paste(
        'plotly::plot_ly(df, x = ~categoria, y = ~n, type = "bar") |>',
        '  plotly::layout(title = "Recuento por categoría (ficticio)",',
        '                 xaxis = list(title = "Categoría"),',
        '                 yaxis = list(title = "N"))',
        sep = "\n"
      )
    } else if (lib == "highcharter" && tipo == "Barras") {
      graf <- paste(
        'highcharter::hchart(df, "column", highcharter::hcaes(x = categoria, y = n)) |>',
        '  highcharter::hc_title(text = "Recuento por categoría (ficticio)") |>',
        '  highcharter::hc_yAxis(title = list(text = "N")) |>',
        '  highcharter::hc_xAxis(title = list(text = "Categoría"))',
        sep = "\n"
      )
    } else {
      # si hay mismatch, caer a Barras
      if (lib == "plotly") {
        graf <- 'plotly::plot_ly(df, x = ~categoria, y = ~n, type = "bar")'
      } else {
        graf <- 'highcharter::hchart(df, "column", highcharter::hcaes(x = categoria, y = n))'
      }
    }
    
  } else {
    # Serie temporal
    data_def <- paste(
      'set.seed(123)',
      'fechas <- seq(as.Date("2019-01-01"), by = "1 month", length.out = 36)',
      'valor  <- round(50 + 10*sin(2*pi*(1:36)/12) + rnorm(36, 0, 5))',
      'df     <- tibble::tibble(fecha = fechas, valor = valor)',
      sep = "\n"
    )
    if (lib == "plotly" && tipo == "Líneas") {
      graf <- paste(
        'plotly::plot_ly(df, x = ~fecha, y = ~valor, type = "scatter", mode = "lines") |>',
        '  plotly::layout(title = "Serie mensual (ficticia)",',
        '                 xaxis = list(title = "Fecha"),',
        '                 yaxis = list(title = "Valor"))',
        sep = "\n"
      )
      if (isTRUE(suavizar_linea)) {
        graf <- paste(
          graf,
          ' # Suavizado simple (media móvil de 3 meses)',
          'df$suav <- stats::filter(df$valor, rep(1/3, 3), sides = 2)',
          'plotly::add_lines(y = ~suav, name = "Suavizada")',
          sep = "\n"
        )
      }
    } else if (lib == "highcharter" && tipo == "Líneas") {
      graf <- paste(
        'highcharter::hchart(df, "line", highcharter::hcaes(x = fecha, y = valor)) |>',
        '  highcharter::hc_title(text = "Serie mensual (ficticia)") |>',
        '  highcharter::hc_xAxis(type = "datetime")',
        sep = "\n"
      )
    } else if (tipo == "Barras") {
      if (lib == "plotly") {
        graf <- 'plotly::plot_ly(df, x = ~fecha, y = ~valor, type = "bar")'
      } else {
        graf <- 'highcharter::hchart(df, "column", highcharter::hcaes(x = fecha, y = valor))'
      }
    } else {
      # fallback sensato
      if (lib == "plotly") {
        graf <- 'plotly::plot_ly(df, x = ~fecha, y = ~valor, type = "scatter", mode = "lines")'
      } else {
        graf <- 'highcharter::hchart(df, "line", highcharter::hcaes(x = fecha, y = valor))'
      }
    }
  }
  
  paste(
    "# --- Librerías ---",
    "library(tibble)",
    if (lib == "plotly") "library(plotly)" else "library(highcharter)",
    "",
    "# --- Datos de ejemplo ---",
    data_def, "",
    "# --- Gráfico ---",
    graf, "",
    sep = "\n"
  )
}

# ---------------------------
# 3) UI
# ---------------------------

library(bslib)

ui <- fluidPage(
  tags$head(
    # Carga de fuente Storia Sans
    tags$style(HTML("
      @font-face {
        font-family: 'Storia Sans';
        src: url('_style/storia-sans/StoriaSans-Regular.ttf') format('truetype');
        font-weight: normal;
        font-style: normal;
      }

      body, .container, .survey-container {
        background-color: #F7F7F7 !important;
        color: #595959 !important;
        font-family: 'Storia Sans', sans-serif !important;
      }

      h1, h2, h3, .survey-title {
        font-family: 'Storia Sans', sans-serif !important;
        color: #619CFF !important;
      }

      a, .survey-description, .question {
        color: #595959 !important;
      }

      a:hover {
        color: #9682fc !important;
      }

      input[type=text], select, textarea {
        border: 1px solid #619CFF !important;
        background-color: #ffffff !important;
        font-family: 'Storia Sans', sans-serif !important;
      }

      .btn-primary, .action-button, button {
        background-color: #619CFF !important;
        border-color: #619CFF !important;
        color: white !important;
        font-family: 'Storia Sans', sans-serif !important;
      }

      .btn-primary:hover, .action-button:hover {
        background-color: #9682fc !important;
        border-color: #9682fc !important;
      }

      .progress-bar {
        background-color: #01c9ad !important;
      }

      ::selection {
        background-color: #01c9ad !important;
        color: white !important;
      }
    "))
  ),
  tags$head(tags$title("Prueba: Visualización dinámica")),
  h4("Instrucciones de prácticas"),
  tags$ul(
    tags$li(HTML("<b>Práctica 1:</b> crea una torta (pie) con las categorías y n del ejemplo. Luego responde la suma total de <code>n</code>.")),
    tags$li(HTML("<b>Práctica 2:</b> crea una serie mensual (líneas). Sugerencia: usa <code>fechas &lt;- seq(as.Date('2017-11-01'), as.Date('2023-02-01'), by='1 month')</code> y responde cuántos meses obtienes."))
  ),
  hr(),
  surveyOutput(
    df = preguntas,
    survey_title       = "Prueba didáctica: Visualización dinámica con Shiny",
    survey_description = "Responde, recibe feedback para reforzar y descarga un snippet personalizado.",
    theme = "#F7F7F7"
  )
)

# ---------------------------
# 4) Server: render, scoring, "Para reforzar" y snippet descargable
# ---------------------------
server <- function(input, output, session) {
  renderSurvey()
  
  observeEvent(input$submit, {
    # Respuestas del/la estudiante
    resp <- getSurveyData() %>%
      select(subject_id, question_id, question_type, response)
    
    # Normalizar campos numéricos de prácticas (permitimos espacios)
    resp <- resp %>%
      mutate(response_norm = case_when(
        question_id %in% c("q_prac1_sum", "q_prac2_nmeses") ~ str_extract(response, "\\d+"),
        TRUE ~ response
      ))
    
    # Estructura de guardado
    registro <- resp %>%
      mutate(
        fecha = Sys.time(),
        nombre = resp$response[resp$question_id == "id_nombre"][1],
        correo = resp$response[resp$question_id == "id_mail"][1]
      )
    
    #googlesheets4::gs4_auth()
    googlesheets4::gs4_auth(cache = ".secrets")
    
    if (file.exists("google_sheet_id.txt")) {
      Sys.setenv(GOOGLE_SHEET_ID = readLines("google_sheet_id.txt", warn = FALSE)[1])
    }
    
    # ID o URL del Google Sheets
    sheet_id <- Sys.getenv("GOOGLE_SHEET_ID")
    
    # Escribir en la hoja (añadiendo al final)
    googlesheets4::sheet_append(ss = sheet_id, data = registro)
    
    # Calificación (join con clave)
    calif <- resp %>%
      inner_join(clave, by = "question_id") %>%
      mutate(correcto = response_norm == respuesta_ok)
    
    n_items   <- nrow(calif)
    aciertos  <- sum(calif$correcto, na.rm = TRUE)
    puntaje   <- paste0(aciertos, " / ", n_items)
    
    # Preferencias para generar el snippet (conservadas del cuestionario 1)
    lib   <- resp %>% filter(question_id == "lib_graf")   %>% pull(response) %>% .[1]
    tipo  <- resp %>% filter(question_id == "tipo_plot")  %>% pull(response) %>% .[1]
    datos <- resp %>% filter(question_id == "data_demo")  %>% pull(response) %>% .[1]
    
    # (Opcional) si quieres suavizado solo cuando eligieron Líneas:
    suav <- FALSE
    
    codigo <- generar_codigo(lib, tipo, datos, suavizar_linea = suav)
    
    # --- "Para reforzar": solo los ítems incorrectos + explicación breve ---
    explicaciones <- tibble::tribble(
      ~question_id,        ~etiqueta,                       ~explicacion,
      "q_ui",              "Ubicación de inputs",           "Los inputs se declaran en la UI; el server procesa la lógica.",
      "q_render",          "Vínculo a output base R",       "renderPlot() crea la salida reactiva para plotOutput().",
      "q_flujo",           "Flujo reactivo",                "input → reactivo → render → output es el orden correcto.",
      "q_reactive",        "Objeto reactivo",               "reactive({...}) devuelve un valor reactivo; observeEvent(...) dispara efectos.",
      "q_ggplotly",        "De ggplot a interactivo",       "ggplotly() envuelve un ggplot y lo vuelve interactivo.",
      "q_hchart",          "Barras en highcharter",         "hchart() dibuja; hc_add_theme() aplica temas, no grafica.",
      "q_js",              "¿JS necesario?",                "Para una app básica no necesitas JS; ayuda para personalizaciones.",
      "q_prac1_sum",       "Práctica 1 (torta)",            "Suma las 'n' del dataset (debería darte 333).",
      "q_prac2_nmeses",    "Práctica 2 (líneas)",           "Con seq mensual 2017-11-01 a 2023-02-01 obtienes 64 meses."
    )
    
    reforzar <- calif %>%
      filter(!correcto) %>%
      left_join(explicaciones, by = "question_id") %>%
      mutate(tu_respuesta = ifelse(is.na(response_norm) | response_norm == "", "(vacío)", response_norm)) %>%
      select(etiqueta, tu_respuesta, explicacion)
    
    # Archivo descargable con el snippet
    output$dl_snippet <- downloadHandler(
      filename = function() {
        base <- paste0("snippet_", tolower(lib), "_", stringr::str_replace_all(tolower(tipo), "\\s+|\\(|\\)", "_"), ".R")
        gsub("_+", "_", base)
      },
      content = function(file) {
        writeLines(codigo, file)
      }
    )
    
    # Modal con resultados
    showModal(modalDialog(
      title = "¡Resultados de tu prueba!",
      size  = "l",
      easyClose = TRUE,
      footer = tagList(
        modalButton("Cerrar"),
        downloadButton("dl_snippet", "Descargar snippet (.R)")
      ),
      h4("Puntaje conceptos/prácticas:"),
      p(strong(puntaje)),
      if (nrow(reforzar) > 0) {
        tagList(
          hr(), h4("Para reforzar:"),
          tags$ul(lapply(seq_len(nrow(reforzar)), function(i) {
            tags$li(
              tags$b(reforzar$etiqueta[i]), ": ",
              reforzar$explicacion[i],
              tags$br(), em("Tu respuesta: "), code(reforzar$tu_respuesta[i])
            )
          }))
        )
      } else {
        tagList(hr(), p("¡Excelente! Todas correctas ✨"))
      },
      hr(), h4("Snippet para practicar (según tus elecciones):"),
      tags$pre(style = "white-space: pre-wrap; font-size: 12px;", codigo)
    ))
  })
}

shinyApp(ui, server)
