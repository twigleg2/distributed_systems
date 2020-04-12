ruleset gossip {
    meta {
        use module temperature_store
        shares view_seen, view_temperatures
    }

    global {
        view_seen = function() {
            ent:seen
        }

        view_temperatures = function() {
            ent:temperatures
        }

        get_random_peer = function() {
            peers = Subscriptions:established("Tx_role","sensor")
            num_peers = peers.length()
            random_index = random:integer(num_peers)
            peers[random_index]
        }

        calculate_rumor = function(seen_peer) {
            ent:temperatures.filter(function(v1, k1) {
                v1.filter(function(v2, k2) {
                    k2 > seen_peer{k1}
                }) //keep all inner entries who's sequence number is greater than the peers corresponding sequence number
            })
        }

        calculate_seen_updates = function(obj) {
            obj.filter(function(v,k) {
                v.keys().sort().tail()
            })
        }
    }

    rule initialization {
        select when wrangler ruleset_added where event:attr("rids") >< meta:rid
        fired{
            ent:sequence_number := 0
            ent:active := true
            ent:prop_time := 5 //seconds
            ent:seen := {}
            ent:temperatures := {}
            // {
            //     origin_id: {
            //         sequence_number: temperature_object,
            //         sequence_number: temperature_object,
            //         ...
            //     },
            //     origin_id: {
            //         sequence_number: temperature_object
            //         ...
            //     },
            //     ...
            // }

            raise gossip event "heartbeat"
        }
    }

    rule heartbeat_received {
        select when gossip heartbeat
        pre {
            peer = get_random_peer()
        }
        if ent:active then event:send(
            {
                "eci": peer{"Tx"},
                "eid": "seen", //event id.  so far, mostly useless
                "domain": "gossip",
                "type": "seen",
                "attrs": {
                    "seen": ent:seen,
                    "Rx": peer{"Rx"}
                }
            }
        )
        fired {
            schedule gossip event "heartbeat" at time:add(time:now(), {"seconds": ent:prop_time})
        }
    }

    rule seen_received {
        select when gossip seen
        pre {
            temps_to_send = calculate_rumor(event:attr("seen"))
        }
        if ent:active then event:send(
            {
                "eci": event:attr("Rx"),
                "eid": "rumor",
                "domain": "gossip",
                "type": "rumor",
                "attrs": {
                    "updates": temps_to_send
                }
            }
        )
    }

    rule rumor_received {
        select when gossip rumor
        pre {
            seen_updates = calculate_seen_updates(event:attr("updates"))
            temperature_updates = calculate_temperature_updates(event:attr("updates"))
        }
        if ent:active then noop()
        fired {
            ent:seen := ent:seen.put(seen_updates)
            ent:temperatures := ent:temperatures.put(temperature_updates)
        }
    }

    rule new_temperature_reading {
        select when wovyn new_temperature_reading
        pre {
            origin_id = meta:picoId
            temperature_object = {
                "temperatureF": event:attr("temperatureF"),
                "temperatureC": event:attr("temperatureC"),
                "timestamp": event:attr("timestamp")
            }
        }
        fired {
            ent:temperatures{[origin_id, ent:sequence_number]} := temperature_object
            ent:seen{origin_id} := ent:sequence_number
            ent:sequence_number := ent:sequence_number + 1
        }
    }

    rule activate {
        select when gossip activate
        if ent:active then noop()
        notfired {  //So that activating an already active pico doesn't start sending extra heartbeats
            ent:active := true
            raise gossip event "heartbeat"
        }
    }

    rule deactivate {
        select when gossip deactivate
        fired {
            ent:active := true
        }
    }
}