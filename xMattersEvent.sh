#!/bin/bash

# pipe all output to log file
#logfile=/var/log/xMattersEvent.log
#exec >> $logfile 2>&1

echo ""
echo "-----------------------------------------------"
echo $(date)


target=$1
# split third argument into an array
readarray -t values <<<"$3"

# strip trailing carriage returns
for i in "${!values[@]}"; do
  values[$i]=`echo ${values[$i]} |tr -d '\r'`
done

# printf '%s\n' "${values[@]}"

JSON_STRING=$( jq -n \
	--arg st "$target" \
	--arg ea "${values[1]}" \
	--arg ed "${values[2]}" \
	--arg ei "${values[3]}" \
	--arg en "${values[4]}" \
	--arg ens "${values[5]}" \
	--arg eo "${values[6]}" \
	--arg et "${values[7]}" \
	--arg eti "${values[8]}" \
	--arg eu "${values[9]}" \
	--arg ev "${values[10]}" \
	--arg hi "${values[11]}" \
	--arg hn "${values[12]}" \
	--arg td "${values[13]}" \
	--arg ti "${values[14]}" \
	'{alert_sendto: $st, event_ack: $ea, event_date: $ed, event_id: $ei, event_name: $en, event_nseverity: $ens, event_opdata: $eo, event_tags: $et, event_time: $eti, event_update: $eu, event_value: $ev, host_ip: $hi, host_name: $hn, trigger_description: $td, trigger_id: $ti}')

# xm url should be index 15 of values arr
url="${values[15]}"
echo $JSON_STRING
echo $url

username="${values[16]}"
password="${values[17]}"

if [ -z "${username}" ] && [ -z "${password}" ]
then
	curl -H "Content-Type: application/json" -X POST -d "{\"fields\": $JSON_STRING}" $url
else
	curl -H "Content-Type: application/json" -u "${username}:${password}" -X POST -d "{\"fields\": $JSON_STRING}" $url
fi
