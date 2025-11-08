# shiny_vis: Visualización Dinámica en R

Un repositorio dedicado a explorar y desarrollar visualizaciones de datos dinámicas e interactivas utilizando el paquete [Shiny](https://shiny.rstudio.com/) en R. Para CFG 2025: Ciencia abierta y ciudadana

**Autor:** Andrés González-Santa Cruz

* Investigador Joven, Núcleo Milenio nDP

* Estudiante Doctorado en Salud Pública, Universidad de Chile

**ORCID**: [0000-0002-5166-9121](https://orcid.org/0000-0002-5166-9121)

---

## Descripción

Este proyecto sirve como un compendio de ejemplos, notas y recursos para la creación de aplicaciones web interactivas con R. El enfoque principal está en la integración de diversas bibliotecas de visualización potentes dentro del ecosistema de Shiny, permitiendo la creación de dashboards y herramientas de análisis de datos robustas.

Se requiere conocimientos previos en R y RStudio, además de contar con un computador habilitado para instalar R (4.2+), RStudio, Rtools (en Windows) o Xcode (en macOS).


## Contenido del repositorio

El repositorio está organizado en varias carpetas para facilitar la navegación y el acceso a los diferentes recursos:

* `/_style`: Archivo de diseño de la presentación.
* `/_out`: Salidas como resultado de un código.
* `/_lib`: Código detrás de la presentación y CSS.
* `/_figs`: Salidas gráficas como resultado de un código.
* `/_bib`: Bibliografía.
* `/_ex`: Ejemplos de gráficos interactivos y aplicaciones simples en Shiny.
* `/gadm`: Datos geoespaciales de divisiones administrativas (paquete `gadmR`)
* [Presentación clase (html)](clase_video.html)

## Algunas bibliotecas a explorar

El objetivo es integrar y probar diversas herramientas para la visualización de datos, tales como:

* [Plotly](https://plotly.com/r/) (y su integración con ggplot2 a través de `ggplotly`)
* [Leaflet](https://rstudio.github.io/leaflet/) (para mapas interactivos)
* [dygraphs](https://rstudio.github.io/dygraphs/) (para series de tiempo)
* [highcharter](http://jkunst.com/highcharter/)
* [D3.js](https://d3js.org/) (como base para muchas visualizaciones)
* [d3po](https://cran.r-project.org/web/packages/d3po/vignettes/d3po.html) (paquete R para D3.js)
* [ggiraph](https://davidgohel.github.io/ggiraph/) (para gráficos ggplot2 interactivos)

## Cómo empezar

Para ejecutar los ejemplos de este repositorio:

1.  Clona el repositorio:
    ```bash
    git clone https://github.com/AGSCL/shiny_vis
    cd shiny_vis
    ```
    
    o bien, descárgalo directamente desde R usando el siguiente código:
    
    ```r
    # 1. Define la URL del archivo ZIP
    url_repo <- "https://github.com/AGSCL/shiny_vis/archive/refs/heads/main.zip"
    
    # 2. Define la ubicación y nombre temporal para el archivo ZIP
    temp_zip <- tempfile(fileext = ".zip")
    
    # 3. Define la carpeta donde quieres extraer el contenido (el destino)
    #    Usa "." para el directorio de trabajo actual, o especifica una ruta.
    directorio_destino <- "./shiny_vis_descargado"
    
    # --- Ejecución ---
    
    # 4. Descarga el archivo ZIP usando la función download.file()
    #    'mode = "wb"' es crucial para archivos binarios (como ZIP) en algunos sistemas operativos.
    download.file(url = url_repo, destfile = temp_zip, mode = "wb")
    
    # 5. Descomprime el archivo en el directorio de destino
    #    'unzip()' crea la carpeta si no existe y extrae el contenido.
    unzip(zipfile = temp_zip, exdir = directorio_destino)
    
    # 6. (Opcional) Limpia el archivo ZIP temporal descargado
    unlink(temp_zip)
    
    # 7. (Opcional) Verifica el contenido y navega al directorio principal del repositorio
    #    El directorio extraído se llamará típicamente 'shiny_vis-main'
    ruta_final <- file.path(directorio_destino, "shiny_vis-main")
    print(paste("Repositorio descargado en:", ruta_final))
    # Para cambiar el directorio de trabajo a esta carpeta (como el 'cd' en bash):
    setwd(ruta_final)
    ```

2.  Asegúrate de tener R, RStudio y el paquete `shiny` instalados:
    ```r
    install.packages("shiny")
    ```

3.  Instala las dependencias adicionales utilizadas en los ejemplos:
    ```r
    # Instala los paquetes que estés utilizando
    install.packages(c("plotly", "leaflet", "ggiraph", "d3po", "dygraphs", "highcharter", "ggplot2", "remotes", "learnr"))
    ```

4.  Ejecuta una aplicación de ejemplo (p.ej., si tienes una carpeta `app_plotly`):
    ```r
    shiny::runApp("app_plotly")
    ```

## Recursos de aprendizaje

Una colección de enlaces y tutoriales clave para el desarrollo en Shiny y la visualización de datos en R.

### Recursos generales de Shiny

* [**Documentación Oficial de Shiny**](https://shiny.rstudio.com/): El mejor lugar para empezar y consultar referencias avanzadas.
* [**Guía Rápida (Cheatsheet) de Shiny en Español**](https://raw.githubusercontent.com/rstudio/cheatsheets/main/translations/spanish/shiny_es.pdf): Un PDF de referencia rápida excelente para tener a mano.

### Tutorial recomendado: Introducción a ggplot2

Si tiene tiempo, un gran punto de partida para la visualización (base de `ggplotly`) es el tutorial interactivo de [Yanina Bellini](https://github.com/yabellini).

**1. Instalación del tutorial:**
Este tutorial se instala directamente desde GitHub usando `remotes`.

```r
# Instalar el paquete 'remotes' si no lo tienes
# install.packages("remotes")

remotes::install_github("yabellini/tutorialgRaficosFN")
```

## Archivos y directorio

```
.
├── DESCRIPTION.dcf
├── LICENSE
├── README.md
├── __estructura_archivos.R
├── _bib
├── _ex
│   ├── ej1.R
│   ├── ej_alluvial_plot_plotly.R
│   ├── ej_no_shiny_ggigraph.R
│   ├── ej_no_shiny_longitudinal.R
│   ├── ej_shiny_ggplot.R
│   ├── ej_shiny_plotly.R
│   └── rsconnect
│       └── documents
│           ├── ej1.R
│           │   └── shinyapps.io
│           │       └── agscl3
│           │           └── ejemplo1.dcf
│           └── ej_shiny_plotly.R
│               └── shinyapps.io
│                   └── agscl3
│                       └── SHINYPLOTLY.dcf
├── _figs
├── _lib
│   ├── animate.min.css
│   ├── collapse-output.html
│   ├── collapseoutput.js
│   ├── custom.css
│   ├── custom_theme.scss
│   ├── graphics.css
│   ├── hideOutput.js
│   ├── logo.css
│   ├── manualcollapseinput.html
│   ├── ninjutsu.css
│   ├── theme.css
│   ├── theme2.scss
│   ├── timer-hud.js
│   ├── timer.Rmd
│   ├── timer.html
│   ├── xaringan-themer.css
│   └── zoom.html
├── _out
├── _style
│   ├── CCA-fondo.png
│   ├── CCA-franjalogos.jpg
│   ├── CCA-franjalogos_transparent.png
│   ├── CCA-pres1.potx
│   ├── CCA-pres2.potx
│   ├── CursoCiencia-Abierta-ppt1.jpg
│   ├── CursoCiencia-Abierta-ppt2.jpg
│   ├── LEEME.txt
│   ├── storia-sans
│   │   ├── StoriaSans-Bold.ttf
│   │   ├── StoriaSans-BoldItalic.ttf
│   │   ├── StoriaSans-ExtraBold.ttf
│   │   ├── StoriaSans-ExtraBoldItalic.ttf
│   │   ├── StoriaSans-ExtraLight.ttf
│   │   ├── StoriaSans-ExtraLightItalic.ttf
│   │   ├── StoriaSans-Italic.ttf
│   │   ├── StoriaSans-Light.ttf
│   │   ├── StoriaSans-LightItalic.ttf
│   │   ├── StoriaSans-Medium.ttf
│   │   ├── StoriaSans-MediumItalic.ttf
│   │   ├── StoriaSans-Regular.ttf
│   │   ├── StoriaSans-SemiBold.ttf
│   │   └── StoriaSans-SemiBoldItalic.ttf
│   └── storia-sans.zip
├── american-medical-association-10th-edition.csl
├── clase_video.html
├── clase_video.qmd
├── clase_video_files
│   ├── libs
│   │   ├── DiagrammeR-styles-0.2
│   │   │   └── styles.css
│   │   ├── crosstalk-1.2.2
│   │   │   ├── css
│   │   │   │   └── crosstalk.min.css
│   │   │   ├── js
│   │   │   │   ├── crosstalk.js
│   │   │   │   ├── crosstalk.js.map
│   │   │   │   ├── crosstalk.min.js
│   │   │   │   └── crosstalk.min.js.map
│   │   │   └── scss
│   │   │       └── crosstalk.scss
│   │   ├── grViz-binding-1.0.11
│   │   │   └── grViz.js
│   │   ├── highchart-binding-0.9.4
│   │   │   └── highchart.js
│   │   ├── highcharts-9.3.1
│   │   │   ├── css
│   │   │   │   ├── htmlwdgtgrid.css
│   │   │   │   └── motion.css
│   │   │   ├── custom
│   │   │   │   ├── appear.js
│   │   │   │   ├── delay-animation.js
│   │   │   │   ├── reset.js
│   │   │   │   ├── symbols-extra.js
│   │   │   │   ├── text-symbols.js
│   │   │   │   └── tooltip-delay.js
│   │   │   ├── highcharts-3d.js
│   │   │   ├── highcharts-more.js
│   │   │   ├── highcharts.js
│   │   │   ├── modules
│   │   │   │   ├── accessibility.js
│   │   │   │   ├── annotations-advanced.js
│   │   │   │   ├── annotations.js
│   │   │   │   ├── arrow-symbols.js
│   │   │   │   ├── boost-canvas.js
│   │   │   │   ├── boost.js
│   │   │   │   ├── broken-axis.js
│   │   │   │   ├── bullet.js
│   │   │   │   ├── coloraxis.js
│   │   │   │   ├── current-date-indicator.js
│   │   │   │   ├── cylinder.js
│   │   │   │   ├── data.js
│   │   │   │   ├── datagrouping.js
│   │   │   │   ├── debugger.js
│   │   │   │   ├── dependency-wheel.js
│   │   │   │   ├── dotplot.js
│   │   │   │   ├── drag-panes.js
│   │   │   │   ├── draggable-points.js
│   │   │   │   ├── drilldown.js
│   │   │   │   ├── dumbbell.js
│   │   │   │   ├── export-data.js
│   │   │   │   ├── exporting.js
│   │   │   │   ├── full-screen.js
│   │   │   │   ├── funnel.js
│   │   │   │   ├── funnel3d.js
│   │   │   │   ├── gantt.js
│   │   │   │   ├── grid-axis.js
│   │   │   │   ├── heatmap.js
│   │   │   │   ├── heikinashi.js
│   │   │   │   ├── histogram-bellcurve.js
│   │   │   │   ├── hollowcandlestick.js
│   │   │   │   ├── item-series.js
│   │   │   │   ├── lollipop.js
│   │   │   │   ├── map.js
│   │   │   │   ├── marker-clusters.js
│   │   │   │   ├── networkgraph.js
│   │   │   │   ├── no-data-to-display.js
│   │   │   │   ├── offline-exporting.js
│   │   │   │   ├── oldie-polyfills.js
│   │   │   │   ├── oldie.js
│   │   │   │   ├── organization.js
│   │   │   │   ├── overlapping-datalabels.js
│   │   │   │   ├── parallel-coordinates.js
│   │   │   │   ├── pareto.js
│   │   │   │   ├── pathfinder.js
│   │   │   │   ├── pattern-fill.js
│   │   │   │   ├── price-indicator.js
│   │   │   │   ├── pyramid3d.js
│   │   │   │   ├── sankey.js
│   │   │   │   ├── series-label.js
│   │   │   │   ├── solid-gauge.js
│   │   │   │   ├── sonification.js
│   │   │   │   ├── static-scale.js
│   │   │   │   ├── stock-tools.js
│   │   │   │   ├── stock.js
│   │   │   │   ├── streamgraph.js
│   │   │   │   ├── sunburst.js
│   │   │   │   ├── tilemap.js
│   │   │   │   ├── timeline.js
│   │   │   │   ├── treegrid.js
│   │   │   │   ├── treemap.js
│   │   │   │   ├── variable-pie.js
│   │   │   │   ├── variwide.js
│   │   │   │   ├── vector.js
│   │   │   │   ├── venn.js
│   │   │   │   ├── windbarb.js
│   │   │   │   ├── wordcloud.js
│   │   │   │   └── xrange.js
│   │   │   └── plugins
│   │   │       ├── draggable-legend.js
│   │   │       ├── grouped-categories.js
│   │   │       ├── highcharts-regression.js
│   │   │       ├── motion.js
│   │   │       └── multicolor_series.js
│   │   ├── htmltools-fill-0.5.8.1
│   │   │   └── fill.css
│   │   ├── htmlwidgets-1.6.4
│   │   │   └── htmlwidgets.js
│   │   ├── jquery-3.5.1
│   │   │   ├── jquery-AUTHORS.txt
│   │   │   ├── jquery.js
│   │   │   ├── jquery.min.js
│   │   │   └── jquery.min.map
│   │   ├── plotly-binding-4.11.0
│   │   │   └── plotly.js
│   │   ├── plotly-htmlwidgets-css-2.11.1
│   │   │   └── plotly-htmlwidgets.css
│   │   ├── plotly-main-2.11.1
│   │   │   └── plotly-latest.min.js
│   │   ├── proj4js-2.3.15
│   │   │   └── proj4.js
│   │   ├── revealjs
│   │   │   ├── dist
│   │   │   │   ├── reset.css
│   │   │   │   ├── reveal.css
│   │   │   │   ├── reveal.esm.js
│   │   │   │   ├── reveal.esm.js.map
│   │   │   │   ├── reveal.js
│   │   │   │   ├── reveal.js.map
│   │   │   │   └── theme
│   │   │   │       ├── fonts
│   │   │   │       │   ├── league-gothic
│   │   │   │       │   │   ├── LICENSE
│   │   │   │       │   │   ├── league-gothic.css
│   │   │   │       │   │   ├── league-gothic.eot
│   │   │   │       │   │   ├── league-gothic.ttf
│   │   │   │       │   │   └── league-gothic.woff
│   │   │   │       │   └── source-sans-pro
│   │   │   │       │       ├── LICENSE
│   │   │   │       │       ├── source-sans-pro-italic.eot
│   │   │   │       │       ├── source-sans-pro-italic.ttf
│   │   │   │       │       ├── source-sans-pro-italic.woff
│   │   │   │       │       ├── source-sans-pro-regular.eot
│   │   │   │       │       ├── source-sans-pro-regular.ttf
│   │   │   │       │       ├── source-sans-pro-regular.woff
│   │   │   │       │       ├── source-sans-pro-semibold.eot
│   │   │   │       │       ├── source-sans-pro-semibold.ttf
│   │   │   │       │       ├── source-sans-pro-semibold.woff
│   │   │   │       │       ├── source-sans-pro-semibolditalic.eot
│   │   │   │       │       ├── source-sans-pro-semibolditalic.ttf
│   │   │   │       │       ├── source-sans-pro-semibolditalic.woff
│   │   │   │       │       └── source-sans-pro.css
│   │   │   │       └── quarto-b70aa552d8d23b870ca0ff601d50ab1c.css
│   │   │   └── plugin
│   │   │       ├── highlight
│   │   │       │   ├── highlight.esm.js
│   │   │       │   ├── highlight.js
│   │   │       │   ├── monokai.css
│   │   │       │   ├── plugin.js
│   │   │       │   └── zenburn.css
│   │   │       ├── markdown
│   │   │       │   ├── markdown.esm.js
│   │   │       │   ├── markdown.js
│   │   │       │   └── plugin.js
│   │   │       ├── math
│   │   │       │   ├── katex.js
│   │   │       │   ├── math.esm.js
│   │   │       │   ├── math.js
│   │   │       │   ├── mathjax2.js
│   │   │       │   ├── mathjax3.js
│   │   │       │   └── plugin.js
│   │   │       ├── notes
│   │   │       │   ├── notes.esm.js
│   │   │       │   ├── notes.js
│   │   │       │   ├── plugin.js
│   │   │       │   └── speaker-view.html
│   │   │       ├── pdf-export
│   │   │       │   ├── pdfexport.js
│   │   │       │   └── plugin.yml
│   │   │       ├── quarto-line-highlight
│   │   │       │   ├── line-highlight.css
│   │   │       │   ├── line-highlight.js
│   │   │       │   └── plugin.yml
│   │   │       ├── quarto-support
│   │   │       │   ├── footer.css
│   │   │       │   ├── plugin.yml
│   │   │       │   └── support.js
│   │   │       ├── reveal-menu
│   │   │       │   ├── menu.css
│   │   │       │   ├── menu.js
│   │   │       │   ├── plugin.yml
│   │   │       │   ├── quarto-menu.css
│   │   │       │   └── quarto-menu.js
│   │   │       ├── search
│   │   │       │   ├── plugin.js
│   │   │       │   ├── search.esm.js
│   │   │       │   └── search.js
│   │   │       └── zoom
│   │   │           ├── plugin.js
│   │   │           ├── zoom.esm.js
│   │   │           └── zoom.js
│   │   ├── typedarray-0.1
│   │   │   └── typedarray.min.js
│   │   └── viz-1.8.2
│   │       └── viz.js
│   └── mediabag
├── gadm_chl_l1_simpl.rds
├── google_sheet_id.txt
├── prueba.R
├── rsconnect
│   └── documents
│       ├── prueba.R
│       │   └── shinyapps.io
│       │       └── agscl3
│       │           └── prueba.dcf
│       └── shiny.R
│           └── shinyapps.io
│               └── agscl3
│                   └── shiny_vis.dcf
├── shiny.R
├── shiny_vis.Rproj
└── sys
```