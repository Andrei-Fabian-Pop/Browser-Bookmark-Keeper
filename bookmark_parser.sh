#!/bin/bash

help_function() {
    echo "Usage ./bookmark_parser.sh [arguments]"
    echo "Arguments:"
    echo -e "-f\tfirefox bookmark file location"
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
}" 
}

if [[ "$#" -eq 0 ]]; then
    help_function
    exit
fi

# TODO: add default link variables

firefox_link=""
chrome_link=""
output_file=""

while getopts f:c:o: flag
do
	case "$flag" in
		f) firefox_link=${OPTARG};;
		c) chrome_link=${OPTARG};;
		o) output_file=${OPTARG};;
		*) echo "incorrect arguments"; help_function; exit;;
	esac
done

chrome_parser() {
	jq '.roots[].children[] | .date_added, .guid, .id, .name, .type, .url' $chrome_link | while read line; do
		date_added=$line; read line
		guid=$line; read line
		id=$line; read line
		name=$line; read line
		btype=$line; read line
		url=$line

		print_entry "$date_added" "$guid" "$id" "$name" "$btype" "$url"	
	done
}

firefox_parser() {
	sqlite3 $firefox_link \
	"SELECT moz_bookmarks.dateAdded, moz_bookmarks.guid, moz_bookmarks.id, moz_bookmarks.title, moz_bookmarks.type, moz_places.url
	FROM moz_bookmarks 
	LEFT OUTER JOIN moz_places 
	ON moz_places.id = moz_bookmarks.fk 
	WHERE moz_places.id = moz_bookmarks.fk" | while IFS='|' read -r date_added guid id title btype url; do
		# echo "id: $id"
		# TODO: add chrome id count to this id
		print_entry "$date_added" "$guid" "$id" "$name" "$btype" "$url"
		# print_entry $date_added $guid $id $title $btype $url
	done
}

if [[ -z $output_file ]]; then	
	chrome_parser
	firefox_parser
else
	chrome_parser > $output_file
	firefox_parser >> $output_file
fi

