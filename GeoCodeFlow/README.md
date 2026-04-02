# GeoCodeFlow 

### Automated Address Geocoding Pipeline

## Description

GeoCodeFlow is a reproducible pipeline that automates the process of
converting structured address data into geographic coordinates using a
geocoding API.

The pipeline: - Cleans and normalizes address data\
- Queries a geocoding API\
- Parses JSON responses\
- Merges coordinates back into the original dataset

## Input File

CSV with columns: street, number, neighborhood, postal_code, city,
state, country

is necesary a API_KEY from the website geocode https://geocode.maps.co
## Output File

here you can find a example output with the name output.csv

This is the info of the table
- ids=is an id that is assigned to the input data
- street=is the street from the input data
- number=is the number from the input data
- neighborhood=is the neighborhood from the input data
- zip_code= is the zip code from the input data
- city= is the city from the input data
- state= is the state from the input data
- country= is the country from the input data
- ID2= is the row number from the json file downloaded with the coordenates, if the geocode query find more of one coordenate all the coordenates will be contained in the table
- link= is the link for the query
- lat=latittude
- lon=longitude

## Usage

bash geocode_pipeline.sh input.csv YOUR_API_KEY

## Output

results/input_with_coords.csv

## Author

José Emilio Ramírez Piña
