#!/bin/bash
#This pipeline is for automatition of coordinates obtention using the program geocode api

#Variable asignation
file=$1
api_key=$2

dir=$(pwd)
mkdir -p "${dir}/logs"
exec > >(tee -a "${dir}/logs/pipeline.log") 2> >(tee -a "${dir}/logs/error.log" >&2)

#data preparation
echo "---PREPARING DATA---"
#directories creation
echo "creating directories"
mkdir -p "${dir}/results"
mkdir -p "${dir}/results/json_files"

#files creation
echo "creating files"
echo "ID,ID2,link,lat,lon" > ${dir}/results/coords.csv

#determinating data size
n=$(wc -l < "$file")
temp=$((${n} - 1))
echo "number of addresses: ${temp}"

#starting de process
echo "---STARTING ADRESS OBTAINIG---"

for i in $(seq 2 $n)
do
#check if exist temporal files
if [[ -f "link.txt" && -f "temp.json" ]]; then
    rm -f link.txt temp.json
fi
#obtaining i adress
real_id=$((${i} - 1))
row=$(awk "NR==${i}" "${file}")

echo "**Obtaining coordinates for the address: ${real_id} ${row}**"
Rscript -e '
args <- commandArgs(trailingOnly = TRUE)
adress <- args[1]
key <- args[2]
library(stringi)

quit_accent <- function(x) {
  x <- stri_replace_all_fixed(x, "ñ", "___enie___")
  x <- stri_replace_all_fixed(x, "Ñ", "___ENIE___")
  x <- stri_trans_general(x, "Latin-ASCII")
  x <- stri_replace_all_fixed(x, "___enie___", "ñ")
  x <- stri_replace_all_fixed(x, "___ENIE___", "Ñ")
  return(x)
}

cols <- strsplit(adress, ",")[[1]]

cat("Cleaning the address","\n")

s<-gsub(" ","+",toupper(gsub("[./]","",quit_accent(trimws(cols[1])))))
n<-gsub(" ","+",toupper(gsub("[./]","",quit_accent(trimws(cols[2])))))
c<-gsub(" ","+",toupper(gsub("[./]","",quit_accent(trimws(cols[3])))))
z<-gsub(" ","+",toupper(gsub("[./]","",quit_accent(trimws(cols[4])))))
ci<-gsub(" ","+",toupper(gsub("[./]","",quit_accent(trimws(cols[5])))))
st<-gsub(" ","+",toupper(gsub("[./]","",quit_accent(trimws(cols[6])))))
co<-gsub(" ","+",toupper(gsub("[./]","",quit_accent(trimws(cols[7])))))

cat("writing the link","\n")

link <- paste0("https://geocode.maps.co/search?q=",
               s,"+",n,"+",c,"+",z,"+",ci,"+",st,"+",co,"&api_key=",
               key)

cat(paste0("the link is ready: ",link,collapse = "\n"),"\n")

write(link, file = "link.txt")
' "$row" "$api_key"

echo "Downloading the json file with coordinates"
URL=$(cat link.txt | tr -d '\r\n')
wget -O "${real_id}.json" "${URL}"

#making the link
if [ -s "${real_id}.json" ]; then
    n2=$(jq length "${real_id}".json)
    #othe if cicle  para si no hay coordenadas anexe un simple null
    echo "number of posibble coordinates: ${n2}"
    for j in $(seq 0 $((n2 - 1)))
    do
    echo "extracting coordinate number: ${j} from json file"
    lat=$(jq -r ".[${j}].lat" "${real_id}".json)
    lon=$(jq -r ".[${j}].lon" "${real_id}".json)
    echo "joining the coordinate to the coords.csv file"
    echo "${real_id},${j},${URL},${lat},${lon}" >> "${dir}/results/coords.csv"
    done
else
    echo "Error: Fail in downloading the address: ${row}"
fi
mv "${real_id}.json" "${dir}/results/json_files"
echo "deleting temp files"
rm -f link.txt
echo "**Finishing address: ${real_id} ${row}**"
sleep 1.2
done

#merge original data with the coordenates
echo "---merging coords with the original data---"
Rscript -e '
args <- commandArgs(trailingOnly = TRUE)
file <- args[1]

data<-read.csv(file)
coords<-read.csv("results/coords.csv")

if (!requireNamespace("sqldf", quietly = TRUE)) {
  install.packages("sqldf", repos = "https://cloud.r-project.org")
}

suppressWarnings(library("sqldf"))
ids<-seq_len(nrow(data))
data<-cbind(ids,data)

data_joined<-sqldf("SELECT a.*, b.ID2, b.link, b.lat, b.lon FROM data AS a LEFT JOIN
                    coords AS b ON a.ids=b.ID
                   ")

write.csv(data_joined,
          paste0(tools::file_path_sans_ext(file), "_with_coords.csv"),
          row.names = FALSE)
' "$file"

temp="${file%.*}"
mv "${dir}/${temp}_with_coords.csv"  "${dir}/results/"
echo "---FINISH---"