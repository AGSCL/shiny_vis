# (Opcional) instala si falta:
# install.packages(c("geodata","sf","dplyr","ggplot2","ggiraph","stringr","stringi","scales"))

# 0) 
gadm_l1 <- geodata::gadm(country = "CHL", level = 1, path = tempdir())
gadm_l1_sf <- sf::st_as_sf(gadm_l1)

# 1) Datos de RR por región (tal como enviaste)
df_rr <- tibble::tribble(
  ~CC1, ~E,  ~PY,   ~Y, ~region_id, ~rate_mean_100, ~rate_lcl_100, ~rate_ucl_100, ~RR_mean, ~RR_lcl, ~RR_ucl, ~Excess_mean, ~Excess_lcl, ~Excess_ucl,
  "XV", 1.8, 427.2, 7,  15,         2.1,            1.2,           3.4,           6.0,      3.4,     8.5,     8.9,          4.4,          13.4,
  "I",  0.8, 186.5, 3,  1,          2.4,            1.2,           4.1,           6.4,      3.7,     9.3,     4.3,          2.1,          6.6,
  "II", 1.6, 413.9, 12, 2,          2.9,            1.8,           4.4,           7.2,      4.9,     10.2,    10.0,         6.3,          14.9,
  "III",0.4, 96.1,  9,  3,          4.7,            2.5,           8.9,           9.1,      5.8,     16.7,    3.3,          2.0,          6.4,
  "IV", 0.8, 200.5, 8,  4,          3.4,            2.1,           5.6,           7.7,      5.2,     11.8,    5.5,          3.4,          8.8,
  "V",  3.2, 765.6, 17, 7,          2.5,            1.7,           3.5,           6.4,      4.4,     8.5,     17.3,         10.8,         23.8,
  "RM", 3.9, 1251.5,32, 6,          2.6,            1.9,           3.5,           7.6,      5.8,     10.1,    25.6,         18.5,         35.2,
  "VI", 1.3, 306.3, 5,  8,          2.4,            1.4,           3.8,           6.3,      3.8,     8.7,     7.1,          3.7,          10.4,
  "VII",1.0, 220.3, 6,  9,          3.0,            1.7,           4.9,           6.9,      4.4,     9.9,     5.9,          3.4,          8.9,
  "XVI",0.0, 0.0,   0,  16,         3.7,            1.7,           7.4,           7.3,      4.2,     11.8,    0.0,          0.0,          0.0,
  "VIII",3.3,551.2, 19, 10,         3.7,            2.5,           5.3,           6.7,      4.6,     8.8,     18.8,         12.0,         25.8,
  "IX", 0.7, 76.0,  7,  5,          5.9,            3.3,           10.5,          7.9,      5.3,     12.2,    5.0,          3.1,          8.0,
  "XIV",1.3, 195.2, 11, 14,         5.6,            3.4,           8.5,           7.9,      5.4,     11.5,    9.1,          5.9,          13.9,
  "X",  1.6, 219.6, 18, 11,         7.0,            4.5,           10.5,          9.0,      6.3,     13.5,    12.4,         8.2,          19.5,
  "XI", 0.0, 0.0,   0,  12,         6.3,            2.6,           12.6,          8.1,      4.6,     13.9,    0.0,          0.0,          0.0,
  "XII",2.1, 276.6, 18, 13,         6.3,            4.1,           9.4,           8.1,      5.8,     11.6,    15.0,         10.0,         22.4
)

# 2) Unir shapes
map_dat <- gadm_l1_sf |>
  dplyr::left_join(df_rr, by = c("CC_1"="CC1"))

# 3) Calcula tooltip y campos “seguros” 
map_dat <- dplyr::mutate(
  map_dat,
  tooltip_raw = paste0(
    NAME_1, "\n",
    "RR: ", scales::number(RR_mean, accuracy = 0.1, big.mark = ".", decimal.mark = ","),
    " (",
    scales::number(RR_lcl, accuracy = 0.1, big.mark = ".", decimal.mark = ","),
    "–",
    scales::number(RR_ucl, accuracy = 0.1, big.mark = ".", decimal.mark = ","),
    ")"
  ),
  tooltip = sanitize_attr(tooltip_raw),
  NAME_1_safe = sanitize_attr(NAME_1)
)

# 5) Redibuja 'p' (igual que antes)
p <- ggplot2::ggplot(map_dat) +
  ggiraph::geom_sf_interactive(
    ggplot2::aes(fill = RR_mean, tooltip = tooltip, data_id = NAME_1_safe),
    color = "white", size = 0.15
  ) +
  ggplot2::scale_fill_viridis_c(
    option = "magma", direction = -1, na.value = "grey85", name = "RR media"
  ) +
  ggplot2::coord_sf(expand = FALSE) +
  ggplot2::theme_minimal(base_size = 12) +
  ggplot2::theme(
    panel.grid = ggplot2::element_blank(),
    axis.text = ggplot2::element_blank(),
    axis.title = ggplot2::element_blank(),
    legend.position = "right",
    plot.title = ggplot2::element_text(face = "bold"),
    plot.margin = grid::unit(c(0, 4, 2, 2), "mm")
  ) +
  ggplot2::guides(fill = ggplot2::guide_colorbar(barheight = grid::unit(60, "pt")))

# 6) Render con girafe (como lo corregiste)
g <- ggiraph::girafe(ggobj = p, width_svg = 8, height_svg = 10)
g <- ggiraph::girafe_options(
  g,
  ggiraph::opts_tooltip(css = tooltip_css, opacity = 0.9),
  ggiraph::opts_hover(css = "stroke-width:1.2;")
)
g