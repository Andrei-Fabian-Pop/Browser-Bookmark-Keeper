# Browser Bookmark Keeper
Bash script that will fetch all the bookmarks from the major browsers (currently Google Chrome and Mozilla Firefox) and save them in a json file.

### Google Chrome
The bookmarks from Google Chrome are saved in Linux, by default, in the ~/.config/google-chrome/Default directory in a json file called **Bookmarks**. The json structure for each bookmark is
```json
{
  "date_added": "string",
  "guid": "string",
  "id": "int",
  "meta_info": {
    "last_visited_desktop": "int"
  },
  "name": "string",
  "type": "string",
  "url": "string"
}
```

### Mozilla Firefox
The bookmarks from Mozilla Firefox are saved in Linux, by default, in the ~/.mozilla/firefox/(some id).default/ directory in a sqlite file called "**places.sqlite**". The structure of this database is explained here https://wiki.mozilla.org/images/d/d5/Places.sqlite.schema3.pdf

## Usage
Run requirements.sh as superuser to install dependencies
```
sudo ./requirements.sh
```
Script options:
```
Usage ./bookmark_parser.sh [arguments]
Arguments:
-F  use firefox default location
-f  firefox bookmark file location
-C  use chrome default location
-c  chrome bookmark file location
-o  output file for the script (default: stdout)
```