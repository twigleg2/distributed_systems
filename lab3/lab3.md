## Gavan Finch
# Lab 3

**URI**
gen:  http://<ip_address>:<port>/sky/event/<channel_id>/<event_id>/<domain>/<name>
mine: http://192.168.1.161:8080/sky/event/RDuf2XxiLgABQ687nKfZnz/wov/wovyn/heartbeat

**test**
curl http://192.168.1.161:8080/sky/event/RDuf2XxiLgABQ687nKfZnz/wov/wovyn/heartbeat --data "_domain=foo&_type=bar"
