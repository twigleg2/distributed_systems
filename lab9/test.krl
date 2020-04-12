ruleset test {
    meta {
        shares test, no_key
    }

    global {
        compare_null = function() {
            {
                "1 < null": 1 < null,
                "1 == null": 1 == null,
                "1 > null": 1 > null,
                "0 < null": 0 < null,
                "0 == null": 0 == null,
                "0 > null": 0 > null
            }
        }

        no_key = function(key) {
            obj = {
                "a": 1,
                "b": 2
            }
            obj{key}
        }

        //this is another veirsion of a function found in gossip.krl
        //I don't want to lose this even though I dont think it's a great solution
        calculate_send_temps = function(seen_peer) {
            res = ent:seen.filter(function(v, k) {
                v > seen_peer{k}
            }) //keep all entries who's sequence number is greater than the peers corresponding sequence number
            ids = res.keys()

            temps = ent:temperatures.filter(function(v1, k1) {
                ids.index(k1) != -1
            }) //keep all entries who's id exists in the ids array made above

            temps.filter(function(v1, k1) {
                v1.filter(function(v2, k2) {
                    k2 > seen_peer{k1}
                }) //keep all inner entries who's sequence number is greater than the peers corresponding sequence number
            })
        }
    }
}