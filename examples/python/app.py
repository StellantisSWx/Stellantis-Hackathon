import json, requests

'''
Stellantis SDK example
Substitute values with your API and connected vehicle credentials
Please refer to LICENSE.MD for licensing details
You need a Stellantis SDK account and Stellantis North America connected vehicle to use this code,
please refer to https://developers.stellantis.com/docs.html for details
'''

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

#retrieves last known value of each vehicle sensor obtained, with label, value and timestamp
def get_last_known_data(vin):
    last_known_data_response = requests.get(base_url + "/v1/" + vin + "/data/lastknown", headers=headers)
    return json.loads(last_known_data_response.text)

#retrieves all data collected from vehicle in past 24 hours
def get_twenty_four_hour_data(vin):
    twenty_four_hour_data_response = requests.get(base_url + "/v1/" + vin + "/data", headers=headers)
    return json.loads(twenty_four_hour_data_response.text)

#sends commands to vehicle
#available commands are  "LOCK, UNLOCK, START, STOP, HORNS"
def post_remote_command(vin, pin, command):
    remote_command_response = requests.post(base_url + "/v1/" + vin + "/remote", headers=headers,
                                            json={"command": command,
                                                  "pin": pin})
    return json.loads(remote_command_response.text)


def main():
    bearer_token = get_bearer_token()

    set_bearer_token(bearer_token)

    print(last_known_data = get_last_known_data(VEHICLE_VIN))

    print(twenty_four_hour_data = get_twenty_four_hour_data(VEHICLE_VIN))

    print(post_remote_command(VEHICLE_VIN, VEHICLE_PIN, "LOCK"))

if __name__ == "__main__":
    main()