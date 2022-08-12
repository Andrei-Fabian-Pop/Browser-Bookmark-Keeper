#!/bin/bash

# This script will install dependencies for the bookmark_parser.sh script
#
# Use command "chmod u+x requirements.sh" before running
# Must run as superuser

if [[ $(id -u) != "0" ]]; then
	echo "You mush run this script with sudo."
	exit 1
fi

echo "Making bookmark_parser.sh executable..."
chmod u+x bookmark_parser.sh

echo "Installing dependencies..."
apt-get update

# install jq for json parsing
apt-get install jq

# install sqlite for sqlite database parsing
apt-get install sqlite3
