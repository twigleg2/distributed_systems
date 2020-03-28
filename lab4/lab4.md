## Gaven Finch
# Lab 4

**My ruleset URLs**\
[temperature_store](https://raw.githubusercontent.com/twigleg2/distributed_systems/master/lab4/temperature_store.krl?token=AINOKEB7OX7732PSR5NXSRS6Q7FX4)

**URIs**\
* http://localhost:8080/sky/cloud/K5P6PzpMBd7bU7Z3ijAcao/temperature_store/temperatures
* http://localhost:8080/sky/cloud/K5P6PzpMBd7bU7Z3ijAcao/temperature_store/threshold_violations
* http://localhost:8080/sky/cloud/K5P6PzpMBd7bU7Z3ijAcao/temperature_store/inrange_temperatures
* http://localhost:8080/sky/event/K5P6PzpMBd7bU7Z3ijAcao/1/sensor/reading_reset

**questions**
1. collect_temperatures responds to events, while temperatures responds to queries.  Each has unique resposabilities that are triggered and executed as defined in the ruleset.
2. I use array.any to test for duplicates, then array.filter to exclude those duplicates
3. _provides_ gives access to functions when used as a module. If _provides_ doesn't list the temperatures function, it won't be available when this ruleset is used as a module
4. _shares_ gives access to functions through sky/cloud queries.  if _shares_ doesn't list the temperatures function, it won't be accessible throuh sky/cloud queries.