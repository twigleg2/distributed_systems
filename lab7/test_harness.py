import requests
import time
import json

num_picos = 3
create_url = "http://localhost:8080/sky/event/LpQ2YYvo5TroeSBPtjNqQi/1/sensor/new_sensor?sensor_name="
delete_url = "http://localhost:8080/sky/event/LpQ2YYvo5TroeSBPtjNqQi/1/sensor/unneeded_sensor?sensor_name="
view_url = "http://localhost:8080/sky/cloud/LpQ2YYvo5TroeSBPtjNqQi/manage_sensors/sensors"
event_url = "http://localhost:8080/sky/event/"
cloud_url = "http://localhost:8080/sky/cloud/"
profile_url = "/sensor_profile/get_profile_data"
new_temp_url = "/1/wovyn/heartbeat"

fake_temperature_reading = {"version":2,"eventDomain":"wovyn.emitter","eventName":"sensorHeartbeat","emitterGUID":"5CCF7F74AE59","genericThing":{"typeId":"2.1.2","typeName":"generic.simple.temperature","healthPercent":81.56,"heartbeatSeconds":20,"data":{"temperature":[{"name":"enclosure temperature","transducerGUID":"28C157230A0000E0","units":"degrees","temperatureF":78.57,"temperatureC":25.88}]}},"specificThing":{"make":"Wovyn ESProto","model":"Temp2000","typeId":"1.1.2.2.2000","typeName":"enterprise.wovyn.esproto.temp.2000","thingGUID":"5CCF7F74AE59.1","firmwareVersion":"Wovyn-Temp2000-1.1-DEV","transducer":[{"name":"Maxim DS18B20 Digital Thermometer","transducerGUID":"28C157230A0000E0","transducerType":"Maxim Integrated.DS18B20","units":"degrees","temperatureC":25.88}],"battery":{"maximumVoltage":3.6,"minimumVoltage":2.7,"currentVoltage":3.43}},"property":{"name":"Wovyn_74AE59","description":"Wovyn ESProto Temp2000","location":{"description":"Timbuktu","imageURL":"http://www.wovyn.com/assets/img/wovyn-logo-small.png","latitude":"16.77078","longitude":"-3.00819"}},"_headers":{"host":"192.168.1.161","accept":"application/json","content-type":"application/json","content-length":"1242"}}

for x in range(num_picos):
    r = requests.get(url = create_url + str(x))
print(str(num_picos) + " picos have been create.")


view = "view - view all picos\n"
end = "end - end the test harness\n"
temp = "temp - send a new (fake) temperature reading to each pico\n"
profile = "profile - view the profile for 1 sensor\n"
while True:
    print()
    r = requests.get(url = view_url)
    picos = r.json()
    entry = input("Enter one of the following: \n" + view + end + temp + profile)

    if entry == "view":
        print(picos)
    if entry == "temp":
        for pico in picos:
            eci = picos[pico]["eci"]
            post = event_url + eci + new_temp_url
            r = requests.post(url=post, json=fake_temperature_reading)
    if entry == "profile":
        get = cloud_url + picos["0"]["eci"] + profile_url
        r = requests.get(url=get)
        print(r.json())
    if entry == "end":
        break

for x in range(num_picos):
    r = requests.get(url = delete_url + str(x))

print(str(num_picos) + " picos have been deleted")

print("Test harness over\n")