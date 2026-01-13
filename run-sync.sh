#!/usr/bin/env bash

TEMP_DIR="temp"
URL_LIST=(
    "https://www.cns11643.gov.tw/opendata/release.json"
    "https://www.cns11643.gov.tw/opendata/release.txt"
    "https://www.cns11643.gov.tw/opendata/OpenDataFilesList.csv"
    "https://www.cns11643.gov.tw/opendata/MapingTables.zip"
    "https://www.cns11643.gov.tw/opendata/Properties.zip"
)
# "https://www.cns11643.gov.tw/opendata/Tables.zip" # invalid
# https://www.cns11643.gov.tw/opendata/Voice.zip
WORD_RUL="https://data.gov.tw/api/front/dataset/dcat.download?nid=5961"

if [[ -d "$TEMP_DIR" ]]; then
    rm -rf $TEMP_DIR
fi
mkdir -p $TEMP_DIR

pushd $TEMP_DIR

echo "download $WORD_RUL"
curl -s -o "DCAT 詞彙.txt" $WORD_RUL

for url in "${URL_LIST[@]}"; do
    echo "Download $url"
    curl -s -O $url
done

echo "unzip"
base="Tables"
if [[ -d $base ]]; then
    rm -rf $base
fi

mkdir -p $base
for zipfile in *.zip; do
    dirname="${zipfile%.zip}"
    # mkdir -p "$dirname"
    # unzip "$zipfile" -d "$dirname"
    unar -quiet -output-directory "$base" "$zipfile"
done

# echo "Clean zip"
# rm -rf *.zip
popd

echo "sync"
cp -rf "${TEMP_DIR}"/* ./
