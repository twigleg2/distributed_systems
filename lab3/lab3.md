## Gavan Finch
# Lab 3

**URI**
gen:  http://<ip_address>:<port>/sky/event/<channel_id>/<event_id>/<domain>/<name>
mine: http://192.168.1.161:8080/sky/event/RDuf2XxiLgABQ687nKfZnz/wov/wovyn/heartbeat

**test**
curl http://192.168.1.161:8080/sky/event/RDuf2XxiLgABQ687nKfZnz/wov/wovyn/heartbeat --data "_domain=foo&_type=bar"

**Questions**
1. git pre-commit
2. event expression.  My rule isn't added to the scheduler if the event expression evaluates to false, so it's more efficient.
3. Before the find_high_temps rule was added there was only 1 rule, so 1 rule was executed.  1 empty directive was returned.
4. 