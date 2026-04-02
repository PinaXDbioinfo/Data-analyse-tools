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

## Output example

```csv
"ids","calle","numero","colonia","codigo_postal","ciudad","estado","pais","ID2","link","lat","lon"
1,"Av. Constituyentes",123,"Centro",76000,"Querétaro","Querétaro","México",0,"https://geocode.maps.co/search?q=AV+CONSTITUYENTES+123+CENTRO+76000+QUERETARO+QUERETARO+MEXICO&api_key=69caf2e42146e107445353kejb9e5c8","20.5852444","-100.3909635"
2,"Av. Zaragoza",156,"Centro",76000,"Querétaro","Querétaro","México",0,"https://geocode.maps.co/search?q=AV+ZARAGOZA+156+CENTRO+76000+QUERETARO+QUERETARO+MEXICO&api_key=69caf2e42146e107445353kejb9e5c8","20.5892596","-100.3886966"
3,"Calle Morelos",34,"El Pueblito",76900,"Corregidora","Querétaro","México",0,"https://geocode.maps.co/search?q=CALLE+MORELOS+34+EL+PUEBLITO+76900+CORREGIDORA+QUERETARO+MEXICO&api_key=69caf2e42146e107445353kejb9e5c8","20.5564143","-100.4343691"
3,"Calle Morelos",34,"El Pueblito",76900,"Corregidora","Querétaro","México",1,"https://geocode.maps.co/search?q=CALLE+MORELOS+34+EL+PUEBLITO+76900+CORREGIDORA+QUERETARO+MEXICO&api_key=69caf2e42146e107445353kejb9e5c8","20.5275252","-100.4639627"
4,"Av. Tecnológico",500,"Centro",76150,"Querétaro","Querétaro","México",0,"https://geocode.maps.co/search?q=AV+TECNOLOGICO+500+CENTRO+76150+QUERETARO+QUERETARO+MEXICO&api_key=69caf2e42146e107445353kejb9e5c8","20.5953488","-100.4069528"
4,"Av. Tecnológico",500,"Centro",76150,"Querétaro","Querétaro","México",1,"https://geocode.maps.co/search?q=AV+TECNOLOGICO+500+CENTRO+76150+QUERETARO+QUERETARO+MEXICO&api_key=69caf2e42146e107445353kejb9e5c8","20.5894252","-100.4043594"
```

## Usage

bash geocode_pipeline.sh input.csv YOUR_API_KEY

## Output

results/input_with_coords.csv

## Author

José Emilio Ramírez Piña
