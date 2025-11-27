library(sf)
library(ggiraph)
library(showtext)

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

# 1) Mapa base (gadm chile L1)
url_chile <- "https://raw.githubusercontent.com/AGSCL/shiny_vis/main/gadm_chl_l1_simpl.rds"
con <- url(url_chile, "rb")
gadm_l1_sf <- readRDS(con)
close(con)

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
    #limpiamos para evitar problemas con formato HTML
    tooltip = sanitize_attr(tooltip_raw),
    NAME_1_safe = sanitize_attr(NAME_1)
  )
# 30b) Re-adjunta la geometría original
map_dat <- sf::st_set_geometry(attrs, sf::st_geometry(shp))

# Escalar los límites para el gradiente
lims <- quantile(map_dat$RR_mean, c(.02, .98), na.rm=T)

# 3a. Registrar la fuente (ajusta la ruta)
# El nombre de la familia ('storia-sans') es lo que usarás en theme_minimal
# 3b. Habilitar showtext para que los dispositivos gráficos usen la fuente
showtext::showtext_auto()
  sysfonts::font_add(family = "storia-sans", regular = "_style/storia-sans/StoriaSans-Regular.ttf")
  showtext::showtext_auto()

# 4) Plot
p <- ggplot(map_dat) +
  #Tooltip interativo, que es la ventanita que sobresale con la información
  geom_sf_interactive(
    aes(fill = RR_mean, tooltip = tooltip, data_id = NAME_1_safe),
    color = "white", size = 0.15
  )+
  scale_fill_gradientn( #pasamos una variable continua a un rango de colores, en base a percentil 25, 50 y 75
    colours = c("#F7F7F7", "#01C9AD", "#619CFF", "#9682FC", "#595959"),
    values  = scales::rescale(c(lims[1], 
                                lims[1] + 0.25*diff(lims),
                                mean(lims),
                                lims[2] - 0.25*diff(lims),
                                lims[2])),
    limits  = lims,
    oob     = scales::squish, #un valor fuera de los límites se asigna al color más cercano
    na.value = "darkred",#datos perdidos en rojo oscuro
    name = "RME" #nombre leyenda
  )+
  theme_minimal(base_size = 12, base_family = "storia-sans") +
  theme(
    panel.grid = element_blank(),
    axis.text = element_blank(),
    axis.title = element_blank(),
    legend.position = "right",
    plot.title = element_blank(),
    plot.margin = unit(c(0, 4, 2, 2), "mm")
  )

# 5) Girafe
g <- ggiraph::girafe(ggobj = p) #lo hacemos más interactivo
ggiraph::girafe_options(
  g,
  opts_tooltip(css = tooltip_css, opacity = 0.9), #apariencia de la ventanita, ligeramente transparente (90%)
  opts_hover(css = "stroke-width:1.2;"), #al pasar el mouse, borde un poco más grueso
  opts_zoom(min = 1, max = 4) # Añadimos zoom
)