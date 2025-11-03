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
    git clone [URL_DE_TU_REPOSITORIO_AQUÍ]
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
├── DESCRIPTION.dcf
├── LICENSE
├── README.md
├── __estructura_archivos.R
├── _bib
├── _ex
│   ├── ej_no_shiny_ggigraph.R
│   ├── ej_no_shiny_longitudinal.R
│   ├── ej_shiny_ggplot.R
│   └── ej_shiny_plotly.R
├── _figs
├── _lib
│   ├── animate.min.css
│   ├── collapse-output.html
│   ├── collapseoutput.js
│   ├── custom.css
│   ├── graphics.css
│   ├── hideOutput.js
│   ├── logo.css
│   ├── manualcollapseinput.html
│   ├── ninjutsu.css
│   ├── theme.css
│   ├── theme2.scss
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
├── gadm_chl_l1_simpl.rds
├── rsconnect
│   └── documents
│       └── shiny.R
│           └── shinyapps.io
│               └── agscl3
│                   └── shiny_vis.dcf
├── shiny.R
├── shiny_vis.Rproj
└── sys
```