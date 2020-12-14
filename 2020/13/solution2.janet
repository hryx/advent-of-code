(defn parse-input [input]
    (def busses (peg/match ~{
        :main (* :d+ :s+ :bus-list :s+)
        :bus-list (* :bus-id (any (* "," :bus-id)))
        :bus-id (+ (/ (<- :d+) ,scan-number) (/ (<- "x") nil))
    } input))
    (seq [i
        :range [0 (length busses)]
        :let [bus (i busses)]
        :when bus
    ] {:bus bus :offset i})
)

# (defn gcd [a b] (if (zero? b) a (gcd b (% a b))))
# (defn lcm [a b] (/ (* a b) (gcd a b)))
(def lcm *) # Since we know all inputs are primes, we can take a shortcut

(defn find-alignment [busses i base-t last-incr]
    (def j (+ 1 i))
    (if (>= j (length busses)) (break base-t))
    (def {:bus bus1 :offset offset1} (i busses))
    (def {:bus bus2 :offset offset2} (j busses))
    (def incr (lcm last-incr bus1))
    (print (string/format "alignment between busses %4d %4d (incr = %.f)" bus1 bus2 incr))
    (var t base-t)
    (while (not (zero? (% (+ t offset2) bus2))) (+= t incr))
    (print (string/format "  -> %.f" t))
    (find-alignment busses j t incr)
)

(def busses (parse-input (file/read stdin :all)))
(find-alignment busses 0 0 1)
