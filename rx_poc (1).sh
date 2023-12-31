#! /bin/bash

# create a datestamped filename for the raw wttr data:
today=$(date +%Y%m%d)
weather_report=raw_data_$today

# download today's weather report from wttr.in:
city=city_area
curl wttr.in/$city --output $weather_report

# use command substitution to store the current day, month, and year in corresponding shell variables:
hour=$(TZ='Country/City' date -u +%H)
day=$(TZ='Country/City' date -u +%d)
month=$(TZ='Country/City' date +%m)
year=$(TZ='Country/City' date +%Y)

# extract all lines containing temperatures from the weather report and write to file
grep °C $weather_report > temperatures.txt

# extract the current temperature

obs_tmp=$(cat -A temperatures.txt | head -1 | cut -d "+" -f2 | cut -d "^" -f1 )

echo "observed = $obs_tmp"

# extract the forecast for noon tomorrow
fc_temp=$(cat -A temperatures.txt | head -3 | tail -1 | cut -d "+" -f2 | cut -d "(" -f1 | cut -d "^" -f1 )
echo "fc temp = $fc_temp"

# create a tab-delimited record
# recall the header was created as follows:
# header=$(echo -e "year\tmonth\tday\tobs_tmp\tfc_temp")
# echo $header>rx_poc.log

record=$(echo -e "$year\t$month\t$day\t$obs_tmp\t$fc_temp")
# append the record to rx_poc.log
echo $record>>rx_poc.log