library(data.tree)
library(stringr)

# 1) Listar rutas relativas (archivos + directorios)
ruta_carpeta <- "."

# usa list.dirs para asegurar que los directorios estén presentes
dirs  <- list.dirs(ruta_carpeta, recursive = TRUE, full.names = FALSE)
files <- list.files(ruta_carpeta, recursive = TRUE, full.names = FALSE, include.dirs = FALSE)
paths <- unique(c(dirs, files))

# normaliza separadores y elimina posibles cadenas vacías / "."
paths <- gsub("\\\\", "/", paths, fixed = FALSE)
paths <- paths[!(paths %in% c("", "."))]

# 2) Construir pathString con raíz explícita
#    (data.tree espera una columna llamada EXACTAMENTE 'pathString')
pathString <- vapply(strsplit(paths, "/", fixed = TRUE), function(parts) {
  parts <- parts[nzchar(parts)]  # quita elementos vacíos
  paste(c("root", parts), collapse = "/")
}, FUN.VALUE = character(1))

df_paths <- data.frame(pathString = pathString, stringsAsFactors = FALSE)

# 3) Construir el árbol
arbol_carpeta <- data.tree::as.Node(df_paths, pathDelimiter = "/")

# 4) Visualizar la estructura del árbol
txt <- capture.output(fs::dir_tree(".", recurse = TRUE))
# Copiar/pegar manual en README:
cat(paste(txt, collapse = "\n"))