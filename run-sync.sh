#!/usr/bin/env bash

TEMP_DIR="temp"
URL_LIST=(
    "https://www.cns11643.gov.tw/opendata/release.txt"
    "https://www.cns11643.gov.tw/opendata/OpenDataFilesList.csv"
    "https://www.cns11643.gov.tw/opendata/MapingTables.zip"
    "https://www.cns11643.gov.tw/opendata/Properties.zip"
)

# invalid
# "https://www.cns11643.gov.tw/opendata/release.json"
# "https://www.cns11643.gov.tw/opendata/Tables.zip"

# ignore
# https://www.cns11643.gov.tw/opendata/Voice.zip # 全字庫聲音檔
# https://www.cns11643.gov.tw/opendata/Fonts_Sung.zip # 全字庫宋體字型檔
# https://www.cns11643.gov.tw/opendata/Fonts_Kai.zip # 全字庫楷體字型檔

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

csv_file="OpenDataFilesList.csv"
tmp_file="$csv_file.tmp"
echo "Convert $csv_file"
iconv -f big5 -t utf-8 $csv_file > $tmp_file && mv $tmp_file $csv_file

echo "Clean zip"
rm -rf *.zip
popd

echo "sync"
cp -rf "${TEMP_DIR}"/* ./
