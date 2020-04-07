ruleset manager_profile {
    meta {
        use module twilio_keys
        use module twilio_v2 alias twilio
            with account_sid = keys:twilio{"account_sid"}
                 auth_token = keys:twilio{"auth_token"}
    }

    rule initialization {
        select when wrangler ruleset_added where event:attr("rids") >< meta:rid
        fired {
            ent:phone_number_to := "+18017934946"
            ent:phone_number_from := "+12256865973"
        }
    }

    rule threshold_notification {
        select when threshold violation
        pre {
            message = "Threshold violation."
        }
        twilio:send_sms (
            ent:phone_number_to,
            ent:phone_number_from,
            message
        )
    }
}