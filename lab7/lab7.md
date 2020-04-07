## Gaven Finch


**testing URIs**
[create a subscription to a non-child sensor](http://localhost:8080/sky/event/LpQ2YYvo5TroeSBPtjNqQi/1/sensor/subscribe_non_child?sesor_name=old%20sensor&eci=K5P6PzpMBd7bU7Z3ijAcao). Note that the non-child sensor must still accept the subscription.
[view subscriptions](http://localhost:8080/sky/cloud/LpQ2YYvo5TroeSBPtjNqQi/io.picolabs.subscription/established)

**questions**
1. Auto-accepting is insecure because anybody who might happen to know the correct channel IDs could create a subscription and then do whatever they wanted with our picos.
2. Yes, a sensor pico can have subscriptions to multiple managing picos.
3. Organizing and managing these really depends on the real-world model that we want to emulate.  If it's important that sensors be grouped by physical location, for example, then a manager pico representing each location would manage all the different types of sensor picos present at that location, and then a group manager could be used to manage each location manager.  If instead it's more important that the different types of picos be grouped together or managed as one unit, then you could have a manager for each sensor type, and then again a group manager above that.
4. Just like I described in the first part of question 3, I would have a manager pico that represents each location and manages all the sensors at that location. Then I would have a group manager that manages all the location managers, if such a central entity were needed.
5.  I don't see how this question is different from question 2... but yes, a pico could be tied to two managers.  If it were, then correct functionality would respond to both maagers and provide the same data to both.  In the case of a threshold violation, it shold notify both managers.
6. I'm not sure what this question is asking, so I'll give it my best guess.  I added the threshold violation logic into the sensor profile ruleset because it already has phone number available there.  I recognize that this might no be the 'most correct' way to organize it, but it works and was easy to build.
7. I added one rule.  Only one rule was needed because the profile information was readily available and I didn't have to forward the event or fetch other data.