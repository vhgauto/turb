########### 1. Inicio ######################################

paquetes <- function() {
  library(sf)
  library(terra)
  library(glue)
  library(tidyverse)
  
  # mensaje en consola
  glue("\n\nPaquetes cargados correctamente\n\n")
}

extraigo_zip <- function(x) {
  unzip(zipfile = "producto.zip", exdir = "safe/")

  # mensaje en consola
  glue("\n\nProducto extraido\n\n")
}

recorte <- function() {
  
  print(glue("\n\nLeo el producto S2-MSI L2A\n\n"))

  safe <- list.files("safe/", pattern = "SAFE")
  safe_fecha <- str_sub(safe, start = 12, end = 19)
  
  # carpeta con las carpetas de distintas resoluciones
  carpeta1 <- glue("safe/{safe}/GRANULE")
  carpeta2 <- list.files(carpeta1)
  carpeta3 <- glue("{carpeta1}/{carpeta2}/IMG_DATA")
  carpeta4 <- glue("{carpeta1}/{carpeta2}/QI_DATA") # nubes
  
  r10m <- list.files(glue("{carpeta3}/R10m"), full.names = TRUE)
  r20m <- list.files(glue("{carpeta3}/R20m"), full.names = TRUE)
  
  # nombres de las bandas en el orden correcto
  bandas_nombres <- c("B01", "B02", "B03", "B04", "B05", "B06", "B07", "B08", "B8A", 
    "B11", "B12", "QA60")
  
  # caminos para cada archivo de la banda requerida
  b01 <- r20m[2]
  b02 <- r10m[2]
  b03 <- r10m[3]
  b04 <- r10m[4]
  b05 <- r20m[6]
  b06 <- r20m[7]
  b07 <- r20m[8]
  b08 <- r10m[5]
  b8a <- r20m[11]
  b11 <- r20m[9]
  b12 <- r20m[10]
  qa60 <- glue("{carpeta4}/MSK_CLDPRB_20m.jp2") # nubes
  
  # vector de los caminos de los archivos en el orden correcto
  vector_bandas <- c(b01, b02, b03, b04, b05, b06, b07, b08, b8a, b11, b12, qa60)
  
  # leo los archivos
  lista_bandas <-  map(vector_bandas, rast)
  names(lista_bandas) <- bandas_nombres
  
  print(glue("\n\nRecorto y reproyecto el producto\n\n"))
  
  # vector para recortar los raster alrededor del puente
  recorte_puente <- vect("vectores/recorte_puente.gpkg")
  
  # recorte de cada elemento de la lista con el vector puente
  lista_recortes <- map(
    .x = lista_bandas, 
    ~terra::crop(x = .x, y = recorte_puente))
  
  # los raster de 20m los reproyecto a 10m
  lista_recortes$B01 <- project(lista_recortes$B01, lista_recortes$B02)
  lista_recortes$B05 <- project(lista_recortes$B05, lista_recortes$B02)
  lista_recortes$B06 <- project(lista_recortes$B06, lista_recortes$B02)
  lista_recortes$B07 <- project(lista_recortes$B07, lista_recortes$B02)
  lista_recortes$B8A <- project(lista_recortes$B8A, lista_recortes$B02)
  lista_recortes$B11 <- project(lista_recortes$B11, lista_recortes$B02)
  lista_recortes$B12 <- project(lista_recortes$B12, lista_recortes$B02)
  lista_recortes$QA60 <- project(lista_recortes$QA60, lista_recortes$B02)
  
  # creamos un stack con todas las bandas recortadas y la misma resolucion espacial (10m)
  stack_bandas <- rast(lista_recortes)
  
  # guardo stack recortado
  writeRaster(stack_bandas, glue("raster/{safe_fecha}.tif"), overwrite = TRUE)
  
  print(glue("\n\nStack guardado\n\n"))

  # genero imagen RGB del stack
  png("figuras/rgb.png", width = 1500, height = 1500, units = "px")
  terra::plotRGB(
    stack_bandas, r = 4, g = 3, b = 2, scale = 5e4, stretch = "lin")
  dev.off()

  # elimino .zip y SAFE del producto
  file.remove("safe/producto.zip")
  unlink(glue("safe/{safe}"), recursive = TRUE)

  print(glue("\n\nElimino .zip y SAFE del producto\n\n"))
}