import pandas as pd
import plotly.express as px
import json
import argparse

# Argument parser
parser = argparse.ArgumentParser(description='Process a CSV file.')
parser.add_argument('csvfile', type=str, help='The CSV file to process')
args = parser.parse_args()

deptoNamesDict = {
    'guatemala': 'Guatemala',
    'el progreso': 'El Progreso',
    'sacatepéquez': 'Sacatepéquez',
    'chimaltenango': 'Chimaltenango',
    'escuintla': 'Escuintla',
    'santa rosa': 'Santa Rosa',
    'sololá': 'Sololá',
    'totonicapán': 'Totonicapán',
    'quetzaltenango': 'Quetzaltenango',
    'suchitepéquez': 'Suchitepéquez',
    'retalhuleu': 'Retalhuleu',
    'san marcos': 'San Marcos',
    'huehuetenango': 'Huehuetenango',
    'quiché': 'Quiché',
    'baja verapaz': 'Baja Verapaz',
    'alta verapaz': 'Alta Verapaz',
    'petén': 'Petén',
    'izabal': 'Izabal',
    'zacapa': 'Zacapa',
    'chiquimula': 'Chiquimula',
    'jalapa': 'Jalapa',
    'jutiapa':  'Jutiapa'
}

# Load the csv file
df = pd.read_csv(args.csvfile)

# Clean the 'name' column
df['name'] = df['name'].str.replace('"', '')
# Using the dictionary to replace the department names
df['name'] = df['name'].str.lower()
df['name'] = df['name'].replace(deptoNamesDict)

# Load the GeoJSON file
with open('geoBoundaries-GTM-ADM1_simplified.geojson', 'r', encoding='utf-8') as f:
    geojson = json.load(f)

# Create the choropleth map
fig = px.choropleth_mapbox(df,
                           geojson=geojson,
                           featureidkey='properties.shapeName',
                           locations='name',
                           color='communityId',
                           center={"lat": 15.5, "lon": -90.25},
                           mapbox_style="carto-positron", zoom=5)

fig.show()
