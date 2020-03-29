ruleset sensor_profile {

    meta {
        shares get_profile_data
    }

    global {
        get_profile_data = function() {
            {
                "location": ent:location,
                "name": ent:name,
                "SMS_number": ent:SMS_nuber,
                "threshold": ent:threshold
            }
        }
    }

    rule initialization {
        select when wrangler ruleset_added where event:attr("rids") >< meta:rid
        fired{
            ent:location := "default location"
            ent:name := "default name"
            ent:SMS_number := "+18017934946"
            ent:threshold := 80
        }
    }

    rule update {
        select when sensor:profile_updated

    }
}