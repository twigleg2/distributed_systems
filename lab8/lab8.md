## Gaven Finch

**my ruleset URLs**
[manage_sensors](https://raw.githubusercontent.com/twigleg2/distributed_systems/master/lab8/manage_sensors.krl?token=AINOKEELYNXWQIYQUHA23ZC6SZXJU)
[temperature_store](https://raw.githubusercontent.com/twigleg2/distributed_systems/master/lab8/temperature_store.krl?token=AINOKEGUZL2HQRSB5YJPR526SZXNG)

**questions**
1. My code allows a sensor to be part of more than one collection.  However, in its current state, it would send a report to all collections if just one collection asked for a report.  This would be a super simple fix though, I just need to send along the colection Rx as an attribute and then the sensor would be able to know where to send the report.
2. I could have a list of Tx's that are 'authorized' and compare the Tx I get on the event againt this list.  Alternatively, I could look for a special 'password' or 'key' in the received attributes.
3. My debug logs show events raised for each sensor, and then also an event received from each sensor.  Each sensor also individually shows these sent and received events.
4. I specifically desinged my implementation to not care about if/when sensors fail, or if/when sensors take a long time to respond.  I create an empty object immediately upon receiving a 'generate report' event and, as sensors respond with their individual reports, I update the empty object to include this new data.  This "update as I go" method makes it so nothing is forced to wait until all sensors respond.  In the case of an unresponsive sensor, a 'partial' report will be generated.
5. Because of my implementation, there is no need to 'recover'. Ever.  It's impossible to get stuck because of slow or unresponsive sensors.