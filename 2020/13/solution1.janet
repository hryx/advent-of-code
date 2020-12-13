(defn parse-input [input] (peg/match ~{
    :main (* :threshold :s+ (group :bus-list) :s+)
    :threshold (/ (<- :d+) ,scan-number)
    :bus-list (* :bus-id (any (* "," :bus-id)))
    :bus-id (+ (/ (<- :d+) ,scan-number) "x")
} input))
(defn earliest-departure [threshold bus]
    (def prev-cycle (math/floor (/ threshold bus)))
    (* bus (+ 1 prev-cycle))
)
(defn collect-departures [threshold busses]
    (seq [bus :in busses] {:bus bus :time (earliest-departure threshold bus)})
)
(defn sorted-departures [d] (sorted-by (fn [d] (get d :time)) d))

(def [threshold busses] (parse-input (file/read stdin :all)))
(def first-bus (first (sorted-departures (collect-departures threshold busses))))
(def delay (- (get first-bus :time) threshold))
(print (* delay (get first-bus :bus)))
