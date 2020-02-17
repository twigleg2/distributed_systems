ruleset io.picolabs.use_twilio_v2 {
    meta {
        use module io.picolabs.lesson_keys
        use module io.picolabs.twilio_v2 alias twilio
            with account_sid = keys:twilio{"account_sid"}
                 auth_token = keys:twilio{"auth_token"}
    }

    rule test_send_sms {
        select when test new_message
        twilio:send_sms(
            event:attr("to"),
            event:attr("from"),
            event:attr("message")
        )
    }
}