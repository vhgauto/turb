#!/usr/bin/env Rscript

# cargo las funciones
source("scripts/funciones.R")

# cargo los paquetes
paquetes()

# extraigo el producto .zip
extraigo_zip()

# recorto el producto a roi y guardo stack
recorte()
