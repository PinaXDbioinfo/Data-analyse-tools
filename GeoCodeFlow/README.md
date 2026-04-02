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

## Usage

bash geocode_pipeline.sh input.csv YOUR_API_KEY

## Output

results/input_with_coords.csv

## Author

José Emilio Ramírez Piña
