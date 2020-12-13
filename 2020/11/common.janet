(defn parse [input]
    (peg/match '{
        :main (* :s* (any (* :line :s*)))
        :line (group (some :spot))
        :spot (+
            (/ (<- "L") :empty)
            (/ (<- "#") :taken)
            (/ (<- ".") :floor)
        )
    } input)
)

(defn copy-seating [original]
    (def new (array/new (length original)))
    (each row original
        (array/push new (array ;row))
    )
    new
)

(defn count-occupied [seating]
    (reduce (fn [total row]
        (+ total (reduce (fn [total x]
            (+ total (if (= x :taken) 1 0))
        ) 0 row))
    ) 0 seating)
)

(defn occupied? [check-next seating [y x] [dy dx]]
    (def check-pos [(+ y dy) (+ x dx)])
    (def value (get-in seating check-pos))
    (case value
        :taken true
        :empty false
        :floor (check-next check-next seating check-pos [dy dx])
        false
    )
)

(def neighbor-occupied? (partial occupied? comment))
(def line-of-sight-occupied? (partial occupied? occupied?))

(defn count-occupied-adjacent [strat seating row col]
    (def dirs [
        [ 0  1]
        [-1  1]
        [-1  0]
        [-1 -1]
        [ 0 -1]
        [ 1 -1]
        [ 1  0]
        [ 1  1]
    ])
    (reduce (fn [total [dy dx]]
        (+ total (if (strat seating [row col] [dy dx]) 1 0))
    ) 0 dirs)
)

(defn new-state [seating row col]
    (def tol (or (dyn :neighbor-tolerance) 4))
    (def strat (or (dyn :check-neighbor-strategy) neighbor-occupied?))
    (def seat (get-in seating [row col]))
    (or (case seat
        :empty (if (zero? (count-occupied-adjacent strat seating row col)) :taken)
        :taken (if (>= (count-occupied-adjacent strat seating row col) tol) :empty)
    ) seat)
)

(defn do-round [seating]
    (def new (copy-seating seating))
    (for y 0 (length seating)
        (for x 0 (length (y seating))
            (put-in new [y x] (new-state seating y x))
        )
    )
    new
)
