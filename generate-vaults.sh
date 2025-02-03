#!/usr/bin/env bash

IFS="
"

collected_string=""

for x in $( ls host_vars )
do
	base="$( echo "${x}" | sed 's/\.mm\.fcix\.net\.yaml$//g' )"
	echo "-- ${base} --"
	tpass="$( apg -m 64 | tail -n 2 | head -n 1 )"
	vault_file="vault/${base}.yml"
	if [[ ! -e "${vault_file}" ]]
	then
		echo "collectd_password: ${tpass}" > "${vault_file}"
		collected_string="${collected_string}
${base}: ${tpass}"
		ansible-vault encrypt "${vault_file}"
		git add "${vault_file}"
		git commit --signoff -m "Adding ${base} vault"
	fi
done
echo "-- Collected: --"
echo "${collected_string}"
git push
