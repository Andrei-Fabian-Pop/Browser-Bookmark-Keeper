#!/bin/bash

help_function() {
    echo "Usage ./bookmark_parser.sh [arguments]"
    echo "Arguments:"
	  echo -e "-F\tuse firefox default location"
    echo -e "-f\tfirefox bookmark file location"
	  echo -e "-C\tuse chrome default location"
    echo -e "-c\tchrome bookmark file location"
    echo -e "-o\toutput file for the script (default: stdout)"
}

print_entry() {
	echo -e \
"{
	\"dt\": $1, 
	\"guid\": $2, 
	\"id\": $3,
	\"name\": $4,
	\"btype\": $5,
	\"url\": $6
},"
}

chrome_parser() {
	jq '.roots[].children[] | .date_added, .guid, .id, .name, .type, .url' "$chrome_link" | while read -r line; do
		date_added=$line; read -r line
		guid=$line; read -r line
		id=$line; read -r line
		name=$line; read -r line
		btype=$line; read -r line
		url=$line

		print_entry "$date_added" "$guid" "$id" "$name" "$btype" "$url"	
	done
}

firefox_parser() {
	sqlite3 "$firefox_link" \
	"SELECT moz_bookmarks.dateAdded, moz_bookmarks.guid, moz_bookmarks.id, moz_bookmarks.title, moz_bookmarks.type, moz_places.url
	FROM moz_bookmarks 
	LEFT OUTER JOIN moz_places 
	ON moz_places.id = moz_bookmarks.fk 
	WHERE moz_places.id = moz_bookmarks.fk" | while IFS='|' read -r date_added guid id title btype url; do
		print_entry "$date_added" "$guid" "$id" "$title" "$btype" "$url"
	done
}

if [[ "$#" -eq 0 ]]; then
    help_function
    exit
fi

firefox_link=$(find ~/snap/firefox/common/.mozilla/firefox/ -type f -name "places.sqlite")
chrome_link=$(find ~/.config/google-chrome/Default -type f -name "Bookmarks")
output_file=""

ff_flag=0
ch_flag=0

while getopts Ff:Cc:o: flag
do
	case "$flag" in
		F) ff_flag=1;;
		f) firefox_link=${OPTARG}; ff_flag=1;;
		C) ch_flag=1;;
		c) chrome_link=${OPTARG}; ch_flag=1;;
		o) output_file=${OPTARG};;
		*) echo "incorrect arguments"; help_function; exit;;
	esac
done

if [[ -z $output_file ]]; then	
	if [[ $ch_flag -ne 0 ]]; then
		chrome_parser
	fi

	if [[ $ff_flag -ne 0 ]]; then
		firefox_parser
	fi
else
	if [[ $ch_flag -ne 0 ]]; then
		chrome_parser > "$output_file"
	fi

	if [[ $ff_flag -ne 0 ]]; then
		firefox_parser >> "$output_file"
	fi
fi

