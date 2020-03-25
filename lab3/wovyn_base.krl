ruleset wovyn_base {
    meta {
        shares __testing
    }    

    global {
        __testing = {
            "queries": [ {"name": "__testing"}],
            "events": [ {"domain": "post", "type": "test", "attrs": ["temp", "baro"]}]
        }
    }

    rule post_test {
        select when post test
        pre {
            never_used = event:attrs.klog("attrs")
        }
    }
}