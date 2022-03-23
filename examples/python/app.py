import json

import requests

API_KEY = "your_api_key_here"
API_USERNAME = "your_api_account_username_here"
API_PASSWORD = "your_api_account_password_here"
VEHICLE_VIN = "your_vehicle_vin_here"
VEHICLE_PIN = 9999

base_url = "https://api.stellantis-developers.com"
headers = {
    "x-api-key": API_KEY, "user": API_USERNAME, "password": API_PASSWORD
}


def get_bearer_token():
    bearer_token_response = requests.post(base_url + "/v1/auth/token", headers=headers)
    response_parsed = json.loads(bearer_token_response.text)
    return response_parsed["access_token"]


def set_bearer_token(bearer_token):
    headers["Authorization"] = "Bearer " + bearer_token


def get_last_known_data(vin):
    last_known_data_response = requests.get(base_url + "/v1/" + vin + "/data/lastknown", headers=headers)
    return json.loads(last_known_data_response.text)


def get_twenty_four_hour_data(vin):
    twenty_four_hour_data_response = requests.get(base_url + "/v1/" + vin + "/data", headers=headers)
    return json.loads(twenty_four_hour_data_response.text)


def post_remote_command(vin, pin, command):
    remote_command_response = requests.post(base_url + "/v1/" + vin + "/remote", headers=headers,
                                            json={"command": command,
                                                  "pin": pin})
    return json.loads(remote_command_response.text)


bearer_token = get_bearer_token()
set_bearer_token(bearer_token)
last_known_data = get_last_known_data(VEHICLE_VIN)
#print(len(last_known_data["Items"]))
twenty_four_hour_data = get_twenty_four_hour_data(VEHICLE_VIN)
#print(len(twenty_four_hour_data["Items"]))
#print(post_remote_command(VEHICLE_VIN, VEHICLE_PIN, "LOCK"))
