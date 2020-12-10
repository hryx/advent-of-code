(defn get-candidates [adapters i]
    (def base (i adapters))
    (def candidates @[])
    (var j (+ i 1))
    (while (and
        (< j (length adapters))
        (<= (- (j adapters) base) 3)
    ) (array/push candidates j) (++ j))
    candidates
)

(def memo @[])
(defn count-arrangements [adapters i]
    (if-let [n (get memo i nil)] (break n))
    (if (= i (- (length adapters) 1)) (break 1))
    (var n 0)
    (each j (get-candidates adapters i)
        (+= n (count-arrangements adapters j))
    )
    (i (put memo i n))
)

(import ./common)
(def adapters (common/get-adapters (file/read stdin :all)))
(sort adapters)
(array/insert adapters 0 0)
(array/push adapters (+ 3 (last adapters)))
(print (count-arrangements adapters 0))
