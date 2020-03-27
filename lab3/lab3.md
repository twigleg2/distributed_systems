## Gaven Finch
# Lab 3

**My ruleset URLs**\
[twilio](https://raw.githubusercontent.com/twigleg2/distributed_systems/master/lab3/twilio_v2.krl?token=AINOKEB4WWAXJY6HZVENCLK6Q6FO2)\
[woyn_base](https://raw.githubusercontent.com/twigleg2/distributed_systems/master/lab3/wovyn_base.krl?token=AINOKEHFJKKX2ZZBQZUOFL26Q6FQ4)

**URI**\
gen:  http://<ip_address>:<port>/sky/event/<channel_id>/<event_id>/<domain>/<name>
mine: http://192.168.1.161:8080/sky/event/RDuf2XxiLgABQ687nKfZnz/wov/wovyn/heartbeat

**test**\
curl http://192.168.1.161:8080/sky/event/RDuf2XxiLgABQ687nKfZnz/wov/wovyn/heartbeat --data "_domain=foo&_type=bar"

**Questions**
1. git pre-commit
2. event expression.  My rule isn't added to the scheduler if the event expression evaluates to false, so it's more efficient.
3. Before the find_high_temps rule was added there was only 1 rule, so 1 rule was executed.  no directies were returned (an empty array)
4. 1 directive was returned with the appropriate 'above' or 'below' threshold message and some metadata.  2 rules ran.
5. How do I account for the difference in the number of directives returned?  The first rule doesn't give one and the second does... because  explicitly told the second rule to send a directive. [swimlane](https://swimlanes.io/#bY4xDoMwEAT7e4XLpIgo0lHkBfmDZfBinwRnZF9A/D6ABJGSdKfdm9Eqa4/aPF1j7kSQwAJze5gxpxal2AiXtYHT2sxpWqQ+A6Kfnw3sWLyNHKJVDGM5MMG8B8hOXxk2w3mWQFRVX8Qm0ZhRYuq9laTcceuUkxyuTztx6veK6I/Fc0arPGFdcd6XYZ3sAq5v)
6. Yes, it's an event preprocessing intermediary because it does some (simple) calculations to determine if the next event is fired or not.
7. _when below threshold_, you can see the temperatures and the "no violation" message:
\[KLOG] temperatureF:  76.44
\[KLOG] ent:  80
\[DEBUG] {"directives":[{"options":{},"name":"No Temperature Violation.","meta":{"rid":"wovyn_base","rule_name":"find_high_temps","txn_id":"ck898x3wq008kurshb9kk9wms","eid":"wov"}}]}\
\
_when above threshold_, you can see that a wovyn/threshold_violation event is raised, and a directive with the "Temperature Violation!" message is sent.
\[DEBUG] adding raised event to schedule: wovyn/threshold_violation attributes {"temperature":[{"name":"enclosure temperature","transducerGUID":"28C157230A0000E0","units":"degrees","temperatureF":76.55,"temperatureC":24.75}],"timestamp":"a timestamp goes here"}
\[DEBUG] {"directives":[{"options":{},"name":"Temperature Violation!","meta":{"rid":"wovyn_base","rule_name":"find_high_temps","txn_id":"ck898tcf80088urshfx85durq","eid":"wov"}}]}
