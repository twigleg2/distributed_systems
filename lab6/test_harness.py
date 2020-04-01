import requests

num_picos = 10
create_url = "http://localhost:8080/sky/event/LpQ2YYvo5TroeSBPtjNqQi/1/sensor/new_sensor?sensor_name="
delete_url = "http://localhost:8080/sky/event/LpQ2YYvo5TroeSBPtjNqQi/1/sensor/unneeded_sensor?sensor_name="

for x in range(num_picos):
    r = requests.get(url = create_url + str(x))

input(str(num_picos) + " picos have been create.  Input any value to continue:\n")

for x in range(num_picos):
    r = requests.get(url = delete_url + str(x))

print(str(num_picos) + " picos have been deleted")

print("Test harness over\n")