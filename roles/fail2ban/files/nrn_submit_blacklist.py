#!/usr/bin/python3
import sys
import requests

import configparser
config = configparser.ConfigParser()
config.read('/etc/nrn_blacklist.conf')

API_ENDPOINT = "https://www.nullroutenetworks.com/blacklist/submit.php"
if "API_ENDPOINT" in config['NRN_Blacklist']:
    API_ENDPOINT = config['NRN_Blacklist']['api_endpoint']
API_KEY = config['NRN_Blacklist']['API_KEY']

if len(sys.argv) < 2:
    print("Provide the IP to blacklist as the first command line argument.")
    exit()
# The host to blacklist
HOST = sys.argv[1]
# The time in seconds before expiry
EXPIRES = "86400"
# Trigger category ABUSE/HONEYPOT/etc
TYPE = "ABUSE"
# Trigger service SSH/HTTP/HTTPS/ASTERISK/etc
SERVICE = "SSH"
data = {'key':API_KEY,
        'host':HOST,
        'expires':EXPIRES,
        'type':TYPE,
        'service':SERVICE}
r = requests.post(url = API_ENDPOINT, data = data)
print(r.text)
