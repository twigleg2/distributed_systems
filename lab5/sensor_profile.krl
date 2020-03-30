ruleset sensor_profile {

    meta {
        shares get_profile_data
    }

    global {
        get_profile_data = function() {
            {
                "name": ent:name,
                "location": ent:location,
                "SMS_number": ent:SMS_number,
                "threshold": ent:threshold
            }
        }
    }

    rule initialization {
        select when wrangler ruleset_added where event:attr("rids") >< meta:rid
        fired{
            ent:name := "default name"
            ent:location := "default location"
            ent:SMS_number := "+18017934946"
            ent:threshold := 80
        }
    }

    rule update {
        select when sensor profile_updated
        pre {
            eventattrs = event:attrs.klog("event attributes: ")
            decoded = eventattrs.decode()
            name = decoded{"name"} => decoded{"name"} | ent:name
            location = decoded{"location"} => decoded{"location"} | ent:location
            SMS_number = decoded{"SMS_number"} => "+" + decoded{"SMS_number"} | ent:SMS_number
            threshold = decoded{"threshold"} => decoded{"threshold"}.as("Number") | ent:threshold
        }
        fired {
            ent:name := name
            ent:location := location
            ent:SMS_number := SMS_number
            ent:threshold := threshold
            raise profile event "updated"
                attributes {
                    "name": name,
                    "location": location,
                    "SMS_number": SMS_number,
                    "threshold": threshold
                }
        }
    }
}