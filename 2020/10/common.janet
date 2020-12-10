(defn get-adapters [input]
    (peg/match ~(any (* (/ (<- :d+) ,scan-number) :s*)) input)
)

(defn get-differences [adapters-]
    (def adapters (sorted adapters-))
    (array/insert adapters 0 0)
    (array/push adapters (+ 3 (last adapters)))
    (def len (length adapters))
    (def diffs (array/new (- len 1)))
    (for i 1 len
        (array/push diffs (- (i adapters) ((- i 1) adapters)))
    )
    diffs
)

(defn distribution [diffs] [
    (count (partial = 1) diffs)
    (count (partial = 3) diffs)
])
