# Created by use_targets().
# Follow the comments below to fill in this target script.
# Then follow the manual to check and run the pipeline:
#   https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline

# https://raps-with-r.dev/targets.html

# Load packages required to define the pipeline:
library(targets)

# Set target options:
tar_option_set(
  packages = c(
    "tibble", "terra", "glue", "tidyverse")
)

options(clustermq.scheduler = "multicore")

# Run the R scripts in the R/ folder with your custom functions:
tar_source("scripts/funciones.R")

# C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe

list(
  tar_target(
    name = archivo_zip,
    command = path_data(descarga_s2),
    format = "file"
  ),
  tar_target(
    name = descarga_s2,
    command = descarga_safe()
  ),
  tar_target(
    name = producto_tif,
    command = creo_stack(archivo_zip)
  ),
  tar_target(
    name = archivo_tif,
    command = path_data(producto_tif),
    format = "file"
  ),
  tar_target(
    name = rgb_png,
    command = creo_rgb(archivo_tif)
  )
)
