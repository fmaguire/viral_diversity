#!/bin/bash

echo "Site ID,Country,Year,Latitude,Longitude" > metadata_tmp.csv
grep "^>" $1 | sed 's/>//' | awk -F '_' 'BEGIN {OFS=","}; \
   		                                      NF==3 {print $1, $2, $3}; \
       		                                  NF==4 {print $1, $2 " " $3, $4}' >> metadata_tmp.csv

