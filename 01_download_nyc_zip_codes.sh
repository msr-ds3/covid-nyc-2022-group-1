#!/bin/bash
#
#

# Make a Data directory
mkdir Data

# Downloads nyc zipcodes into Data directory
curl https://raw.githubusercontent.com/erikgregorywebb/nyc-housing/master/Data/nyc-zip-codes.csv > Data/nyc-zip-codes.csv