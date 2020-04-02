## Gaven Finch

**My ruleset URLs**\
[manage_sensors](https://raw.githubusercontent.com/twigleg2/distributed_systems/master/lab6/manage_sensors.krl?token=AINOKECUTE6FCPAECFUPNTK6RVYRC)

**My testing URIs**\
http://localhost:8080/sky/event/LpQ2YYvo5TroeSBPtjNqQi/1/sensor/new_sensor?sensor_name=insertNameHere
http://localhost:8080/sky/event/LpQ2YYvo5TroeSBPtjNqQi/1/sensor/unneeded_sensor?sensor_name=insertNameHere
http://localhost:8080/sky/cloud/LpQ2YYvo5TroeSBPtjNqQi/manage_sensors/sensors
http://localhost:8080/sky/cloud/LpQ2YYvo5TroeSBPtjNqQi/manage_sensors/collect_all_temps

**questions**
1. when I raise a wrangler:child_creation event, i pass in an array of the names (rids) of the rulesets I want to install as an attribute, like this:  "rids": ["temperature_store","wovyn_base","sensor_profile"],
2. I have a rule that select[s] when wrangler child_initialized.  The documentation says that this event guarentees the child has finished being created.  In this rule, I raise an event that updates their profile.
3. I used python with the requests library and just sent off a bunch of http GET and POST requests.
4. You could use [subscriptions](https://picolabs.atlassian.net/wiki/spaces/docs/pages/21659676/Pico+to+Pico+Subscriptions+Lesson)