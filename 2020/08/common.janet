(defn parse [input] (peg/match ~{
    :main (* (any :line) (! 1))
    :line (group (* (<- (+ "nop" "acc" "jmp")) :s* :value :s*))
    :value (/ (<- (* (+ "+" "-") :d+)) ,scan-number)
} input))
(defn run-program [instructions]
    (def len (length instructions))
    (def seen (array/new-filled len false))
    (var i 0)
    (var acc 0)
    (while (and (< i len) (not (i seen)))
        (put seen i true)
        (def [op x] (i instructions))
        (+= i (if (= op "jmp") x 1))
        (+= acc (if (= op "acc") x 0))
    )
    {:acc acc :terminated (= i len)}
)
