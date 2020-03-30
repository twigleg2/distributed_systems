## Gaven Finch
# Lab 5

**My SPA code**\
[git hub repo](https://github.com/twigleg2/distributed_systems/tree/master/lab5/spa/src)

**My ruleset URLs**\
[sensor_profile](https://raw.githubusercontent.com/twigleg2/distributed_systems/master/lab5/sensor_profile.krl?token=AINOKEBOVC467BN5K4XHEE26ROFLM)
[wovyn_base](https://raw.githubusercontent.com/twigleg2/distributed_systems/master/lab5/wovyn_base.krl?token=AINOKEHON57RI5OGHW5GPM26ROFOS)

**questions**
1. The hardest part of this assignment was building a single page application that was two pages... Jokes asside tho, the new ruleset was easy to build and super easy to integrate into my existing rulesets, because I already had entity variables defined and used in the pre-existing ruleset.
2. It encapsulates related data and actions to in a single location and doesn't clogg up other rulesets that don't care.  It's able to provide limited data to the rulesets that need it, making those other rulesets also nicely encapsulated.
3. The sensor profile raises an event when new data that might be of interest to other rulesets is received.  Those other rulesets simply listen for ths event.
4. Yes, other rulesets could use the sensor_profile ruleset to store data.  If the sensor profile provides a function that returns a needed value, the other rulesets would just invoke that function at will to retreive the value.