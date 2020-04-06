ruleset sensor_subscriber {
    rule accept_subscription {
        select when wrangler inbound_pending_subscription_added
        always {
            raise wrangler event "pending_subscription_approval" attributes event:attrs
        }
    }
}