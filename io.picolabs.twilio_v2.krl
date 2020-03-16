ruleset io.picolabs.twilio_v2 {
    meta {
        configure using account_sid = ""
                        auth_token = ""
        provides
            send_sms,
            getLogs
    }

    global {
        send_sms = defaction(to, from, message) {
            base_url = <<https://#{account_sid}:#{auth_token}@api.twilio.com/2010-04-01/Accounts/#{account_sid}/>>
            http:post(base_url + "Messages.json", form = {
                "From":from,
                "To":to,
                "Body":message
            })
        }

        getLogs = function() {
            get_url = <<https://#{account_sid}:#{auth_token}@api.twilio.com/2010-04-01/Accounts/#{account_sid}/Messages.json>>
            map = http:get(get_url).klog()
            content = map{"content"}
            decoded = content.decode()
            decoded //returns the last expression
        }
    }
}