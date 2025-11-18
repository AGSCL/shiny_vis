library(d3po)
library(chilemapas)
library(sf)
library(dplyr)

# covidcl_comuna_cuarentena_censo_completa_RM<- rio::import("_data/covidcl_comuna_cuarentena_censo_completa_RM.dta") 
# 
# quarantine_RM_2020_06_15<- 
# covidcl_comuna_cuarentena_censo_completa_RM |> 
#   dplyr::group_by(codigo_comuna) |> 
#   dplyr::slice_max(fecha)|>  dplyr::select(codigo_region, codigo_comuna, comuna, positivos_acumulados, text)

quarantine_RM_2020_06_15<- 
structure(list(codigo_region = structure(c("13", "13", "13", 
"13", "13", "13", "13", "13", "13", "13", "13", "13", "13"), format.stata = "%-9s"), 
    codigo_comuna = structure(c("13202", "13203", "13303", "13403", 
    "13404", "13501", "13502", "13503", "13504", "13505", "13601", 
    "13602", "13603"), format.stata = "%-9s"), comuna = structure(c("Pirque", 
    "San Jose de Maipo", "Tiltil", "Calera de Tango", "Paine", 
    "Melipilla", "Alhue", "Curacavi", "Maria Pinto", "San Pedro", 
    "Talagante", "El Monte", "Isla de Maipo"), format.stata = "%-9s"), 
    positivos_acumulados = structure(c(453, 342, 226, 200, 564, 
    1528, 22, 477, 114, 77, 602, 412, 225), format.stata = "%10.0g"), 
    text = structure(c("Commune: Pirque <br> Cum.cases: 453 <br> Status: No Quarantine <br> Date: 2020-06-15", 
    "Commune: San Jose de Maipo <br> Cum.cases: 342 <br> Status: Complete Urb. Area <br> Date: 2020-06-15", 
    "Commune: Tiltil <br> Cum.cases: 226 <br> Status: Complete Urb. Area <br> Date: 2020-06-15", 
    "Commune: Calera de Tango <br> Cum.cases: 200 <br> Status: No Quarantine <br> Date: 2020-06-15", 
    "Commune: Paine <br> Cum.cases: 564 <br> Status: No Quarantine <br> Date: 2020-06-15", 
    "Commune: Melipilla <br> Cum.cases: 1528 <br> Status: Complete Urb. Area <br> Date: 2020-06-15", 
    "Commune: Alhue <br> Cum.cases: 22 <br> Status: No Quarantine <br> Date: 2020-06-15", 
    "Commune: Curacavi <br> Cum.cases: 477 <br> Status: Complete Urb. Area <br> Date: 2020-06-15", 
    "Commune: Maria Pinto <br> Cum.cases: 114 <br> Status: No Quarantine <br> Date: 2020-06-15", 
    "Commune: San Pedro <br> Cum.cases: 77 <br> Status: No Quarantine <br> Date: 2020-06-15", 
    "Commune: Talagante <br> Cum.cases: 602 <br> Status: No Quarantine <br> Date: 2020-06-15", 
    "Commune: El Monte <br> Cum.cases: 412 <br> Status: No Quarantine <br> Date: 2020-06-15", 
    "Commune: Isla de Maipo <br> Cum.cases: 225 <br> Status: No Quarantine <br> Date: 2020-06-15"
    ), format.stata = "%-9s")), class = c("grouped_df", "tbl_df", 
"tbl", "data.frame"), row.names = c(NA, -13L), groups = structure(list(
    codigo_comuna = structure(c("13202", "13203", "13303", "13403", 
    "13404", "13501", "13502", "13503", "13504", "13505", "13601", 
    "13602", "13603"), format.stata = "%-9s"), .rows = structure(list(
        1L, 2L, 3L, 4L, 5L, 6L, 7L, 8L, 9L, 10L, 11L, 12L, 13L), ptype = integer(0), class = c("vctrs_list_of", 
    "vctrs_vctr", "list"))), row.names = c(NA, -13L), .drop = TRUE, class = c("tbl_df", 
"tbl", "data.frame")))

rm_sf <- chilemapas::mapa_comunas %>%
  filter(codigo_region == "13") %>%
  st_as_sf()      # asegurar que es sf


rm_join <- rm_sf %>%
  left_join(
    quarantine_RM_2020_06_15,
    by = "codigo_comuna"
  ) %>%
  st_as_sf()   # mantener geometría

my_gradient <- c("#b2d8d8", "#66b2b2", "#008080", "#006666", "#004c4c")

ncols <- 100
pal <- colorRampPalette(my_gradient)

rm_join <- rm_join %>%
  mutate(
    positivos_acumulados = as.numeric(positivos_acumulados),
    scaled = scales::rescale(positivos_acumulados),
    color_hex = pal(ncols)[pmax(1, round(scaled * (ncols-1)) + 1)]
  )%>%
  mutate(text = gsub("<br> ?", "\n", text))


d3po(rm_join, width = 800*2, height = 600*2) %>%
  po_geomap(
    daes(
      group   = comuna,
      color   = my_gradient,
      size    = positivos_acumulados,
      tooltip = text
    )
  ) %>%
  # po_theme(
  #   padding = list(top = 100, right = 100, bottom = 100, left = 100)
  # ) %>%
  po_labels(
    title = "COVID-19 cumulative cases and\nquarantine status\n<br>RM rural communes – 2020-06-15",
    subtitle = "Source: MINSAL – Own elaboration"
  )
