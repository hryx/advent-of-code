(defn check-row [valid-count]
    # (print (get (debug/stack) :tail)) # TODO: make sure these are actually tail calls
    (def line (or (file/read stdin :line) (break valid-count)))
    (def cols (string/split " " (string/trim line)))
    (if (not= 3 (length cols)) (break (check-row valid-count))) # skip empty line
    (def ranges (string/split "-" (get cols 0)))
    (assert (= 2 (length ranges)) "expected range formatted as X-Y")
    (def min-occur (or (scan-number (get ranges 0)) (error "expected range min to be number")))
    (def max-occur (or (scan-number (get ranges 1)) (error "expected range max to be number")))
    (def character (string/slice (get cols 1) 0 1))
    (def password (get cols 2))
    (def occur (length (string/find-all character password)))
    (if (and (>= occur min-occur) (<= occur max-occur))
        (check-row (+ 1 valid-count))
        (check-row valid-count)
    )
)
(print (check-row 0))
