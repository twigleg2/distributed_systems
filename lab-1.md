**gfinch**
# lab 1

1. channel name = lab1 type = test

old channel - http://localhost:8080/sky/event/Y9JzGFuEKa1HRKx4pwpV15/1/echo/hello
{"directives":[{"options":{"something":"Hello World"},"name":"say","meta":{"rid":"hello_world","rule_name":"hello_world","txn_id":"ck5mu3er1000etzshgdsj3zgl","eid":"1"}}]}

new chanel - http://localhost:8080/sky/event/X231KXNUGiVwHfqw34tETj/1/echo/hello
{"directives":[{"options":{"something":"Hello World"},"name":"say","meta":{"rid":"hello_world","rule_name":"hello_world","txn_id":"ck5mtzyfs000dtzshfa30cvt8","eid":"1"}}]}

the results are not the same, they each contain a different ID

2. delete channel

{"error":"ECI not found: X231KXNUGiVwHfqw34tETj"}
the channel doesn't exist...

3. misspelled event

{"directives":[]}
there are no directives...

4. 