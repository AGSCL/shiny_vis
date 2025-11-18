# Ejemplo ggalluvial
# DecideChile. (2025). Cuando el voto obligatorio cambia el guion: Resultados 
# presidenciales y parlamentarios, dinámicas de participación y claves para la 2da 
# vuelta del 14 de diciembre. Unholster. 
# https://www.decidechile.cl/informes/presidenciales-y-parlamentarias-2025/cuando-el-voto-obligatorio-cambia-el-guion  

library(tidyverse)
library(easyalluvial)
library(parcats)

# Crear el data.frame con los nombres con puntos (como se generan al importar datos)
df_aluvial <- data.frame(
  Plebiscito.de.Salida.2022 = c(
    "Apruebo", "Apruebo", "Apruebo", "Apruebo", "Apruebo", "Apruebo", "Apruebo",
    "Rechazo", "Rechazo", "Rechazo", "Rechazo", "Rechazo", "Rechazo", "Rechazo",
    "B, N y No vota", "B, N y No vota", "B, N y No vota", "B, N y No vota",
    "B, N y No vota", "B, N y No vota", "B, N y No vota"
  ),
  X1ra.Vuelta.Presidencial.2025 = c(
    "Jara", "B, N y No vota", "Matthei", "Kaiser", "Parisi", "Otros", "Kast",
    "Kast", "Parisi", "Kaiser", "Matthei", "B, N y No vota", "Otros", "Jara",
    "B, N y No vota", "Matthei", "Kaiser", "Jara", "Parisi", "Kast", "Otros"
  ),
  Flow_Value = c(
    60.1, 11.1, 10.4, 6.9, 5.7, 5.7, 0.1,
    43.4, 29.6, 15.0, 6.9, 4.3, 0.7, 0.1,
    78.6, 16.8, 3.8, 0.6, 0.1, 0.1, 0.1
  )
)

# Renombrar las columnas a formatos legibles usando backticks
df_aluvial <- df_aluvial %>%
  rename(
    `Plebiscito de Salida 2022` = Plebiscito.de.Salida.2022,
    `1ra Vuelta Presidencial 2025` = X1ra.Vuelta.Presidencial.2025
  )

# Escalar los valores para convertirlos en enteros
df_scaled <- df_aluvial %>%
  mutate(Flow_Value_scaled = round(Flow_Value * 10))

# Reconstruir casos según peso
df_unc <- df_scaled %>%
  tidyr::uncount(weights = Flow_Value_scaled) %>%
  mutate(id = row_number())

# Armar formato "wide" mínimo con los nombres legibles
wide <- df_unc %>%
  select(id, `Plebiscito de Salida 2022`, `1ra Vuelta Presidencial 2025`)

# Alluvial manteniendo la estructura del script original
p_alluvial <- easyalluvial::alluvial_wide(
  data = wide,
  id = "id",
  fill_by = "first_variable",
  col_vector_flow = c("#e41a1c", "#377eb8", "#4daf4a", "#984ea3", "#ff7f00", "#ffff33", "#999999"),
  auto_rotate_xlabs = TRUE,
  colorful_fill_variable_stratum = FALSE
)

# Interactivo - manteniendo dimensiones originales
parcats_plot <- parcats::parcats(
  p_alluvial,
  marginal_histograms = FALSE,
  data = wide,
  width = 840,
  height = 600
)
parcats_plot <- prependContent(
  parcats_plot,
  htmltools::h2("Plebiscito de salida 2022: Modelo de Transición de Votos")
)

parcats_plot