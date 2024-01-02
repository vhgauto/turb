#!/usr/bin/env python
# coding: utf-8

# In[1]:


# nivel de procesamiento L2A, descargo el SAFE completo, T21JUK, usando un punto sobre Corrientes
# remuevo líneas de código innecesarias
# S2B_MSIL2A_20231217T135659_N0510_R067_T21JUK_20231217T175625.SAFE
# "victor.gauto@outlook.com"
# "kcQkEstz..nh;7L'HuO~"


# In[1]:


# solicitudes HTTP
import requests

# manejo de datos
import pandas as pd

# fechas
from datetime import datetime, timedelta

# acceso a las credenciales
import os

# leo las credenciales, almacenadas en el archivo .env
from dotenv import load_dotenv

# acceso al token
import certifi

# lectura de JSON, se usa al obtener el token
import json


# In[2]:


# https://documentation.dataspace.copernicus.eu/APIs/OData.html#query-collection-of-products


# In[3]:


# URL base del catálogo
catalogue_odata_url = "https://catalogue.dataspace.copernicus.eu/odata/v1"

# fechas para la búsqueda de productos
# fecha_i = datetime.today().strftime('%Y-%m-%d')
# fecha_f = (datetime.today() + timedelta(days=1)).strftime('%Y-%m-%d')

fecha_i = "2023-12-17"
fecha_f = "2023-12-18"

# parámetros de búsqueda: S2, L2A, cobertura de nubes, ROI, rango de fechas
collection_name = "SENTINEL-2"
product_type = "S2MSI2A"
max_cloud_cover = 1
aoi = "POINT(-58.81348666883592 -27.488354054598737)"
search_period_start = f"{fecha_i}T00:00:00.000Z"
search_period_end = f"{fecha_f}T00:00:00.000Z"


# In[4]:


# término de búsqueda
search_query = f"{catalogue_odata_url}/Products?$filter=Collection/Name eq '{collection_name}' and Attributes/OData.CSC.StringAttribute/any(att:att/Name eq 'productType' and att/OData.CSC.StringAttribute/Value eq '{product_type}') and OData.CSC.Intersects(area=geography'SRID=4326;{aoi}') and ContentDate/Start gt {search_period_start} and ContentDate/Start lt {search_period_end}"


# In[5]:


# respuesta del servidor y resultado
response = requests.get(search_query).json()
result = pd.DataFrame.from_dict(response["value"])


# In[6]:


# load the environment variables from .env
load_dotenv()

username = os.environ['S2MSI_USERNAME']
password = os.environ['S2MSI_PASSWORD']

# obtengo el token
auth_server_url = "https://identity.dataspace.copernicus.eu/auth/realms/CDSE/protocol/openid-connect/token"
data = {
    "client_id": "cdse-public",
    "grant_type": "password",
    "username": username,
    "password": password,
}

response_cred = requests.post(auth_server_url, data=data, verify=True, allow_redirects=False)
access_token = json.loads(response_cred.text)["access_token"]


# In[7]:


# ID y nombre del producto a descargar
producto_id = result["Id"][0]
producto_nombre = result["Name"][0]



# In[8]:

result.to_csv("resultados.csv")


