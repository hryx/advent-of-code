(import ./common)

# Slicing in Janet makes a copy, so this is not very efficient
(defn find-addends [numbers target-sum]
    (var i 0)
    (var res nil)
    (while (and (not res) (< i (length numbers)))
        (def sub-range (slice numbers 0 (+ 1 i)))
        (def s (sum sub-range))
        (cond
            (= s target-sum) (set res sub-range)
            (++ i)
        )
    )
    (or res (find-addends (slice numbers 1) target-sum))
)

(def invalid-num (common/find-invalid-xmas-number common/xmas-stream))
(def invalid-index (find-index (partial = invalid-num) common/xmas-stream))

(var i 0)
(var res nil)
(while (and (not res) (< i invalid-index))
    (def chunk (slice common/xmas-stream i invalid-index))
    (set res (find-addends chunk invalid-num))
    (++ i)
)
(assert res (string/format "did not find range that sums to %d" invalid-num))
(print (+ (min ;res) (max ;res)))
