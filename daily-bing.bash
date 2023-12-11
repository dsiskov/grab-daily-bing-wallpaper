#!bin/bash

if [ -z "$BING_WALLPAPER_QUALITY" ]; then
  # Valid options are: 1366x768 / 1920x1080 / UHD
  BING_WALLPAPER_QUALITY=UHD
fi

if [ -z "$OS_WALLPAPER_FILEPATH" ]; then
  printf "Please define where to store the wallpaper by specifying OS_WALLPAPER_FILEPATH environment variable\n"
  return
fi

fetch() {
  region=${1}
  apply=${2}
  quality=${3}
  data=$(curl -s -H "Accept: application/json" "https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=$region")
  path=$(echo $data | jq '.images[0].urlbase' | tr -d '"')
  copyright=$(echo $data | jq '.images[0].copyright' | tr -d '"')
  url=https://www.bing.com${path}_${BING_WALLPAPER_QUALITY}.jpg
  printf "\n$region\n$copyright\n${url}\n\n"
  
  if ! [ -z $apply ]; then
    curl ${url} -o "$OS_WALLPAPER_FILEPATH"
  fi
}

printf "\nPick a daily bing background and optionally set it as a desktop background. \n\n"
printf "Select region: \n"
printf " [Default] Browse all regions\n"
printf " [0] Pick randomly & Set\n"
printf " [1] Set en-US\n"
printf " [2] Set en-CA\n"
printf " [3] Set en-UK\n"
printf " [4] Set de-DE\n"
printf " [5] Set en-NZ\n"
printf " [6] Set en-AU\n"
printf " [7] Set ja-JP\n"
printf " [8] Set zh-CH\n"
read region_id

case $region_id in
  "") region="" ;;
  0) region="0" ;;
  1) region="en-US" ;;
  2) region="en-CA" ;;
  3) region="en-UK" ;;
  4) region="de-DE" ;;
  5) region="en-NZ" ;;
  6) region="en-AU" ;;
  7) region="ja-JP" ;;
  8) region="zh-CH" ;;
  *)
    printf "Error: You must enter a valid choice\n"
    return
  ;;
esac

regions=( 'en-US' 'en-CA' 'en-UK' 'de-DE' 'en-NZ' 'en-AU' 'ja-JP' 'zh-CN' )
if [ -z $region  ]; then
  for (( i=0 ; i < ${#regions[@]} ; i++ ))
    do
      fetch ${regions[$i]}
    done
elif [ $region == '0' ]; then
  fetch ${regions[RANDOM % 8]} true
else
  fetch $region true
fi
